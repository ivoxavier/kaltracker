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
