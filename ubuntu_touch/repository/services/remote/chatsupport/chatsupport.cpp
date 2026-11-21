/*
 * 2022-2026  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 */


#include "chatsupport.h"
#include <QUrl>
#include <QVariantMap>
#include <QFile>
#include <QTextStream>
#include <QStringList>
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QCoreApplication>

ChatSupport::ChatSupport(QObject *parent) : QObject(parent)
{
    m_manager = new QNetworkAccessManager(this);

    m_baseUrl = "";
    m_apiKey = "";
    m_paypalPaymentUrl = "";

    QStringList possiblePaths = {
        ".env",
        QCoreApplication::applicationDirPath() + "/.env",
        QCoreApplication::applicationDirPath() + "/../.env",
        QCoreApplication::applicationDirPath() + "/../../.env",
        ":/.env"
    };

    QFile envFile;
    for (const QString &path : possiblePaths) {
        if (QFile::exists(path)) {
            envFile.setFileName(path);
            break;
        }
    }

    if (!envFile.fileName().isEmpty() && envFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << ".env loadde:" << envFile.fileName();
        QTextStream in(&envFile);
        while (!in.atEnd()) {
            QString line = in.readLine().trimmed();

            if (line.isEmpty() || line.startsWith("#")) continue;

            int separatorIndex = line.indexOf('=');
            if (separatorIndex != -1) {
                QString key = line.left(separatorIndex).trimmed();
                QString value = line.mid(separatorIndex + 1).trimmed();

                if (value.startsWith('"') && value.endsWith('"')) {
                    value = value.mid(1, value.length() - 2);
                }

                if (key == "SUPABASE_URL") {
                    m_baseUrl = value;
                } else if (key == "SUPABASE_KEY") {
                    m_apiKey = value;
                } else if (key == "PAYPAL_PAYMENT_URL") {
                    m_paypalPaymentUrl = value;
                }
            }
        }
        envFile.close();
    } else {
        qWarning() << "No possible to read or find .env";
    }

    QSettings settings;
    m_accessToken = settings.value("chat_access_token", "").toString();
    if (!m_accessToken.isEmpty()) {
        verifySession();
    }
    if (!m_baseUrl.isEmpty()) {
        fetchSubscriptionPrice();
    }
}

void ChatSupport::createAccount(const QString &email, const QString &username, const QString &password)
{
    if (m_baseUrl.isEmpty() || m_apiKey.isEmpty()) {
        qWarning() << "CreateAccount failed: Missing .env configuration";
        emit createAccountResult(false, "CONFIG_ERROR");
        return;
    }

    QNetworkRequest requestAuth = createRequest("/auth/v1/signup");
    QJsonObject jsonAuth;
    jsonAuth["email"] = email;
    jsonAuth["password"] = password;

    QNetworkReply *replyAuth = m_manager->post(requestAuth, QJsonDocument(jsonAuth).toJson());

    connect(replyAuth, &QNetworkReply::finished, this, [this, email, username, replyAuth]() {
        if (replyAuth->error() == QNetworkReply::NoError) {
            QByteArray authResponseData = replyAuth->readAll();
            QJsonObject authResponse = QJsonDocument::fromJson(authResponseData).object();

            m_accessToken = authResponse.value("access_token").toString();
            if (!m_accessToken.isEmpty()) {
                QSettings settings;
                settings.setValue("chat_access_token", m_accessToken);
            }

            QNetworkRequest requestDb = createRequest("/rest/v1/accounts");
            requestDb.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
            requestDb.setRawHeader("Prefer", "return=representation");

            QJsonObject jsonDb;
            jsonDb["email"] = email;
            jsonDb["user"] = username;
            jsonDb["enable"] = false;

            QNetworkReply *replyDb = m_manager->post(requestDb, QJsonDocument(jsonDb).toJson());

            connect(replyDb, &QNetworkReply::finished, this, [this, replyDb]() {
                if (replyDb->error() == QNetworkReply::NoError) {
                    verifySession();
                    emit createAccountResult(true, "ACCOUNT_CREATED");
                } else {
                    qWarning() << "DB Error (createAccount):" << replyDb->readAll();
                    emit createAccountResult(false, "SERVER_ERROR");
                }
                replyDb->deleteLater();
            });

        } else {
            QByteArray responseData = replyAuth->readAll();
            qWarning() << "DB Auth Error (createAccount):" << responseData << replyAuth->errorString();

            if (replyAuth->error() == QNetworkReply::HostNotFoundError ||
                replyAuth->error() == QNetworkReply::TimeoutError ||
                replyAuth->error() == QNetworkReply::TemporaryNetworkFailureError) {
                emit createAccountResult(false, "NETWORK_ERROR");
            } else if (responseData.contains("already registered") || responseData.contains("already exists")) {
                emit createAccountResult(false, "EMAIL_ALREADY_EXISTS");
            } else if (responseData.contains("password")) {
                emit createAccountResult(false, "WEAK_PASSWORD");
            } else {
                emit createAccountResult(false, "REGISTRATION_FAILED");
            }
        }
        replyAuth->deleteLater();
    });
}

