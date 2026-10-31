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
    
};

#endif // USERREPOSITORY_H