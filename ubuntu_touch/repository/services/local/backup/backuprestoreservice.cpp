/*
 * 2022-2023  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * kaltracker is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "backuprestoreservice.h"
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QDebug>

namespace {

struct TableSpec {
    QString table;
    QStringList columns;
    bool required; // optional tables are missing from backups made by older versions
};

const QList<TableSpec> &tableSpecs()
{
    static const QList<TableSpec> specs = {
        {"user",            {"id", "age", "sex_at_birth", "weight", "height", "activity", "rec_cal", "ap_lo", "ap_hi"}, true},
        {"ingestions",      {"id", "id_user", "name", "nutriscore", "cal", "fat", "carbo", "protein", "date", "meal"}, true},
        {"weight_tracker",  {"id", "id_user", "weight", "date"}, true},
        {"water_tracker",   {"id", "id_user", "cups", "date"}, true},
        {"user_foods_list", {"id", "id_user", "name", "nutriscore", "cal", "fat", "carbo", "protein"}, false},
        {"notes",           {"id", "id_user", "note", "date"}, false},
    };
    return specs;
}

QString csvFileName(const TableSpec &spec)
{
    return spec.table + ".csv";
}

// RFC 4180: quote fields containing a comma, quote or line break; double inner quotes
QString csvEscape(const QString &value)
{
    if (value.contains(',') || value.contains('"') || value.contains('\n') || value.contains('\r')) {
        QString escaped = value;
        escaped.replace("\"", "\"\"");
        return "\"" + escaped + "\"";
    }
    return value;
}

// Parses RFC 4180 CSV, including quoted fields with commas, quotes and line breaks.
// Also reads the unquoted files written by older versions.
QList<QStringList> parseCsv(const QString &content)
{
    QList<QStringList> rows;
    QStringList row;
    QString field;
    bool inQuotes = false;
    bool rowHasData = false;

    for (int i = 0; i < content.size(); ++i) {
        const QChar c = content.at(i);
        if (inQuotes) {
            if (c == '"') {
                if (i + 1 < content.size() && content.at(i + 1) == '"') {
                    field += '"';
                    ++i;
                } else {
                    inQuotes = false;
                }
            } else {
                field += c;
            }
        } else if (c == '"') {
            inQuotes = true;
            rowHasData = true;
        } else if (c == ',') {
            row << field;
            field.clear();
            rowHasData = true;
        } else if (c == '\n' || c == '\r') {
            if (c == '\r' && i + 1 < content.size() && content.at(i + 1) == '\n')
                ++i;
            if (rowHasData || !field.isEmpty()) {
                row << field;
                rows << row;
            }
            row.clear();
            field.clear();
            rowHasData = false;
        } else {
            field += c;
            rowHasData = true;
        }
    }
    if (rowHasData || !field.isEmpty()) {
        row << field;
        rows << row;
    }
    return rows;
}

} // namespace

BackupRestoreService::BackupRestoreService(QObject *parent) : QObject(parent) {}

QString BackupRestoreService::getExportPath() const {
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Export";
}

QString BackupRestoreService::getImportPath() const {
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/Import";
}

void BackupRestoreService::exportData()
{
    QDir().mkpath(getExportPath());

    bool success = true;
    for (const TableSpec &spec : tableSpecs()) {
        success &= writeTableToCsv(spec.table, spec.columns, getExportPath() + "/" + csvFileName(spec));
    }

    if (success) {
        emit exportSuccess();
    } else {
        emit exportFail("Failed to write one or more CSV files.");
    }
}

bool BackupRestoreService::writeTableToCsv(const QString &tableName, const QStringList &headers, const QString &filePath)
{
    // Select the columns by name so the CSV does not depend on the table's column order
    QSqlQuery query;
    if (!query.exec("SELECT " + headers.join(", ") + " FROM " + tableName)) {
        qWarning() << "BackupRestoreService: Failed to read" << tableName << ":" << query.lastError().text();
        return false;
    }

    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) return false;

    QTextStream out(&file);
    out.setCodec("UTF-8");
    out << headers.join(",") << "\n";

    while (query.next()) {
        QStringList row;
        for (int i = 0; i < headers.size(); ++i) {
            row << csvEscape(query.value(i).toString());
        }
        out << row.join(",") << "\n";
    }
    out.flush();
    return out.status() == QTextStream::Ok;
}

void BackupRestoreService::verifyImportFiles()
{
    QString path = getImportPath();

    for (const TableSpec &spec : tableSpecs()) {
        if (spec.required && !QFile::exists(path + "/" + csvFileName(spec))) {
            emit importVerificationFail();
            return;
        }
    }
    emit importVerificationSuccess();
}

void BackupRestoreService::importData()
{
    QSqlDatabase db = QSqlDatabase::database();
    db.transaction();

    QString path = getImportPath();

    // Only replace tables the backup contains, so importing an older backup
    // without user foods or notes keeps the existing ones.
    QList<TableSpec> toImport;
    for (const TableSpec &spec : tableSpecs()) {
        if (QFile::exists(path + "/" + csvFileName(spec))) {
            toImport << spec;
        } else if (spec.required) {
            db.rollback();
            emit importFail("Missing " + csvFileName(spec));
            return;
        }
    }

    bool success = true;
    for (const TableSpec &spec : toImport) {
        QSqlQuery clear;
        if (!clear.exec("DELETE FROM " + spec.table)) {
            qWarning() << "BackupRestoreService: Failed to clear" << spec.table << ":" << clear.lastError().text();
            success = false;
            break;
        }
    }

    if (success) {
        for (const TableSpec &spec : toImport) {
            QStringList placeholders;
            for (int i = 0; i < spec.columns.size(); ++i) placeholders << "?";
            const QString insertQuery = "INSERT INTO " + spec.table + " (" + spec.columns.join(", ") + ") VALUES (" + placeholders.join(", ") + ")";
            success &= importCsvToTable(spec.table, path + "/" + csvFileName(spec), insertQuery, spec.columns.size());
            if (!success) break;
        }
    }

    if (success && db.commit()) {
        emit importSuccess();
    } else {
        db.rollback();
        emit importFail("Failed to parse and insert CSV data.");
    }
}

bool BackupRestoreService::importCsvToTable(const QString &tableName, const QString &filePath, const QString &insertQuery, int expectedColumns)
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) return false;

    QTextStream in(&file);
    in.setCodec("UTF-8");
    QList<QStringList> rows = parseCsv(in.readAll());
    if (!rows.isEmpty()) rows.removeFirst(); // header

    QSqlQuery query;
    query.prepare(insertQuery);

    for (const QStringList &fields : rows) {
        if (fields.size() < expectedColumns) {
            qWarning() << "BackupRestoreService: Skipping malformed row in" << tableName << ":" << fields;
            continue;
        }
        for (int i = 0; i < expectedColumns; ++i) {
            query.bindValue(i, fields[i]);
        }
        if (!query.exec()) {
            qWarning() << "BackupRestoreService: SQL error importing" << tableName << ":" << query.lastError().text();
            return false;
        }
    }
    return true;
}
