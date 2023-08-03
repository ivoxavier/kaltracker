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

#include "streams.h"
#include <QDebug>
#include <QtSql/QSqlError>
#include <QVariant>
#include <QList>



Streams::Streams(QObject *parent) : QObject(parent)
{
}

QString Streams::databasePath() const
{
    return m_databasePath;
}

void Streams::setDatabasePath(const QString &path)
{
    if (m_databasePath != path)
    {
        m_databasePath = path;
        emit databasePathChanged();
    }
}

bool Streams::openDatabase()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(m_databasePath); // Use the property value here.

    if (!db.open())
    {
        qDebug() << "Error: Failed to open the database!";
        qDebug() << "Error details:" << db.lastError().text();
        qDebug() << m_databasePath;
        return false;
    }

    return true;
}

void Streams::closeDatabase()
{
    QSqlDatabase::database().close();
}

bool Streams::executeQuery(const QString &queryStr)
{
    QSqlQuery query;
    if (!query.exec(queryStr))
    {
        qDebug() << "Error executing query:" << query.lastError().text();
        return false;
    }

    return true;
}

QVariantList Streams::executeSelectQuery(const QString &queryStr)
{
    QVariantList resultList;
    QSqlQuery query(queryStr);
    while (query.next())
    {
        resultList.append(query.value(0));
    }

    return resultList;
}

