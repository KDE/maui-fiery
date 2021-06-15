#include <QQmlApplicationEngine>
#include <QCommandLineParser>
#include <QQmlContext>
#include <QIcon>
#include <QDate>

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#else
#include <QApplication>
#endif

#include <MauiKit/Core/mauiapp.h>

#include <KI18n/KLocalizedString>

#include "models/historymodel.h"
#include "models/bookmarksmodel.h"

#include "../sol_version.h"

#include <QtWebEngine/QtWebEngine>

#define SOL_URI "org.maui.sol"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_DontCreateNativeWidgetSiblings);
    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps, true);
    QCoreApplication::setAttribute(Qt::AA_DisableSessionManager, true);

    QtWebEngine::initialize();

#ifdef Q_OS_ANDROID
	QGuiApplication app(argc, argv);
	if (!MAUIAndroid::checkRunTimePermissions({"android.permission.WRITE_EXTERNAL_STORAGE"}))
		return -1;
#else
	QApplication app(argc, argv);
#endif

	app.setOrganizationName("Maui");
	app.setWindowIcon(QIcon(":/sol.svg"));

	MauiApp::instance()->setIconName("qrc:/sol.svg");

    KLocalizedString::setApplicationDomain("sol");
    KAboutData about(QStringLiteral("sol"), i18n("Sol"), SOL_VERSION_STRING, i18n("Browse and organize the web."),
                     KAboutLicense::LGPL_V3,  i18n("© 2019-%1 Nitrux Development Team", QString::number(QDate::currentDate().year())), QString(GIT_BRANCH) + "/" + QString(GIT_COMMIT_HASH));
    about.addAuthor(i18n("Camilo Higuita"), i18n("Developer"), QStringLiteral("milo.h@aol.com"));
    about.setHomepage("https://mauikit.org");
    about.setProductName("maui/sol");
    about.setBugAddress("https://invent.kde.org/maui/sol/-/issues");
    about.setOrganizationDomain(SOL_URI);
    about.setProgramLogo(app.windowIcon());

    KAboutData::setApplicationData(about);

    QCommandLineParser parser;
    parser.process(app);

    about.setupCommandLine(&parser);
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
