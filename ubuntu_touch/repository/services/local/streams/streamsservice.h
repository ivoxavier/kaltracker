#ifndef STREAMSSERVICE_H
#define STREAMSSERVICE_H

#include <QObject>
#include <QTimer>
#include <QSqlDatabase>

class StreamsService : public QObject
{
    Q_OBJECT
public:
    explicit StreamsService(QObject *parent = nullptr);

    Q_INVOKABLE void startMonitoring(bool checkKcal, bool checkDays);
    Q_INVOKABLE void stopMonitoring();

signals:

    void showNotification(const QString &title, const QString &subtitle);

private slots:
    void performChecks();

private:
    bool isDatabaseOpen();
    int getTotalKcalConsumption();
    int getDaysWithoutRegistration();

    QTimer *m_timer;
    bool m_checkKcal;
    bool m_checkDays;


    bool m_hasExecutedKcal;
    bool m_hasExecutedDays;
};

#endif // STREAMSSERVICE_H
