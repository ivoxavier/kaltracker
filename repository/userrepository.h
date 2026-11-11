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


#ifndef USERREPOSITORY_H
#define USERREPOSITORY_H

#include <QObject>
#include <QVariantMap>

#include "models/usermodel.h"
#include "models/userweightmodel.h"


class UserRepository : public QObject
{
    Q_OBJECT

public:
    explicit UserRepository(QObject *parent = nullptr);

    // Create
    bool createUserProfile(const UserModel &user);
    Q_INVOKABLE bool createUserProfile(const QVariantMap &userData);

    bool saveWeight(const UserWeightModel &userWeight);
    Q_INVOKABLE bool saveWeight(const QVariantMap &userWeightData);

    
    Q_INVOKABLE bool updateWeight(double newWeight);

    Q_INVOKABLE int calculateGoalCalories(int baseCalories, const QString &goalType, int goalValue);

    // Read
    bool getUser(UserModel &user);
    
    
    Q_INVOKABLE QVariantMap getUser(); 

    // Update
    bool updateUser(const UserModel &user);

 
    Q_INVOKABLE bool updateAge(int age);
    Q_INVOKABLE bool updateHeight(int height);
    Q_INVOKABLE bool updateRecCal(int recCal);
    Q_INVOKABLE bool updateActivity(int activity);
    Q_INVOKABLE bool updateApHi(int apHi);
    Q_INVOKABLE bool updateApLo(int apLo);

    
    Q_INVOKABLE double calculateWaterLiters(double weight);
    Q_INVOKABLE double calculateWaterGlasses(double weight);

    
    Q_INVOKABLE int calculateBaseCalories(int age, double weight, int height, int sex, int activity);

    
    Q_INVOKABLE int getMacroCarbo(const QString &plan);
    Q_INVOKABLE int getMacroProtein(const QString &plan);
    Q_INVOKABLE int getMacroFat(const QString &plan);
    Q_INVOKABLE int getBloodPressureIndex(int apHi, int apLo);
    Q_INVOKABLE double getBmi(int height, double weight);
    Q_INVOKABLE int getBmiIndex(double bmi);
    Q_INVOKABLE double getIdealWeight(int sexAtBirth, int height);
    

    Q_INVOKABLE double calculateDailyDeficit(int periodLevel);
    
};

#endif // USERREPOSITORY_H