#include <QGuiApplication>
#include <QCoreApplication>
#include <QUrl>
#include <QString>
#include <QQuickView>
#include "QZXing.h"
#include <iostream>
#include "git_tag.h"
#include "streams/streams.h"


int main(int argc, char *argv[]) {
   QGuiApplication *app = new QGuiApplication(argc, (char**)argv);
   app->setApplicationName("kaltracker.ivoxavier");

   QCoreApplication::setApplicationVersion(QStringLiteral(BUILD_VERSION));
		
   qmlRegisterType<Streams>("StreamsConn", 1, 0, "Streams");
   
   QZXing::registerQMLTypes();

   QQuickView *view = new QQuickView();
   view->setSource(QUrl::fromLocalFile("qml/Main.qml"));
   view->setResizeMode(QQuickView::SizeRootObjectToView);
   view->show();

   return app->exec();
}
