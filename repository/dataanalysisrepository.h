#ifndef DATAANALYSISREPOSITORY_H
#define DATAANALYSISREPOSITORY_H

#include <QObject>
#include <QVariantList>
#include <QString>

class DataAnalysisRepository : public QObject
{
    Q_OBJECT
public:
    explicit DataAnalysisRepository(QObject *parent = nullptr);

    Q_INVOKABLE int getCups(const QString &date);
    Q_INVOKABLE QVariantList getWeightTracker();
    Q_INVOKABLE QVariantList getYWeightTracker(const QString &dateFrom, const QString &dateTo);
    Q_INVOKABLE QVariantList getXWeightTracker(const QString &dateFrom, const QString &dateTo);
    Q_INVOKABLE QVariantList getYNutriscore();
    Q_INVOKABLE bool saveWeight(double weight, const QString &date);
    Q_INVOKABLE bool deleteAllWeightTracker();
    Q_INVOKABLE bool saveCup(const QString &date);
    Q_INVOKABLE bool deleteAllWaterTracker();
};

#endif // DATAANALYSISREPOSITORY_H