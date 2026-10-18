#include "localstorage.h"

#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QSqlQuery>
#include <QDebug>
#include <QSqlError>

LocalStorage& LocalStorage::instance()
{
    static LocalStorage instance;
    return instance;
}

bool LocalStorage::initialize()
{
    const QString dataPath =
        QStandardPaths::writableLocation(
            QStandardPaths::AppDataLocation
        );

    if (dataPath.isEmpty()) {
        qWarning() << "LocalStorage: Could not determine application data directory.";
        return false;
    }

    QDir dir(dataPath);

    if (!dir.mkpath(".")) {
        qWarning() << "LocalStorage: Could not create directory:"
                   << dataPath;
        return false;
    }

    const QString legacyDatabasePath =
        dir.filePath("Databases/baabdb5fba30cf6014354be8893cdf5c.sqlite");

    const QString newDatabasePath =
        dir.filePath("kaltracker_db.sqlite");

    QString databasePath;

    if (QFile::exists(legacyDatabasePath)) {
        databasePath = legacyDatabasePath;

        qDebug() << "LocalStorage: Existing database found:"
                 << databasePath;
    }
    else if (QFile::exists(newDatabasePath)) {
        databasePath = newDatabasePath;

        qDebug() << "LocalStorage: Using existing database:"
                 << databasePath;
    }
    else {
        databasePath = newDatabasePath;

        qDebug() << "LocalStorage: Creating new database:"
                 << databasePath;
    }

    m_localstorage = QSqlDatabase::addDatabase("QSQLITE");
    m_localstorage.setDatabaseName(databasePath);

    if (!m_localstorage.open()) {
        qWarning() << "LocalStorage: Failed to open database:"
                   << m_localstorage.lastError().text();

        return false;
    }

    QSqlQuery query(m_localstorage);

    if (query.exec("PRAGMA table_info(user)")) {
    while (query.next()) {
        qDebug() << "User table column:"
                 << query.value("name").toString();
    }
} else {
    qWarning() << "Failed to inspect user table:"
               << query.lastError().text();
}

    qDebug() << "LocalStorage: Database opened successfully:"
             << databasePath;

    return true;
}

QSqlDatabase LocalStorage::localstorage() const
{
    return m_localstorage;
}
