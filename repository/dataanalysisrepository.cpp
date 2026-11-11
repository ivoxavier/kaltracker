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


#include "dataanalysisrepository.h"
#include "services/local/database/localstorage.h"
#include <QSqlQuery>
#include <QDebug>
#include <QSqlError>

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

bool DataAnalysisRepository::saveWeight(double weight, const QString &date) 
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    
    query.prepare("INSERT INTO weight_tracker (id_user, weight, date) VALUES (1, ?, ?)");
    query.addBindValue(weight);
    query.addBindValue(date);
    
    if (!query.exec()) {
        qWarning() << "DataAnalysisRepository: Failed to save weight:" << query.lastError().text();
        return false;
    }
    return true;
}

bool DataAnalysisRepository::deleteAllWeightTracker() 
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    
    if (!query.exec("DELETE FROM weight_tracker")) {
        qWarning() << "DataAnalysisRepository: Failed to delete all weight data:" << query.lastError().text();
        return false;
    }
    return true;
}

bool DataAnalysisRepository::saveCup(const QString &date) 
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    
    
    query.prepare("INSERT INTO water_tracker (id_user, cups, date) VALUES (1, 1, :date)");
    query.bindValue(":date", date);
    
    if (!query.exec()) {
        qWarning() << "DataAnalysisRepository: Failed to save cup of water:" << query.lastError().text();
        return false;
    }
    return true;
}

bool DataAnalysisRepository::deleteAllWaterTracker() 
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    
    if (!query.exec("DELETE FROM water_tracker")) {
        qWarning() << "DataAnalysisRepository: Failed to delete all water data:" << query.lastError().text();
        return false;
    }
    return true;
}

QVariantMap DataAnalysisRepository::getChartLineData(const QString &dateFrom, const QString &dateTo) {
    QVariantMap chartData;
    chartData["labels"] = getXWeightTracker(dateFrom, dateTo);
    
    QVariantMap dataset;
    dataset["data"] = getYWeightTracker(dateFrom, dateTo);
    dataset["label"] = "Weight Progress";
    // Optional: Add default chart styling to prevent Chart.js errors if theme colors aren't passed
    dataset["borderColor"] = "#4CAF50"; 
    dataset["backgroundColor"] = "rgba(76, 175, 80, 0.2)";
    dataset["fill"] = false;

    QVariantList datasets;
    datasets.append(dataset);
    
    chartData["datasets"] = datasets;
    return chartData;
}

QVariantMap DataAnalysisRepository::getChartBarData() {
    QVariantMap chartData;
    
    // Nutriscore labels: A, B, C, D, E
    QVariantList labels;
    labels << "A" << "B" << "C" << "D" << "E";
    chartData["labels"] = labels;
    
    QVariantMap dataset;
    dataset["data"] = getYNutriscore();
    dataset["label"] = "Nutriscore Distribution";
    dataset["backgroundColor"] = QVariantList() << "#008b4c" << "#85bb2f" << "#fecb02" << "#ee8100" << "#e63e11";
    
    QVariantList datasets;
    datasets.append(dataset);
    
    chartData["datasets"] = datasets;
    return chartData;
}