void ChatSupport::logout()
{
    QSettings settings;
    settings.remove("chat_access_token");
    m_accessToken = "";
    m_currentEmail = "";
    m_currentUsername = "";
    m_isAdmin = false;
    m_isSubscribed = false;
    m_renewalDate = "";
    m_isPaymentPending = false;
    emit sessionChanged();
}

QNetworkRequest ChatSupport::createRequest(const QString &endpoint)
{
    if (m_accessToken.isEmpty()) {
        QSettings settings;
        m_accessToken = settings.value("chat_access_token", "").toString();
    }

    QUrl url(m_baseUrl + endpoint);
    QNetworkRequest request(url);

    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("apikey", m_apiKey.toUtf8());

    QString bearerToken = m_accessToken.isEmpty() ? m_apiKey : m_accessToken;
    request.setRawHeader("Authorization", QString("Bearer %1").arg(bearerToken).toUtf8());

    return request;
}

void ChatSupport::fetchAdminChatList()
{
    QNetworkRequest request = createRequest("/rest/v1/admin_chat_list?select=*");
    QNetworkReply *reply = m_manager->get(request);

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            QJsonArray array = QJsonDocument::fromJson(reply->readAll()).array();
            emit adminChatListLoaded(array.toVariantList());
        } else {
            qWarning() << "Error on loading chats list" << reply->readAll();
        }
        reply->deleteLater();
    });
}

void ChatSupport::fetchMessages(const QString &targetUserEmail)
{

    QString endpoint = QString("/rest/v1/messages?user_email=eq.%1&select=*&order=created_at.asc").arg(targetUserEmail);
    QNetworkRequest request = createRequest(endpoint);
    QNetworkReply *reply = m_manager->get(request);

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            QJsonArray array = QJsonDocument::fromJson(reply->readAll()).array();
            emit messagesLoaded(array.toVariantList());
        } else {
            qWarning() << "Erron loading mesages" << reply->readAll();
        }
        reply->deleteLater();
    });
}



void ChatSupport::sendMessage(const QString &targetUserEmail, const QString &senderEmail, const QString &messageText)
{


    QNetworkRequest request = createRequest("/rest/v1/messages");
    
    QJsonObject json;
    json["user_email"] = targetUserEmail; 
    json["sender_email"] = senderEmail;   
    json["message"] = messageText;

    QNetworkReply *reply = m_manager->post(request, QJsonDocument(json).toJson());

    connect(reply, &QNetworkReply::finished, this, [this, targetUserEmail, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            emit messageSent(true);
            fetchMessages(targetUserEmail);
        } else {
            qWarning() << "Err on reading messages:" << reply->readAll();
            emit messageSent(false);
        }
        reply->deleteLater();
    });
}

