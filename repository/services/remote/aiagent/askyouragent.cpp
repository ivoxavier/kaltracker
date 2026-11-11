/*
 * 2022-2026  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 */



#include "askyouragent.h"
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QUrl>

AskYourAgent::AskYourAgent(QObject *parent) : QObject(parent) {
    m_networkManager = new QNetworkAccessManager(this);
    connect(m_networkManager, &QNetworkAccessManager::finished, this, &AskYourAgent::onNetworkReply);
}

void AskYourAgent::sendMessage(const QString &provider, const QString &apiKey, const QString &modelName, const QString &systemPrompt, const QString &userMessage) {
    m_currentProvider = provider.toLower();
    
    QString cleanKey = apiKey.trimmed(); 
    QString cleanModel = modelName.trimmed();
    
    
    if (cleanModel.isEmpty()) {
        cleanModel = "gemini-3.5-flash"; 
    }

    QNetworkRequest request;
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QJsonObject payload;

    if (m_currentProvider == "gemini") {
        QString urlString = "https://generativelanguage.googleapis.com/v1beta/models/" + cleanModel + ":generateContent?key=" + cleanKey;
        
        QUrl url;
        url.setUrl(urlString, QUrl::StrictMode);
        
        request.setUrl(url);

        QJsonObject systemInstruction;
        QJsonArray sysPartsArray;
        QJsonObject systemParts;
        systemParts["text"] = systemPrompt;
        sysPartsArray.append(systemParts);
        systemInstruction["parts"] = sysPartsArray;
        payload["system_instruction"] = systemInstruction;

        QJsonArray contents;
        QJsonObject userContent;
        userContent["role"] = "user";
        QJsonObject userParts;
        userParts["text"] = userMessage;
        QJsonArray userPartsArray;
        userPartsArray.append(userParts);
        userContent["parts"] = userPartsArray;
        contents.append(userContent);

        payload["contents"] = contents;
        
       /*
       other models will be here
       
       */
    } else {
        emit errorOccurred("Model not supported");
        return;
    }

    QJsonDocument doc(payload);
    m_networkManager->post(request, doc.toJson());
}

void AskYourAgent::onNetworkReply(QNetworkReply *reply) {
    if (reply->error() != QNetworkReply::NoError) {
        emit errorOccurred(reply->errorString());
        reply->deleteLater();
        return;
    }

    QByteArray responseData = reply->readAll();
    QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData);
    QJsonObject jsonObj = jsonDoc.object();
    QString answer;

    if (m_currentProvider == "gemini") {
        QJsonArray candidates = jsonObj["candidates"].toArray();
        if (!candidates.isEmpty()) {
            QJsonObject content = candidates[0].toObject()["content"].toObject();
            QJsonArray parts = content["parts"].toArray();
            if (!parts.isEmpty()) {
                answer = parts[0].toObject()["text"].toString();
            }
        }
    } 
    if (answer.isEmpty()) {
        emit errorOccurred("Error while processing API request.");
    } else {
        emit responseReceived(answer);
    }

    reply->deleteLater();
}