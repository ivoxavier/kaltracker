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
    success &= writeTableToCsv("user", {"id", "age", "sex_at_birth", "weight", "height", "activity", "rec_cal", "ap_lo", "ap_hi"}, getExportPath() + "/user.csv");
    success &= writeTableToCsv("ingestions", {"id", "id_user", "name", "nutriscore", "cal", "fat", "carbo", "protein", "date", "meal"}, getExportPath() + "/ingestions.csv");
    success &= writeTableToCsv("weight_tracker", {"id", "id_user", "weight", "date"}, getExportPath() + "/weight_tracker.csv");
    success &= writeTableToCsv("water_tracker", {"id", "id_user", "cups", "date"}, getExportPath() + "/water_tracker.csv");

    if (success) {
        emit exportSuccess();
    } else {
        emit exportFail("Failed to write one or more CSV files.");
    }
}

bool BackupRestoreService::writeTableToCsv(const QString &tableName, const QStringList &headers, const QString &filePath)
{
    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) return false;

    QTextStream out(&file);
    out << headers.join(",") << "\n";

    QSqlQuery query("SELECT * FROM " + tableName);
    while (query.next()) {
        QStringList row;
        for (int i = 0; i < headers.size(); ++i) {
            row << query.value(i).toString();
        }
        out << row.join(",") << "\n";
    }
    return true;
}

void BackupRestoreService::verifyImportFiles()
{
    QString path = getImportPath();
    QStringList requiredFiles = {"user.csv", "ingestions.csv", "weight_tracker.csv", "water_tracker.csv"};
    
    for (const QString &file : requiredFiles) {
        if (!QFile::exists(path + "/" + file)) {
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

    if (!clearDatabase()) {
        db.rollback();
        emit importFail("Failed to clear existing database.");
        return;
    }

    bool success = true;
    QString path = getImportPath();

    success &= importCsvToTable("user", path + "/user.csv", 
        "INSERT INTO user (id, age, sex_at_birth, weight, height, activity, rec_cal, ap_lo, ap_hi) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", 9);
    success &= importCsvToTable("ingestions", path + "/ingestions.csv", 
        "INSERT INTO ingestions (id, id_user, name, nutriscore, cal, fat, carbo, protein, date, meal) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 10);
    success &= importCsvToTable("weight_tracker", path + "/weight_tracker.csv", 
        "INSERT INTO weight_tracker (id, id_user, weight, date) VALUES (?, ?, ?, ?)", 4);
    success &= importCsvToTable("water_tracker", path + "/water_tracker.csv", 
        "INSERT INTO water_tracker (id, id_user, cups, date) VALUES (?, ?, ?, ?)", 4);

    if (success && db.commit()) {
        emit importSuccess();
    } else {
        db.rollback();
        emit importFail("Failed to parse and insert CSV data.");
    }
}

bool BackupRestoreService::clearDatabase()
{
    QStringList tables = {"water_tracker", "user", "ingestions", "weight_tracker", "user_foods_list", "notes"};
    bool success = true;
    for (const QString &table : tables) {
        QSqlQuery query;
        success &= query.exec("DELETE FROM " + table);
    }
    return success;
}

bool BackupRestoreService::importCsvToTable(const QString &tableName, const QString &filePath, const QString &insertQuery, int expectedColumns)
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) return false;

    QTextStream in(&file);
    if (!in.atEnd()) in.readLine();

    QSqlQuery query;
    query.prepare(insertQuery);

    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList fields = line.split(",");
        
        if (fields.size() >= expectedColumns) {
            for (int i = 0; i < expectedColumns; ++i) {
                query.bindValue(i, fields[i]);
            }
            if (!query.exec()) {
                qDebug() << "SQL Error on import:" << query.lastError().text();
                return false;
            }
        }
    }
    return true;
}