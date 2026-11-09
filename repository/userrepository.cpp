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




#include "userrepository.h"

#include "services/local/database/localstorage.h"
#include <cmath>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariant>
#include <QDebug>


UserRepository::UserRepository(QObject *parent)
    : QObject(parent)
{
}



bool UserRepository::createUserProfile(const UserModel &user)
{
    QSqlQuery query(LocalStorage::instance().localstorage());

    query.prepare(
        "INSERT INTO user "
        "(id, age, sex_at_birth, weight, height, activity, rec_cal, ap_lo, ap_hi) "
        "VALUES "
        "(:id, :age, :sex, :weight, :height, :activity, :calories, :ap_lo, :ap_hi)"
    );

    query.bindValue(":id", user.id);
    query.bindValue(":age", user.age);
    query.bindValue(":sex", user.sexAtBirth);
    query.bindValue(":weight", user.weight);
    query.bindValue(":height", user.height);
    query.bindValue(":activity", user.activity);
    query.bindValue(":calories", user.recommendedCalories);
    query.bindValue(":ap_lo", user.diastolicBloodPressure);
    query.bindValue(":ap_hi", user.systolicBloodPressure);

    if (!query.exec()) {
        qWarning() << "UserRepository: Failed to create user profile:"
                   << query.lastError().text();
        return false;
    }

    return query.numRowsAffected() > 0;
}




bool UserRepository::createUserProfile(const QVariantMap &userData)
{
    UserModel user;
    
    user.id = userData.value("id", 1).toInt();
    user.age = userData.value("age", 0).toInt();
    user.sexAtBirth = userData.value("sexAtBirth", 0).toInt();
    user.weight = userData.value("weight", 0.0).toDouble();
    user.height = userData.value("height", 0).toInt();
    user.activity = userData.value("activity", 0).toInt();
    user.recommendedCalories = userData.value("recommendedCalories", 0).toInt();
    user.diastolicBloodPressure = userData.value("diastolicBloodPressure", 0).toInt();
    user.systolicBloodPressure = userData.value("systolicBloodPressure", 0).toInt();

    return createUserProfile(user); 
}


bool UserRepository::updateUser(const UserModel &user)
{
    QSqlQuery query(LocalStorage::instance().localstorage());

    query.prepare(
        "UPDATE user SET "
        "age = :age, "
        "sex_at_birth = :sex, "
        "weight = :weight, "
        "height = :height, "
        "activity = :activity, "
        "rec_cal = :calories, "
        "ap_lo = :ap_lo, "
        "ap_hi = :ap_hi "
        "WHERE id = :id"
    );

    query.bindValue(":age", user.age);
    query.bindValue(":sex", user.sexAtBirth);
    query.bindValue(":weight", user.weight);
    query.bindValue(":height", user.height);
    query.bindValue(":activity", user.activity);
    query.bindValue(":calories", user.recommendedCalories);
    query.bindValue(":ap_lo", user.diastolicBloodPressure);
    query.bindValue(":ap_hi", user.systolicBloodPressure);
    query.bindValue(":id", user.id);

    if (!query.exec()) {
        qWarning() << "UserRepository: Failed to update user:"
                   << query.lastError().text();

        return false;
    }

    return query.numRowsAffected() > 0;
}



bool UserRepository::updateAge(int age)
{
    QSqlQuery query(LocalStorage::instance().localstorage());

    query.prepare(
        "UPDATE user SET age = :age WHERE id = :id"
    );

    query.bindValue(":age", age);
    query.bindValue(":id", 1);

    if (!query.exec()) {
        qWarning() << "UserRepository: Failed to update age:"
                   << query.lastError().text();

        return false;
    }

    return query.numRowsAffected() > 0;
}

bool UserRepository::updateHeight(int height)
{
    QSqlQuery query(LocalStorage::instance().localstorage());

    query.prepare(
        "UPDATE user SET height = :height WHERE id = :id"
    );

    query.bindValue(":height", height);
    query.bindValue(":id", 1);

    if (!query.exec()) {
        qWarning() << "UserRepository: Failed to update height:"
                   << query.lastError().text();

        return false;
    }

    return query.numRowsAffected() > 0;
}

