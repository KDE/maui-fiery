#include <QQmlApplicationEngine>
#include <QCommandLineParser>
#include <QQmlContext>

#include <QIcon>

#ifndef STATIC_MAUIKIT
#include "sol_version.h"
#endif

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#else
#include <QApplication>
#endif

#ifdef STATIC_KIRIGAMI
#include "3rdparty/kirigami/src/kirigamiplugin.h"
#endif

#ifdef STATIC_MAUIKIT
#include "3rdparty/mauikit/src/mauikit.h"
#include "mauiapp.h"
#else
#include <MauiKit/mauiapp.h>
#endif

#include <KI18n/KLocalizedContext>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

#ifdef Q_OS_ANDROID
	QGuiApplication app(argc, argv);
	if (!MAUIAndroid::checkRunTimePermissions({"android.permission.WRITE_EXTERNAL_STORAGE"}))
		return -1;
#else
	QApplication app(argc, argv);
#endif

	app.setApplicationName("sol");
	app.setApplicationVersion(SOL_VERSION_STRING);
	app.setApplicationDisplayName("Sol");
	app.setOrganizationName("Maui");
	app.setOrganizationDomain("org.maui.sol");
	app.setWindowIcon(QIcon(":/sol.svg"));
	MauiApp::instance()->setHandleAccounts(false); //for now nota can not handle cloud accounts
	MauiApp::instance()->setCredits ({QVariantMap({{"name", "Camilo Higuita"}, {"email", "milo.h@aol.com"}, {"year", "2019-2020"}})});
	MauiApp::instance ()->setDescription ("Sol allows you to browse the web and organize the web.");
	MauiApp::instance()->setIconName("qrc:/sol.svg");
	MauiApp::instance()->setWebPage("https://mauikit.org");
	MauiApp::instance()->setReportPage("https://invent.kde.org/maui/sol/-/issues");

	QCommandLineParser parser;
	parser.setApplicationDescription("Simple web browser");
	const QCommandLineOption versionOption = parser.addVersionOption();
	parser.addOption(versionOption);
	parser.process(app);

	const QStringList args = parser.positionalArguments();

#ifdef STATIC_KIRIGAMI
	KirigamiPlugin::getInstance().registerTypes();
#endif

#ifdef STATIC_MAUIKIT
	MauiKit::getInstance().registerTypes();
#endif

	QQmlApplicationEngine engine;
	const QUrl url(QStringLiteral("qrc:/main.qml"));
	QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
					 &app, [url, args](QObject *obj, const QUrl &objUrl)
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
