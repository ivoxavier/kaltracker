#ifndef INGESTIONMODEL_H
#define INGESTIONMODEL_H

#include <QObject>
#include <QString>
#include <QMetaType>

struct IngestionModel
{
    Q_GADGET

    Q_PROPERTY(int id MEMBER id)
    Q_PROPERTY(int userId MEMBER userId)
    Q_PROPERTY(QString name MEMBER name)
    Q_PROPERTY(QString nutriscore MEMBER nutriscore)
    Q_PROPERTY(int calories MEMBER calories)
    Q_PROPERTY(double fat MEMBER fat)
    Q_PROPERTY(double carbs MEMBER carbs)
    Q_PROPERTY(double protein MEMBER protein)
    Q_PROPERTY(int mealType MEMBER mealType)
    Q_PROPERTY(QString date MEMBER date)

public:
    int id = -1;
    int userId = 1;
    QString name = "";
    QString nutriscore = "";
    int calories = 0;
    double fat = 0.0;
    double carbs = 0.0;
    double protein = 0.0;
    int mealType = 0;
    QString date = "";
};

Q_DECLARE_METATYPE(IngestionModel)

#endif // INGESTIONMODEL_H