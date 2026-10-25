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
};

#endif // DATAANALYSISREPOSITORY_H