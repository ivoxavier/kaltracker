#include <QGuiApplication>
#include <QCoreApplication>
#include <QUrl>
#include <QString>
#include <QQuickView>
#include <QQmlContext>
#include <QDebug>
#include "QZXing.h"
#include "internetchecker/internetchecker.h"
#include "aiagent/askyouragent.h"
#include "chatsupport/chatsupport.h"
#include "git_tag.h"
#include "services/local/database/localstorage.h"
#include "userrepository.h"
#include "repository/userrepository.h"
#include "repository/models/usermodel.h"
#include "repository/models/userweightmodel.h"
#include "repository/ingestionrepository.h"
#include "repository/notesrepository.h"
#include "repository/dataanalysisrepository.h"
#include "repository/models/ingestionmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setApplicationName("kaltracker.ivoxavier");

    QCoreApplication::setApplicationVersion(
        QStringLiteral(BUILD_VERSION)
    );

    // Initialize local storage.
    if (!LocalStorage::instance().initialize()) {
        qCritical() << "Failed to initialize LocalStorage.";
        return 1;
    }

    // Create the user repository.
    UserRepository userRepository;
    IngestionRepository ingestionRepository;
    DataAnalysisRepository dataanalysisRepository;
    NotesRepository notesRepository;
    UserModel user;
    user.id = 1;

    // Register existing QML types.
    qRegisterMetaType<UserModel>("UserModel");
    qRegisterMetaType<UserWeightModel>("UserWeightModel");
    qRegisterMetaType<IngestionModel>("IngestionModel");

    qmlRegisterType<InternetChecker>("InternetChecker", 0, 1, "InternetChecker");

    qmlRegisterType<AskYourAgent>("AiAgents", 0, 1, "AskYourAgent");

    qmlRegisterType<ChatSupport>("ChatSupport", 0, 1, "ChatSupport");

    QZXing::registerQMLTypes();

    QQuickView view;

    view.rootContext()->setContextProperty("userRepository",&userRepository);
    view.rootContext()->setContextProperty("ingestionRepository", &ingestionRepository);
    view.rootContext()->setContextProperty("notesRepository", &notesRepository);
    view.rootContext()->setContextProperty("dataanalysisRepository", &dataanalysisRepository);
    view.rootContext()->setContextProperty("localStorage", &LocalStorage::instance());

    view.setSource(QUrl::fromLocalFile("MainView.qml"));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();

    if (userRepository.getUser(user)) {
    qDebug() << "========== USER REPOSITORY TEST ==========";
    qDebug() << "User found!";
    qDebug() << "ID:" << user.id;
    qDebug() << "Age:" << user.age;
    qDebug() << "Sex at birth:" << user.sexAtBirth;
    qDebug() << "Weight:" << user.weight;
    qDebug() << "Height:" << user.height;
    qDebug() << "Activity:" << user.activity;
    qDebug() << "Recommended calories:" << user.recommendedCalories;
    qDebug() << "Diastolic blood pressure:"
             << user.diastolicBloodPressure;
    qDebug() << "Systolic blood pressure:"
             << user.systolicBloodPressure;
} else {
    qWarning() << "UserRepository: Could not retrieve user with ID 1";
}

    return app.exec();
}
