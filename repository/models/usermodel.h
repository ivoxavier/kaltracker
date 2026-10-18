#ifndef USERMODEL_H
#define USERMODEL_H

struct UserModel
{
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
