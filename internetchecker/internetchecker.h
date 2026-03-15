#ifndef INTERNETCHECKER_H
#define INTERNETCHECKER_H

#include <QObject>
#include <QNetworkAccessManager>

class InternetChecker : public QObject {
    Q_OBJECT

public:
    explicit InternetChecker(QObject *parent = nullptr);

signals:
    void internetStatusChanged(bool isConnected);

public slots:
    void checkInternetConnection();

private slots:
    
    void onReplyFinished(class QNetworkReply *reply);

private:
    QNetworkAccessManager *m_networkManager;
};

#endif