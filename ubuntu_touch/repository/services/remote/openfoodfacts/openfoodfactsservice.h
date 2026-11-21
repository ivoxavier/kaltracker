/*
 * 2022-2026  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 */



#ifndef OPENFOODFACTSSERVICE_H
#define OPENFOODFACTSSERVICE_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QVariantMap>
#include <QString>

class OpenFoodFactsService : public QObject
{
    Q_OBJECT
public:
    explicit OpenFoodFactsService(QObject *parent = nullptr);

    Q_INVOKABLE void fetchProduct(const QString &barcode);

signals:
    void productFound(QVariantMap productData);
    void productNotFound();
    void networkError(const QString &errorString);

private slots:
    void onNetworkReply(QNetworkReply *reply);

private:
    QNetworkAccessManager *m_networkManager;
};

#endif // OPENFOODFACTSSERVICE_H