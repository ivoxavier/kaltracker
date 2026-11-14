/*
 * 2022-2026  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 */



#include "openfoodfactsservice.h"
#include <QNetworkRequest>
#include <QUrl>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>

OpenFoodFactsService::OpenFoodFactsService(QObject *parent)
    : QObject(parent), m_networkManager(new QNetworkAccessManager(this))
{
    connect(m_networkManager, &QNetworkAccessManager::finished,
            this, &OpenFoodFactsService::onNetworkReply);
}

void OpenFoodFactsService::fetchProduct(const QString &barcode)
{
    QUrl url("https://world.openfoodfacts.org/api/v0/product/" + barcode + ".json");
    QNetworkRequest request(url);
    
    request.setHeader(QNetworkRequest::UserAgentHeader, "Kaltracker/1.0 (Ubuntu Touch)");
    
    m_networkManager->get(request);
}

void OpenFoodFactsService::onNetworkReply(QNetworkReply *reply)
{
    if (reply->error() != QNetworkReply::NoError) {
        emit networkError(reply->errorString());
        reply->deleteLater();
        return;
    }

    QByteArray responseData = reply->readAll();
    reply->deleteLater();

    QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData);
    if (!jsonDoc.isObject()) {
        emit productNotFound();
        return;
    }

    QJsonObject rootObj = jsonDoc.object();
    
    // Status 1 = Found, Status 0 = Not Found
    if (rootObj.value("status").toInt() != 1) { 
        emit productNotFound();
        return;
    }

    QJsonObject productObj = rootObj.value("product").toObject();
    QJsonObject nutrimentsObj = productObj.value("nutriments").toObject();

    QVariantMap productData;
    productData["product_name"] = productObj.value("product_name").toString("");
    
    productData["brands"] = productObj.value("brands").toString("");
    productData["image_url"] = productObj.value("image_front_url").toString("");
    productData["quantity"] = productObj.value("quantity").toString("");

    double kcal = 0.0;
    if (nutrimentsObj.contains("energy-kcal_100g")) {
        kcal = nutrimentsObj.value("energy-kcal_100g").toDouble();
    } else if (nutrimentsObj.contains("energy_100g")) {
        kcal = nutrimentsObj.value("energy_100g").toDouble() / 4.184; // Converts kJ in kcal
    }
    productData["cal"] = kcal;


    productData["fat"] = nutrimentsObj.value("fat_100g").toDouble(0.0);
    productData["protein"] = nutrimentsObj.value("proteins_100g").toDouble(0.0);
    productData["carbo"] = nutrimentsObj.value("carbohydrates_100g").toDouble(0.0);
    productData["fiber"] = nutrimentsObj.value("fiber_100g").toDouble(0.0);
    productData["salt"] = nutrimentsObj.value("salt_100g").toDouble(0.0);

    
    productData["nutriscore"] = productObj.value("nutriscore_grade").toString("a");

    productData["nova_groups"] = productObj.value("nova_groups").toVariant().toString(); 

    emit productFound(productData);
}