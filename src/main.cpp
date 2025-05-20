// INCLUDE (BASIC SET)

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QCommandLineParser>
#include <QFileInfo>
#include <QIcon>

#include <KAboutData>
#include <KLocalizedString>

// INCLUDE

#include <MauiKit4/Core/mauiapp.h>
#include <MauiKit4/FileBrowsing/fmstatic.h>
#include <MauiKit4/FileBrowsing/moduleinfo.h>
#include <MauiMan4/thememanager.h>

#include "code/countrybackend.h"
#include "code/genresbackend.h"
#include "code/languagebackend.h"

#include "code/mpvitem.h"
#include "code/mpvproperties.h"

#include "../novalive_version.h"

#define NOVALIVE_URI "org.kde.novalive"

// MAIN FUNCTION

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    // APP

#ifdef Q_OS_ANDROID
    QGuiApplication app(argc, argv);
    if (!MAUIAndroid::checkRunTimePermissions({"android.permission.WRITE_EXTERNAL_STORAGE"}))
        return -1;
#else
    QGuiApplication app(argc, argv);
#endif

    app.setOrganizationName("KDE");
    app.setWindowIcon(QIcon(":/assets/logo.svg"));
    QGuiApplication::setDesktopFileName(QStringLiteral("project"));
    KLocalizedString::setApplicationDomain("novalive");

    // SETS THE VALUE OF THE ENVIRONMENT VARIABLES

    // To make requests to a REST API (RadioBrowser) XMLHttpRequest is used.
    // Set QML_XHR_ALLOW_FILE_READ to 1 to access local files (read).

    qputenv("QML_XHR_ALLOW_FILE_READ", "1");

    // SETS THE LOCALE

    // Qt sets the locale in the QGuiApplication constructor, but libmpv
    // requires the LC_NUMERIC category to be set to "C", so change it back.

    std::setlocale(LC_NUMERIC, "C");

    // ABOUT DIALOG

    KAboutData about(QStringLiteral("novalive"),
                     QStringLiteral("novalive"),
                     NOVALIVE_VERSION_STRING,
                     i18n("Browse and play your online radio stations."),
                     KAboutLicense::LGPL_V3,
                     APP_COPYRIGHT_NOTICE,
                     QString(GIT_BRANCH) + "/" + QString(GIT_COMMIT_HASH));

    about.addAuthor(QStringLiteral("Miguel Beltrán"), i18n("Developer"), QStringLiteral("novaflowos@gmail.com"));
    about.setHomepage("https://www.novaflowos.com");
    about.setProductName("novalive");
    about.setBugAddress("https://github.com/Neshama1/novalive/issues");
    about.setOrganizationDomain(NOVALIVE_URI);
    about.setProgramLogo(app.windowIcon());

    const auto FBData = MauiKitFileBrowsing::aboutData();
    about.addComponent(FBData.name(), MauiKitFileBrowsing::buildVersion(), FBData.version(), FBData.webAddress());

    KAboutData::setApplicationData(about);
    MauiApp::instance()->setIconName("qrc:/assets/logo.svg");

    // COMMAND LINE

    QCommandLineParser parser;

    about.setupCommandLine(&parser);
    parser.process(app);
    about.processCommandLine(&parser);

    const QStringList args = parser.positionalArguments();
    QPair<QString, QList<QUrl>> arguments;

    // arguments.first
    // args.isEmpty()

    // QQMLAPPLICATIONENGINE

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/org/kde/novalive/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url, &arguments](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    // C++ BACKENDS

    GenresBackend genresbackend;
    qmlRegisterSingletonInstance<GenresBackend>("org.kde.novalive", 1, 0, "GenresBackend", &genresbackend);
    engine.rootContext()->setContextProperty("genresModel", QVariant::fromValue(genresbackend.m_genres));

    CountryBackend countrybackend;
    qmlRegisterSingletonInstance<CountryBackend>("org.kde.novalive", 1, 0, "CountryBackend", &countrybackend);
    engine.rootContext()->setContextProperty("countryNameModel", QVariant::fromValue(countrybackend.m_name));

    LanguageBackend languagebackend;
    qmlRegisterSingletonInstance<LanguageBackend>("org.kde.novalive", 1, 0, "LanguageBackend", &languagebackend);
    engine.rootContext()->setContextProperty("languageModel", QVariant::fromValue(languagebackend.m_language));

    // TIPOS

    qmlRegisterType<MauiMan::ThemeManager>("org.kde.novalive", 1, 0, "ThemeManager");
    qmlRegisterType<MpvItem>("org.kde.novalive", 1, 0, "MpvItem");
    qmlRegisterType<MpvProperties>("org.kde.novalive", 1, 0, "MpvProperties");

    // LOAD MAIN.QML

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
    //engine.loadFromModule("org.kde.novalive", "Main");
    engine.load(url);

    // EXEC APP

    return app.exec();
}
