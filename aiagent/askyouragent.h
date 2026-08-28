/*
 * 2022-2026  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 */


#ifndef ASKYOURAGENT_H
#define ASKYOURAGENT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class AskYourAgent : public QObject {
    Q_OBJECT
public:
    explicit AskYourAgent(QObject *parent = nullptr);

    Q_INVOKABLE void sendMessage(const QString &provider, const QString &apiKey, const QString &modelName, const QString &systemPrompt, const QString &userMessage);

signals:
    void responseReceived(const QString &response);
    void errorOccurred(const QString &error);

private slots:
    void onNetworkReply(QNetworkReply *reply);

private:
    QNetworkAccessManager *m_networkManager;
    QString m_currentProvider;
};

#endif