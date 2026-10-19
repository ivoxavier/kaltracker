#ifndef USERWEIGHTMODEL_H
#define USERWEIGHTMODEL_H

#include <QObject>
#include <QMetaType>

struct UserWeightModel
{
    Q_GADGET

    Q_PROPERTY(int id_user MEMBER id_user)
    Q_PROPERTY(string date MEMBER date)
    Q_PROPERTY(double weight MEMBER weight)

    public:
        int id_user = -1;

        string date = "";

        double weight = 0.0;
    
};

#endif // USERWEIGHTMODEL_H
