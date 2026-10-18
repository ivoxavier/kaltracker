#ifndef USERMODEL_H
#define USERMODEL_H

#include <QObject>
#include <QMetaType>

struct UserModel
{
    Q_GADGET

    Q_PROPERTY(int id MEMBER id)
    Q_PROPERTY(int age MEMBER age)
    Q_PROPERTY(int sexAtBirth MEMBER sexAtBirth)
    Q_PROPERTY(double weight MEMBER weight)
    Q_PROPERTY(int height MEMBER height)
    Q_PROPERTY(int activity MEMBER activity)
    Q_PROPERTY(int recommendedCalories MEMBER recommendedCalories)
    Q_PROPERTY(int diastolicBloodPressure MEMBER diastolicBloodPressure)
    Q_PROPERTY(int systolicBloodPressure MEMBER systolicBloodPressure)

    public:
        int id = -1;

        int age = 0;
        int sexAtBirth = 0;

        double weight = 0.0;
        int height = 0;

        int activity = 0;
        int recommendedCalories = 0;

        int diastolicBloodPressure = 0;
        int systolicBloodPressure = 0;
};

#endif // USERMODEL_H
