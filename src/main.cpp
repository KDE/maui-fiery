#include <QApplication>
#include <QQmlApplicationEngine>
#include <QCommandLineParser>
#include <QQmlContext>
#include <QIcon>

#include <MauiKit4/Core/mauiapp.h>

#include <KLocalizedString>

#include "models/historymodel.h"
#include "models/bookmarksmodel.h"

#include "controllers/surf.h"
#include "controllers/fierywebprofile.h"
#include "controllers/downloadsmanager.h"

#include "../fiery_version.h"

#include <QtWebEngineQuick>

#define FIERY_URI "org.maui.fiery"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QtWebEngineQuick::initialize();

    app.setOrganizationName("Maui");
    app.setWindowIcon(QIcon(":/fiery.svg"));
    
    KLocalizedString::setApplicationDomain("fiery");
    KAboutData about(QStringLiteral("fiery"),
                     QStringLiteral("Fiery"), 
                     FIERY_VERSION_STRING, 
                     i18n("Browse and organize the web."),
                     KAboutLicense::LGPL_V3, 
                     APP_COPYRIGHT_NOTICE, 
                     QString(GIT_BRANCH) + "/" + QString(GIT_COMMIT_HASH));
    
    about.addAuthor(QStringLiteral("Camilo Higuita"), i18n("Developer"), QStringLiteral("milo.h@aol.com"));
    about.setHomepage("https://mauikit.org");
    about.setProductName("maui/fiery");
    about.setBugAddress("https://invent.kde.org/maui/fiery/-/issues");
    about.setOrganizationDomain(FIERY_URI);
    about.setProgramLogo(app.windowIcon());

    KAboutData::setApplicationData(about);
    MauiApp::instance()->setIconName("qrc:/fiery.png");

    QCommandLineParser parser;

    about.setupCommandLine(&parser);
    parser.process(app);

    about.processCommandLine(&parser);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/app/maui/fiery/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl)
    {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);

        //		if(!args.isEmpty())
        //			Sol::getInstance()->requestUrls(args);

    }, Qt::QueuedConnection);


    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

    qmlRegisterType<surf>(FIERY_URI, 1, 0, "Surf");

    qmlRegisterSingletonInstance<DownloadsManager>(FIERY_URI, 1, 0, "DownloadsManager", &DownloadsManager::instance());

    qmlRegisterType<FieryWebProfile>(FIERY_URI, 1, 0, "FieryWebProfile");
    qmlRegisterSingletonType<HistoryModel>(FIERY_URI, 1, 0, "History", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(scriptEngine)
        Q_UNUSED(engine)

        //           engine->setObjectOwnership(platform, QQmlEngine::CppOwnership);
        return new HistoryModel;
    });


    qmlRegisterSingletonType<BookMarksModel>(FIERY_URI, 1, 0, "Bookmarks", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(scriptEngine)
        Q_UNUSED(engine)

        //           engine->setObjectOwnership(platform, QQmlEngine::CppOwnership);
        return new BookMarksModel;
    });

    engine.load(url);

    return app.exec();
}
