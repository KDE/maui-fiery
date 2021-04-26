#include <QQmlApplicationEngine>
#include <QCommandLineParser>
#include <QQmlContext>
#include <QIcon>

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#else
#include <QApplication>
#endif

#include <MauiKit/Core/mauiapp.h>

#include <KI18n/KLocalizedContext>
#include <KI18n/KLocalizedString>

#include "sol_version.h"

#define SOL_URI "org.maui.sol"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_DontCreateNativeWidgetSiblings);
    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps, true);
    QCoreApplication::setAttribute(Qt::AA_DisableSessionManager, true);

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
    KAboutData about(QStringLiteral("sol"), i18n("Sol"), SOL_VERSION_STRING, i18n("Sol allows you to browse the web and organize the web."),
                     KAboutLicense::LGPL_V3, i18n("© 2020 Nitrux Development Team"));
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

#ifdef STATIC_KIRIGAMI
	KirigamiPlugin::getInstance().registerTypes();
#endif

#ifdef STATIC_MAUIKIT
	MauiKit::getInstance().registerTypes();
#endif

	QQmlApplicationEngine engine;
	const QUrl url(QStringLiteral("qrc:/main.qml"));
	QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl)
	{
		if (!obj && url == objUrl)
			QCoreApplication::exit(-1);

//		if(!args.isEmpty())
//			nota->requestFiles(args);

	}, Qt::QueuedConnection);

	engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

	engine.load(url);

	return app.exec();
}
