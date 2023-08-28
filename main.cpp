#include <QGuiApplication>
#include <QCoreApplication>
#include <QUrl>
#include <QString>
#include <QQuickView>
#include "QZXing.h"
#include "internetchecker/internetchecker.h"
#include <iostream>
#include "git_tag.h"


int main(int argc, char *argv[]) {
   QGuiApplication *app = new QGuiApplication(argc, (char**)argv);
   app->setApplicationName("kaltracker.ivoxavier");

   QCoreApplication::setApplicationVersion(QStringLiteral(BUILD_VERSION));
   
   qmlRegisterType<InternetChecker>("InternetChecker", 0, 1, "InternetChecker");

   QZXing::registerQMLTypes();

   QQuickView *view = new QQuickView();
   view->setSource(QUrl::fromLocalFile("qml/Main.qml"));
   view->setResizeMode(QQuickView::SizeRootObjectToView);
   view->show();

   return app->exec();
}