void ChatSupport::verifySession()
{
    QSettings settings;
    m_accessToken = settings.value("chat_access_token", "").toString();

    if (m_accessToken.isEmpty()) {
        m_currentEmail = "";
        m_currentUsername = "";
        m_isAdmin = false;
        m_isSubscribed = false;
        m_renewalDate = "";
        m_isPaymentPending = false;
        emit sessionChanged();
        return;
    }

    QNetworkRequest request = createRequest("/auth/v1/user");
    QNetworkReply *reply = m_manager->get(request);

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            QJsonObject userObj = QJsonDocument::fromJson(reply->readAll()).object();
            m_currentEmail = userObj.value("email").toString();

            
            QString endpoint = QString("/rest/v1/accounts?email=eq.%1&select=user,enable,is_admin,renewal_date").arg(m_currentEmail);
            QNetworkReply *dbReply = m_manager->get(createRequest(endpoint));

            connect(dbReply, &QNetworkReply::finished, this, [this, dbReply]() {
                if (dbReply->error() == QNetworkReply::NoError) {
                    QJsonArray arr = QJsonDocument::fromJson(dbReply->readAll()).array();
                    if (!arr.isEmpty()) {
                        QJsonObject row = arr.first().toObject();
                        m_currentUsername = row.value("user").toString();
                        m_isSubscribed = row.value("enable").toBool();
                        m_isAdmin = row.value("is_admin").toBool();
                        m_isPaymentPending = row.value("payment_pending").toBool();
                        m_renewalDate = row.value("renewal_date").toString();
                    }
                }
                emit sessionChanged();
                dbReply->deleteLater();
            });
        } else {
            logout();
        }
        reply->deleteLater();
    });
}

void ChatSupport::login(const QString &email, const QString &password)
{
    if (m_baseUrl.isEmpty() || m_apiKey.isEmpty()) {
        qWarning() << "Login failed: Missing .env configuration";
        emit loginResult(false, "CONFIG_ERROR");
        return;
    }

    QNetworkRequest requestAuth = createRequest("/auth/v1/token?grant_type=password");
    QJsonObject jsonAuth;
    jsonAuth["email"] = email;
    jsonAuth["password"] = password;

    QNetworkReply *replyAuth = m_manager->post(requestAuth, QJsonDocument(jsonAuth).toJson());

    connect(replyAuth, &QNetworkReply::finished, this, [this, replyAuth]() {
        if (replyAuth->error() == QNetworkReply::NoError) {
            QJsonObject authObj = QJsonDocument::fromJson(replyAuth->readAll()).object();
            m_accessToken = authObj.value("access_token").toString();

            if (!m_accessToken.isEmpty()) {
                QSettings settings;
                settings.setValue("chat_access_token", m_accessToken);
            }

            verifySession();
            emit loginResult(true, "LOGIN_SUCCESS");
        } else {
            QByteArray errData = replyAuth->readAll();
            qWarning() << "DB Auth Error (login):" << errData << replyAuth->errorString();

            if (replyAuth->error() == QNetworkReply::HostNotFoundError ||
                replyAuth->error() == QNetworkReply::TimeoutError ||
                replyAuth->error() == QNetworkReply::TemporaryNetworkFailureError) {
                emit loginResult(false, "NETWORK_ERROR");
            } else if (errData.contains("Invalid login credentials")) {
                emit loginResult(false, "INVALID_CREDENTIALS");
            } else if (errData.contains("Email not confirmed")) {
                emit loginResult(false, "EMAIL_NOT_CONFIRMED");
            } else {
                emit loginResult(false, "AUTH_ERROR");
            }
        }
        replyAuth->deleteLater();
    });
}

void ChatSupport::requestPaymentVerification()
{
    QNetworkRequest request = createRequest("/rest/v1/rpc/request_payment_verification");
    QNetworkReply *reply = m_manager->post(request, QByteArray("{}"));

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            m_isPaymentPending = true;
            emit sessionChanged();
        } else {
            qWarning() << "Err on registering payment request:" << reply->readAll();
        }
        reply->deleteLater();
    });
}

void ChatSupport::fetchSubscriptionPrice()
{
    QNetworkRequest request = createRequest("/rest/v1/app_config?key=eq.subscription_price&select=value");
    QNetworkReply *reply = m_manager->get(request);

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            QJsonArray arr = QJsonDocument::fromJson(reply->readAll()).array();
            if (!arr.isEmpty()) {
                m_subscriptionPrice = arr.first().toObject().value("value").toString();
                emit priceChanged();
            }
        } else {
            qWarning() << "Err on load subsctipion prixe:" << reply->readAll();
        }
        reply->deleteLater();
    });
}

void ChatSupport::deleteAccount()
{
    QNetworkRequest request = createRequest("/rest/v1/rpc/delete_own_account");
    QNetworkReply *reply = m_manager->post(request, QByteArray("{}"));

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            logout();
            emit deleteAccountResult(true, "ACCOUNT_DELETED");
        } else {
            qWarning() << "DB RPC Error (deleteAccount):" << reply->readAll();
            emit deleteAccountResult(false, "DELETE_FAILED");
        }
        reply->deleteLater();
    });
}