bool UserRepository::updateRecCal(int recCal)
{
    QSqlQuery query(LocalStorage::instance().localstorage());

    query.prepare(
        "UPDATE user SET rec_cal = :calories WHERE id = :id"
    );

    query.bindValue(":calories", recCal);
    query.bindValue(":id", 1);

    if (!query.exec()) {
        qWarning() << "UserRepository: Failed to update calories:"
                   << query.lastError().text();

        return false;
    }

    return query.numRowsAffected() > 0;
}

bool UserRepository::updateActivity(int activity)
{
    QSqlQuery query(LocalStorage::instance().localstorage());

    query.prepare(
        "UPDATE user SET activity = :activity WHERE id = :id"
    );

    query.bindValue(":activity", activity);
    query.bindValue(":id", 1);

    if (!query.exec()) {
        qWarning() << "UserRepository: Failed to update activity:"
                   << query.lastError().text();

        return false;
    }

    return query.numRowsAffected() > 0;
}

bool UserRepository::updateApHi(int apHi)
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    
    QString sql = QString("UPDATE user SET ap_hi = %1 WHERE id = 1").arg(apHi);

    if (!query.exec(sql)) {
        qWarning() << "UserRepository: Failed to update systolic blood pressure:" << query.lastError().text();
        return false;
    }
    return query.numRowsAffected() > 0;
}

bool UserRepository::updateApLo(int apLo)
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    

    QString sql = QString("UPDATE user SET ap_lo = %1 WHERE id = 1").arg(apLo);

    if (!query.exec(sql)) {
        qWarning() << "UserRepository: Failed to update diastolic blood pressure:" << query.lastError().text();
        return false;
    }
    return query.numRowsAffected() > 0;
}

//UserWeight
//UserWeight
bool UserRepository::saveWeight(const UserWeightModel &userWeight)
{
    QSqlQuery query(LocalStorage::instance().localstorage());

    query.prepare(
        "INSERT INTO weight_tracker "
        "(id_user, weight, date) "
        "VALUES "
        "(:id, :weight, :date)"
    );

    query.bindValue(":id", userWeight.id_user);
    query.bindValue(":weight", userWeight.weight);
    query.bindValue(":date", userWeight.date);

    if (!query.exec()) {
        qWarning() << "UserRepository: Failed to save user weight:"
                   << query.lastError().text();
        return false;
    }

    return query.numRowsAffected() > 0;
}

bool UserRepository::saveWeight(const QVariantMap &userWeightData)
{
    UserWeightModel userWeight;

    userWeight.id_user = userWeightData.value("id_user", 1).toInt();
    userWeight.weight = userWeightData.value("weight", 0.0).toDouble();
    userWeight.date = userWeightData.value("date", "").toString();

    return saveWeight(userWeight);
}

bool UserRepository::updateWeight(double newWeight)
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    
    query.prepare("UPDATE user SET weight = :weight WHERE id = :id");
    query.bindValue(":weight", newWeight);
    query.bindValue(":id", 1);
    
    if (!query.exec()) {
        qWarning() << "UserRepository: Failed to update weight:" << query.lastError().text();
        return false;
    }
    return true;
}

bool UserRepository::getUser(UserModel &user)
{
    QSqlQuery query(LocalStorage::instance().localstorage());

    QString sql = QString(
        "SELECT id, age, sex_at_birth, weight, height, "
        "activity, rec_cal, ap_lo, ap_hi "
        "FROM user "
        "WHERE id = %1"
    ).arg(user.id);

    if (!query.exec(sql)) {
        qWarning() << "UserRepository: Failed to retrieve user:" << query.lastError().text();
        return false;
    }

    if (!query.next()) return false;

    user.id = query.value("id").toInt();
    user.age = query.value("age").toInt();
    user.sexAtBirth = query.value("sex_at_birth").toInt();
    user.weight = query.value("weight").toDouble();
    user.height = query.value("height").toInt();
    user.activity = query.value("activity").toInt();
    user.recommendedCalories = query.value("rec_cal").toInt();
    user.diastolicBloodPressure = query.value("ap_lo").toInt();
    user.systolicBloodPressure = query.value("ap_hi").toInt();

    return true;
}


