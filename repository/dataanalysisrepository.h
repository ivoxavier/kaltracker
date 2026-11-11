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



#ifndef DATAANALYSISREPOSITORY_H
#define DATAANALYSISREPOSITORY_H

#include <QObject>
#include <QVariantList>
#include <QString>

class DataAnalysisRepository : public QObject
{
    Q_OBJECT
public:
    explicit DataAnalysisRepository(QObject *parent = nullptr);

    Q_INVOKABLE int getCups(const QString &date);
    Q_INVOKABLE QVariantList getWeightTracker();
    Q_INVOKABLE QVariantList getYWeightTracker(const QString &dateFrom, const QString &dateTo);
    Q_INVOKABLE QVariantList getXWeightTracker(const QString &dateFrom, const QString &dateTo);
    Q_INVOKABLE QVariantList getYNutriscore();
    Q_INVOKABLE QVariantMap getChartLineData(const QString &dateFrom, const QString &dateTo);
    Q_INVOKABLE QVariantMap getChartBarData();
    Q_INVOKABLE bool saveWeight(double weight, const QString &date);
    Q_INVOKABLE bool deleteAllWeightTracker();
    Q_INVOKABLE bool saveCup(const QString &date);
    Q_INVOKABLE bool deleteAllWaterTracker();
};

#endif // DATAANALYSISREPOSITORY_H