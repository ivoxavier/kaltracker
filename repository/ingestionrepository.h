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




#ifndef INGESTIONREPOSITORY_H
#define INGESTIONREPOSITORY_H

#include <QObject>
#include <QVariantMap>
#include <QVariantList>
#include <QString>
#include "models/ingestionmodel.h"

class IngestionRepository : public QObject
{
    Q_OBJECT
public:
    explicit IngestionRepository(QObject *parent = nullptr);

    bool saveIngestion(const IngestionModel &ingestion);

    Q_INVOKABLE bool saveIngestion(const QVariantMap &data);
    
    Q_INVOKABLE bool saveIngestionsList(const QVariantList &list, int mealType, const QString &date);

    Q_INVOKABLE int checkUserFoodExists(const QString &productName);

    Q_INVOKABLE bool deleteAllIngestions();
    Q_INVOKABLE bool deleteTodayIngestions();
    Q_INVOKABLE bool deleteMonthYearIngestion(const QString &month, const QString &year);
    Q_INVOKABLE bool deleteIngestion(int id);
    Q_INVOKABLE int checkOldest();
    Q_INVOKABLE bool autoClean();
    Q_INVOKABLE bool deleteSpecificTodayIngestion(int id);
    Q_INVOKABLE int getTotalCalConsumed(const QString &date);
    Q_INVOKABLE int getTotalCalRemaining(const QString &date);
    Q_INVOKABLE int getTotalFoodsConsumed(const QString &date);
    Q_INVOKABLE int getMealCalories(const QString &date, int mealType);
    Q_INVOKABLE double getMacroConsumed(const QString &date, const QString &macroType); 
    
    Q_INVOKABLE QVariantList getMealIngestions(const QString &date, int mealType); 
    Q_INVOKABLE QVariantList getTodayIngestions(const QString &date);
    Q_INVOKABLE QVariantList getAverageCalories(const QString &year);
    Q_INVOKABLE QVariantList getAllFoodsMonth(const QString &month);
    
    
    Q_INVOKABLE bool saveUserFood(const QVariantMap &data);
                                  
    Q_INVOKABLE int isUniqueUserFood(const QString &name);
    
    Q_INVOKABLE QVariantList getUserFoods();
    
    Q_INVOKABLE bool deleteUserFood(int id);
};

#endif // INGESTIONREPOSITORY_H