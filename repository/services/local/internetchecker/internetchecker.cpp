/*
* 2023  Ivo Xavier 
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; version 3.
*
* kaltracker is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
#include "internetchecker.h"
#include <QNetworkReply>
#include <QNetworkRequest>

InternetChecker::InternetChecker(QObject *parent) : QObject(parent) {
    m_networkManager = new QNetworkAccessManager(this);
    
    connect(m_networkManager, &QNetworkAccessManager::finished, this, &InternetChecker::onReplyFinished);
}

void InternetChecker::checkInternetConnection()
{
    
    QNetworkRequest request(QUrl("https://www.ubports.com"));
    m_networkManager->head(request);
}

void InternetChecker::onReplyFinished(QNetworkReply *reply)
{
    bool isConnected = false;

    
    if (reply->error() == QNetworkReply::NoError) {
        isConnected = true;
    }

    reply->deleteLater();
    
    
    emit internetStatusChanged(isConnected);
}