double UserRepository::calculateWaterLiters(double weight) {
    return weight / 30.0;
}

double UserRepository::calculateWaterGlasses(double weight) {
    double liters = calculateWaterLiters(weight);
    double glass_ml = 0.250;
    return std::round((liters / glass_ml) * 10.0) / 10.0;
}

//  (Mifflin-St Jeor) ---
int UserRepository::calculateBaseCalories(int age, double weight, int height, int sex, int activity) {
    double af = 1.3;
    
    switch (activity) {
        case 0: af = 1.3; break;
        case 1: af = 1.5; break;
        case 2: af = 1.6; break;
        case 3: af = 1.9; break;
        default: af = 1.3; break;
    }
    
    double bmr;
    if (sex == 0) { // Male
        bmr = (10.0 * weight) + (6.25 * height) - (5.0 * age) + 5.0;
    } else {        // Female
        bmr = (10.0 * weight) + (6.25 * height) - (5.0 * age) - 161.0;
    }
    
    return std::round(bmr * af);
}


int UserRepository::getMacroCarbo(const QString &plan) {
    if (plan == "loose") return 130;
    if (plan == "gain") return 172;
    return 150;
}

int UserRepository::getMacroProtein(const QString &plan) {
    if (plan == "loose") return 50;
    if (plan == "gain") return 130;
    return 100;
}

int UserRepository::getMacroFat(const QString &plan) {
    if (plan == "loose") return 41;
    if (plan == "gain") return 50;
    return 45;
}


double UserRepository::calculateDailyDeficit(int periodLevel) {
    double adipose_tissue_1kg = 7700.0;
    
    switch (periodLevel) {
        case 1: // periodOne: 0.5kg por semana
            return (adipose_tissue_1kg * 0.5) / 7.0;
        case 2: // periodTwo: 1.0kg por semana
            return (adipose_tissue_1kg * 1.0) / 7.0;
        case 3: // periodThree: 3.0kg por mês
            return (adipose_tissue_1kg * 3.0) / 30.0;
        case 4: // periodFour: 4.0kg por mês
            return (adipose_tissue_1kg * 4.0) / 30.0;
        default:
            return 0.0;
    }
}

int UserRepository::getBloodPressureIndex(int apHi, int apLo) {
    if (apHi < 120 && apLo < 80) {
        return 0; // Normal
    } else if (apHi >= 120 && apHi < 129 && apLo < 80) {
        return 1; // Elevated
    } else if ((apHi >= 130 && apHi < 139) || (apLo >= 80 && apLo < 89)) {
        return 2; // Stage I
    } else if (apHi >= 140 || apLo >= 90) {
        return 3; // Stage II
    } else {
        return 4; // Hypertensive Crisis
    }
}

double UserRepository::getBmi(int height, double weight) {
    double heightInMeters = height / 100.0;
    return std::round((weight / (heightInMeters * heightInMeters)) * 10.0) / 10.0;
}

int UserRepository::getBmiIndex(double bmi) {
    if (bmi < 18.5) return 1;
    if (bmi >= 18.5 && bmi <= 24.9) return 2;
    if (bmi == 25.0) return 3; // Lógica exata do teu JS
    if (bmi > 25.0 && bmi <= 29.9) return 4;
    return 5;
}


double UserRepository::getIdealWeight(int sexAtBirth, int height) {
    double multiplier = (sexAtBirth > 0) ? 1.5 : 0.9;
    double idealWt = (height - 100) * multiplier;
    return std::round(idealWt * 10.0) / 10.0;
}

int UserRepository::calculateGoalCalories(int baseCalories, const QString &goalType, int goalValue)
{
    int goalAdjustment = 0;
    
    if (goalType == "loose") {
        goalAdjustment = -goalValue;
    } else if (goalType == "gain") {
        goalAdjustment = goalValue;
    }

    return baseCalories + goalAdjustment;
}