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

#ifndef STREAMS_H
#define STREAMS_H

#include <QObject>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QVariant>
#include <QList>

class Streams : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString databasePath READ databasePath WRITE setDatabasePath NOTIFY databasePathChanged)

public:
    explicit Streams(QObject *parent = nullptr);
    QString databasePath() const;
    void setDatabasePath(const QString &path);

    Q_INVOKABLE bool openDatabase();
    Q_INVOKABLE void closeDatabase();
    Q_INVOKABLE bool executeQuery(const QString &queryStr);
    Q_INVOKABLE QVariantList executeSelectQuery(const QString &queryStr);

signals:
    void databasePathChanged();

private:
    QString m_databasePath;
};

#endif // STREAMS_H

