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




#ifndef USERWEIGHTMODEL_H
#define USERWEIGHTMODEL_H

#include <QObject>
#include <QMetaType>

struct UserWeightModel
{
    Q_GADGET

    Q_PROPERTY(int id_user MEMBER id_user)
    Q_PROPERTY(QString date MEMBER date)
    Q_PROPERTY(double weight MEMBER weight)

    public:
        int id_user = -1;

        QString date = "";

        double weight = 0.0;
    
};

#endif // USERWEIGHTMODEL_H
