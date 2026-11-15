#include "streamsservice.h"
#include <QSqlQuery>
#include <QVariant>
#include <QDebug>

StreamsService::StreamsService(QObject *parent)
    : QObject(parent), m_checkKcal(false), m_checkDays(false), m_hasExecutedKcal(false), m_hasExecutedDays(false)
{

    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, &StreamsService::performChecks);
}

void StreamsService::startMonitoring(bool checkKcal, bool checkDays)
{
    m_checkKcal = checkKcal;
    m_checkDays = checkDays;


    if (!m_checkKcal && !m_checkDays) return;

    if (!m_timer->isActive()) {
        m_timer->start(9000); //9 seconds
    }
}

void StreamsService::stopMonitoring()
{
    if (m_timer->isActive()) {
        m_timer->stop();
    }
}

bool StreamsService::isDatabaseOpen()
{
    return QSqlDatabase::database().isOpen();
}

int StreamsService::getTotalKcalConsumption()
{
    if (!isDatabaseOpen()) return 0;
    QSqlQuery query("SELECT COALESCE(SUM(cal), 0) FROM ingestions");
    if (query.next()) return query.value(0).toInt();
    return 0;
}

int StreamsService::getDaysWithoutRegistration()
{
    if (!isDatabaseOpen()) return 1;
    QSqlQuery query("SELECT COUNT(*) FROM ingestions WHERE DATE(date) > DATE('now', '-5 day')");
    if (query.next()) return query.value(0).toInt();
    return 0;
}

void StreamsService::performChecks()
{

    if (m_checkKcal && !m_hasExecutedKcal) {
        int totalKcal = getTotalKcalConsumption();
        emit showNotification("Total Calories Registed In The Kaltracker", QString::number(totalKcal));
        m_hasExecutedKcal = true;
    }

    if (m_checkDays && !m_hasExecutedDays) {
        int daysCount = getDaysWithoutRegistration();
        if (daysCount == 0) {
            QTimer::singleShot(3000, this, [this]() {
                emit showNotification("You Haven't Registed Foods In The Last 5 Days", " ");
            });
        }
        m_hasExecutedDays = true;
    }

    if (m_hasExecutedKcal && m_hasExecutedDays) {
        stopMonitoring();
    }
}
