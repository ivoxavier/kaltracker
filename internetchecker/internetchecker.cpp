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
#include <QEventLoop>
#include <QNetworkReply>
#include "internetchecker.h"

InternetChecker::InternetChecker(QObject *parent) : QObject(parent) {
    m_networkManager = new QNetworkAccessManager(this);
    m_networkConfigManager = new QNetworkConfigurationManager(this);
}

void InternetChecker::checkInternetConnection()
{
    bool isConnected = false;

    if (m_networkConfigManager->isOnline()) {
        QNetworkRequest request(QUrl("https://www.ubports.com")); 
        QNetworkReply *reply = m_networkManager->get(request);
        QEventLoop loop;
        QObject::connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
        loop.exec();

        if (reply->error() == QNetworkReply::NoError) {
            isConnected = true;
        }

        reply->deleteLater();
    }

    emit internetStatusChanged(isConnected);
}
