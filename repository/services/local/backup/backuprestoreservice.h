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


#ifndef BACKUPRESTORESERVICE_H
#define BACKUPRESTORESERVICE_H

#include <QObject>
#include <QVariantMap>

class BackupRestoreService : public QObject
{
    Q_OBJECT
public:
    explicit BackupRestoreService(QObject *parent = nullptr);

    Q_INVOKABLE void exportData();
    Q_INVOKABLE void verifyImportFiles();
    Q_INVOKABLE void importData();

signals:
    void exportSuccess();
    void exportFail(const QString &error);
    
    void importVerificationSuccess();
    void importVerificationFail();
    
    void importSuccess();
    void importFail(const QString &error);

private:
    QString getExportPath() const;
    QString getImportPath() const;
    bool writeTableToCsv(const QString &tableName, const QStringList &headers, const QString &filePath);
    bool clearDatabase();
    bool importCsvToTable(const QString &tableName, const QString &filePath, const QString &insertQuery, int expectedColumns);
};

#endif // BACKUPRESTORESERVICE_H