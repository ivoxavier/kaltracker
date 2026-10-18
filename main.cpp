/*
 * 2022-2026  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 */



#include <QGuiApplication>
#include <QCoreApplication>
#include <QUrl>
#include <QString>
#include <QQuickView>
#include <QDir>
#include <QIcon>
#include "QZXing.h"
#include "internetchecker/internetchecker.h"
#include "aiagent/askyouragent.h"
#include "chatsupport/chatsupport.h"
#include <iostream>
#include "git_tag.h"

int main(int argc, char *argv[]) {
    QGuiApplication *app = new QGuiApplication(argc, (char**)argv);
    app->setApplicationName("kaltracker.ivoxavier");
    app->setWindowIcon(QIcon(QCoreApplication::applicationDirPath() + "/assets/logo.svg"));

    QCoreApplication::setApplicationVersion(QStringLiteral(BUILD_VERSION));

    // Ensure relative paths for ("qml/Main.qml", ".env", "assets/"
    QDir::setCurrent(QCoreApplication::applicationDirPath());

    qmlRegisterType<InternetChecker>("InternetChecker", 0, 1, "InternetChecker");
    qmlRegisterType<AskYourAgent>("AiAgents", 0, 1, "AskYourAgent");
    qmlRegisterType<ChatSupport>("ChatSupport", 0, 1, "ChatSupport");

    QZXing::registerQMLTypes();

    QQuickView *view = new QQuickView();
    view->setTitle("KalTracker");
    view->setMinimumSize(QSize(400, 720)); //  phone-like minimum size on laptop
    view->setSource(QUrl::fromLocalFile(QCoreApplication::applicationDirPath() + "/qml/Main.qml"));
    view->setResizeMode(QQuickView::SizeRootObjectToView);
    view->show();

    return app->exec();
}