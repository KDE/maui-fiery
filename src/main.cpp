#include <QApplication>
#include <QQmlApplicationEngine>
#include <QCommandLineParser>
#include <QQmlContext>
#include <QIcon>
#include <QDate>

#include <MauiKit/Core/mauiapp.h>

#include <KI18n/KLocalizedString>

#include "models/historymodel.h"
#include "models/bookmarksmodel.h"

#include "controllers/surf.h"

#include "../sol_version.h"

#include <QtWebEngine/QtWebEngine>

#define SOL_URI "org.maui.sol"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps, true);

    QtWebEngine::initialize();
	QApplication app(argc, argv);

	app.setOrganizationName("Maui");
	app.setWindowIcon(QIcon(":/sol.svg"));

	MauiApp::instance()->setIconName("qrc:/sol.svg");

    KLocalizedString::setApplicationDomain("sol");
    KAboutData about(QStringLiteral("sol"), i18n("Sol"), SOL_VERSION_STRING, i18n("Browse and organize the web."),
                     KAboutLicense::LGPL_V3,  i18n("© 2020-%1 Maui Development Team", QString::number(QDate::currentDate().year())), QString(GIT_BRANCH) + "/" + QString(GIT_COMMIT_HASH));
    about.addAuthor(i18n("Camilo Higuita"), i18n("Developer"), QStringLiteral("milo.h@aol.com"));
    about.setHomepage("https://mauikit.org");
    about.setProductName("maui/sol");
    about.setBugAddress("https://invent.kde.org/maui/sol/-/issues");
    about.setOrganizationDomain(SOL_URI);
    about.setProgramLogo(app.windowIcon());

    KAboutData::setApplicationData(about);

    QCommandLineParser parser;

    about.setupCommandLine(&parser);
    parser.process(app);

    about.processCommandLine(&parser);

	QQmlApplicationEngine engine;
	const QUrl url(QStringLiteral("qrc:/main.qml"));
	QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl)
	{
		if (!obj && url == objUrl)
			QCoreApplication::exit(-1);

//		if(!args.isEmpty())
//			Sol::getInstance()->requestUrls(args);

	}, Qt::QueuedConnection);

    qmlRegisterType<surf>(SOL_URI, 1, 0, "Surf");

    qmlRegisterSingletonType<HistoryModel>(SOL_URI, 1, 0, "History", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(scriptEngine)
        Q_UNUSED(engine)

//           engine->setObjectOwnership(platform, QQmlEngine::CppOwnership);
           return new HistoryModel;
       });


    qmlRegisterSingletonType<BookMarksModel>(SOL_URI, 1, 0, "Bookmarks", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(scriptEngine)
        Q_UNUSED(engine)

//           engine->setObjectOwnership(platform, QQmlEngine::CppOwnership);
           return new BookMarksModel;
       });

	engine.load(url);

	return app.exec();
}
