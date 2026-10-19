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

    bool saveWeight(const UserWeightModel &userWeight)
    Q_INVOKABLE bool saveWeight(const QVariantMap &userWeightData);

    // Read
    bool getUser(UserModel &user);

    // Update
    bool updateUser(const UserModel &user);

    bool updateWeight(double weight);
    bool updateAge(int age);
    bool updateHeight(int height);
    bool updateRecCal(int recCal);
    bool updateActivity(int activity);
    bool updateApHi(int apHi);
    bool updateApLo(int apLo);
};

#endif // USERREPOSITORY_H
