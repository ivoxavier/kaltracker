#include "dataanalysisrepository.h"
#include "services/local/database/localstorage.h"
#include <QSqlQuery>

DataAnalysisRepository::DataAnalysisRepository(QObject *parent) : QObject(parent) {}

int DataAnalysisRepository::getCups(const QString &date) {
    QSqlQuery query(LocalStorage::instance().localstorage());
    query.prepare("SELECT SUM(cups) AS totalCups FROM water_tracker WHERE date = :date");
    query.bindValue(":date", date);
    if (query.exec() && query.next()) return query.value("totalCups").toInt();
    return 0;
}

QVariantList DataAnalysisRepository::getWeightTracker() {
    QVariantList list;
    QSqlQuery query(LocalStorage::instance().localstorage());
    if (query.exec("SELECT weight FROM weight_tracker ORDER BY date ASC")) {
        while (query.next()) list.append(query.value("weight").toDouble());
    }
    return list;
}

QVariantList DataAnalysisRepository::getYWeightTracker(const QString &dateFrom, const QString &dateTo) {
    QVariantList list;
    QSqlQuery query(LocalStorage::instance().localstorage());
    query.prepare("SELECT weight FROM weight_tracker WHERE date(date) >= date(:dateFrom) AND date(date) <= date(:dateTo) ORDER BY date ASC");
    query.bindValue(":dateFrom", dateFrom);
    query.bindValue(":dateTo", dateTo);
    if (query.exec()) {
        while (query.next()) list.append(query.value("weight").toDouble());
    }
    return list;
}

QVariantList DataAnalysisRepository::getXWeightTracker(const QString &dateFrom, const QString &dateTo) {
    QVariantList list;
    QSqlQuery query(LocalStorage::instance().localstorage());
    query.prepare("SELECT date FROM weight_tracker WHERE date(date) >= date(:dateFrom) AND date(date) <= date(:dateTo) ORDER BY date ASC");
    query.bindValue(":dateFrom", dateFrom);
    query.bindValue(":dateTo", dateTo);
    if (query.exec()) {
        while (query.next()) list.append(query.value("date").toString());
    }
    return list;
}

QVariantList DataAnalysisRepository::getYNutriscore() {
    QVariantList list;
    QSqlQuery query(LocalStorage::instance().localstorage());
    if (query.exec("SELECT COUNT(nutriscore) AS nutriscore_count FROM ingestions GROUP BY nutriscore ORDER BY 1 ASC")) {
        while (query.next()) list.append(query.value("nutriscore_count").toInt());
    }
    return list;
}