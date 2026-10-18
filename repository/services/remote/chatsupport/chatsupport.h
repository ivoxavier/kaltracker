/*
 * 2022-2026  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 */



#ifndef CHATSUPPORT_H
#define CHATSUPPORT_H

#include <QObject>
#include <QString>
#include <QVariantList>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>

class ChatSupport : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentEmail READ currentEmail NOTIFY sessionChanged)
    Q_PROPERTY(QString currentUsername READ currentUsername NOTIFY sessionChanged)
    Q_PROPERTY(bool isAdmin READ isAdmin NOTIFY sessionChanged)
    Q_PROPERTY(bool isSubscribed READ isSubscribed NOTIFY sessionChanged)
    Q_PROPERTY(QString renewalDate READ renewalDate NOTIFY sessionChanged)
    Q_PROPERTY(bool isAuthenticated READ isAuthenticated NOTIFY sessionChanged)
    Q_PROPERTY(bool isPaymentPending READ isPaymentPending NOTIFY sessionChanged)
    Q_PROPERTY(QString paypalPaymentUrl READ paypalPaymentUrl CONSTANT)
    Q_PROPERTY(QString subscriptionPrice READ subscriptionPrice NOTIFY priceChanged)

public:
    explicit ChatSupport(QObject *parent = nullptr);

    bool isAdmin() const { return m_isAdmin; }
    QString currentEmail() const { return m_currentEmail; }
    QString currentUsername() const { return m_currentUsername; }
    bool isSubscribed() const { return m_isSubscribed; }
    QString renewalDate() const { return m_renewalDate; }
    bool isAuthenticated() const { return !m_accessToken.isEmpty() && !m_currentEmail.isEmpty(); }
    bool isPaymentPending() const { return m_isPaymentPending; }
    QString paypalPaymentUrl() const { return m_paypalPaymentUrl; }
    QString subscriptionPrice() const { return m_subscriptionPrice; }

    Q_INVOKABLE void createAccount(const QString &email, const QString &username, const QString &password);
    Q_INVOKABLE void login(const QString &email, const QString &password);
    Q_INVOKABLE void logout();
    Q_INVOKABLE void verifySession();
    Q_INVOKABLE void fetchAdminChatList();
    Q_INVOKABLE void deleteAccount();
    Q_INVOKABLE void fetchSubscriptionPrice();
    Q_INVOKABLE void fetchMessages(const QString &targetUserEmail);
    Q_INVOKABLE void sendMessage(const QString &targetUserEmail, const QString &senderEmail, const QString &messageText);
    Q_INVOKABLE void requestPaymentVerification();
    

signals:
    void sessionChanged();
    void priceChanged();
    void createAccountResult(bool success, const QString &message);
    void adminChatListLoaded(const QVariantList &chats);
    void messagesLoaded(const QVariantList &messages);
    void messageSent(bool success);
    void loginResult(bool success, const QString &message);
    void deleteAccountResult(bool success, const QString &message);

private:
    QNetworkRequest createRequest(const QString &endpoint);

    QNetworkAccessManager *m_manager;
    QString m_baseUrl;
    QString m_apiKey;
    QString m_accessToken;
    QString m_currentEmail;
    QString m_currentUsername;
    bool m_isAdmin = false;
    bool m_isSubscribed = false;
    QString m_renewalDate;
    bool m_isPaymentPending = false;
    QString m_paypalPaymentUrl;
    QString m_subscriptionPrice = "...";
};

#endif // CHATSUPPORT_H