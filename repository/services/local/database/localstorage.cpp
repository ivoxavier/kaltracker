#include "localstorage.h"

#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QSqlQuery>
#include <QDebug>
#include <QSqlError>
#include <QStringList>

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

void LocalStorage::dropTables()
{
    QSqlQuery query(m_localstorage);
    
    QStringList tablesToDrop = {
        "user",
        "ingestions",
        "user_foods_list",
        "weight_tracker",
        "water_tracker",
        "notes"
    };

    foreach (const QString &table, tablesToDrop) {
        QString queryString = QString("DROP TABLE IF EXISTS %1").arg(table);
        if (!query.exec(queryString)) {
            qWarning() << "Error dropping table" << table << ":" << query.lastError().text();
        }
    }
    
    qDebug() << "Storage: dropped Tables via C++";
}


void LocalStorage::createTables(){
     QSqlQuery query(m_localstorage);

     QStringList createStatements = {
        "CREATE TABLE IF NOT EXISTS user("
        "id INTEGER PRIMARY KEY, "
        "age INTEGER, "
        "sex_at_birth INTEGER, "
        "weight DOUBLE, "
        "height INTEGER, "
        "activity INTEGER, "
        "rec_cal INTEGER, "
        "ap_lo INTEGER, "
        "ap_hi INTEGER)",

        "CREATE TABLE IF NOT EXISTS ingestions("
        "id INTEGER PRIMARY KEY, "
        "id_user INTEGER, "
        "name TEXT, "
        "nutriscore TEXT, "
        "cal INTEGER, "
        "fat DOUBLE, "
        "carbo DOUBLE, "
        "protein DOUBLE, "
        "date TEXT, "
        "meal INTEGER, "
        "FOREIGN KEY(id_user) REFERENCES user(id))",

        "CREATE TABLE IF NOT EXISTS user_foods_list("
        "id INTEGER PRIMARY KEY, "
        "id_user INTEGER, "
        "name TEXT, "
        "nutriscore TEXT, "
        "cal INTEGER, "
        "fat DOUBLE, "
        "carbo DOUBLE, "
        "protein DOUBLE, "
        "FOREIGN KEY(id_user) REFERENCES user(id))",

        "CREATE TABLE IF NOT EXISTS weight_tracker("
        "id INTEGER PRIMARY KEY, "
        "id_user INTEGER, "
        "weight DOUBLE, "
        "date TEXT, "
        "FOREIGN KEY(id_user) REFERENCES user(id))",

        "CREATE TABLE IF NOT EXISTS water_tracker("
        "id INTEGER PRIMARY KEY, "
        "id_user INTEGER, "
        "cups INTEGER, "
        "date TEXT, "
        "FOREIGN KEY(id_user) REFERENCES user(id))",

        "CREATE TABLE IF NOT EXISTS notes("
        "id INTEGER PRIMARY KEY, "
        "id_user INTEGER, "
        "note TEXT, "
        "date TEXT, "
        "FOREIGN KEY(id_user) REFERENCES user(id))"
    };

    foreach (const QString &statement, createStatements) {
        if (!query.exec(statement)) {
            qWarning() << "Error creating table:" << query.lastError().text();
        }
    }
    
    qDebug() << "Storage: Tables Created via C++";
}


QSqlDatabase LocalStorage::localstorage() const
{
    return m_localstorage;
}
