#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#else
#include <QApplication>
#endif

#include <QCommandLineParser>
#include <QDate>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <MauiKit4/Core/mauiapp.h>
#include <MauiKit4/FileBrowsing/fmstatic.h>
#include <MauiKit4/FileBrowsing/moduleinfo.h>
#include <MauiMan4/settingsstore.h>
#include <MauiMan4/thememanager.h>

#include <KAboutData>
#include <KLocalizedString>

#include "../novalive_version.h"

#include "countrybackend.h"
#include "genresbackend.h"
#include "languagebackend.h"
#include "mpvrenderer.h"

#include <QDirIterator>
#include <QFileInfo>
#include <libavutil/avutil.h>
#include <taglib/taglib.h>

#define NOVALIVE_URI "org.kde.novalive"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
#ifdef Q_OS_ANDROID
    QGuiApplication app(argc, argv);
    if (!MAUIAndroid::checkRunTimePermissions({"android.permission.WRITE_EXTERNAL_STORAGE"}))
        return -1;
#else
    QApplication app(argc, argv);
#endif

    // Qt sets the locale in the QGuiApplication constructor, but libmpv
    // requires the LC_NUMERIC category to be set to "C", so change it back.
    std::setlocale(LC_NUMERIC, "C");

    app.setOrganizationName("KDE");
    app.setWindowIcon(QIcon(":/assets/logo.svg"));
    QGuiApplication::setDesktopFileName(QStringLiteral("project"));

    KLocalizedString::setApplicationDomain("novalive");
    KAboutData about(QStringLiteral("novalive"),
                     QStringLiteral("novalive"),
                     NOVALIVE_VERSION_STRING,
                     i18n("Browse and play your videos."),
                     KAboutLicense::LGPL_V3,
                     APP_COPYRIGHT_NOTICE,
                     QString(GIT_BRANCH) + "/" + QString(GIT_COMMIT_HASH));

    about.addAuthor(QStringLiteral("Miguel Beltrán"), i18n("Developer"), QStringLiteral("novaflowos@gmail.com"));
    about.setHomepage("https://www.novaflowos.com");
    about.setProductName("novalive");
    about.setBugAddress("https://bugs.kde.org/enter_bug.cgi?product=novalive");
    about.setOrganizationDomain(NOVALIVE_URI);
    about.setProgramLogo(app.windowIcon());

    const auto FBData = MauiKitFileBrowsing::aboutData();
    about.addComponent(FBData.name(), MauiKitFileBrowsing::buildVersion(), FBData.version(), FBData.webAddress());

    //    about.addComponent("FFmpeg", "", QString::fromLatin1(av_version_info()), QString::fromLatin1(avutil_license()));

    qputenv("QML_DISABLE_DISK_CACHE", "1");

#ifdef MPV_AVAILABLE
    about.addComponent("MPV");
#endif

    about.addComponent(
        "TagLib",
        "",
        QString("%1.%2.%3").arg(QString::number(TAGLIB_MAJOR_VERSION), QString::number(TAGLIB_MINOR_VERSION), QString::number(TAGLIB_PATCH_VERSION)),
        "https://taglib.org/api/index.html");

    KAboutData::setApplicationData(about);
    MauiApp::instance()->setIconName("qrc:/assets/logo.svg");

    QCommandLineParser parser;

    about.setupCommandLine(&parser);
    parser.process(app);

    about.processCommandLine(&parser);

    const QStringList args = parser.positionalArguments();

    QPair<QString, QList<QUrl>> arguments;
    arguments.first = "collection";

    if (!args.isEmpty()) {
        arguments.first = "viewer";
    }

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/org/kde/novalive/controls/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url, &arguments](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    GenresBackend genresbackend;
    qmlRegisterSingletonInstance<GenresBackend>("org.kde.novalive", 1, 0, "GenresBackend", &genresbackend);
    engine.rootContext()->setContextProperty("genresModel", QVariant::fromValue(genresbackend.m_genres));

    CountryBackend countrybackend;
    qmlRegisterSingletonInstance<CountryBackend>("org.kde.novalive", 1, 0, "CountryBackend", &countrybackend);
    engine.rootContext()->setContextProperty("countryNameModel", QVariant::fromValue(countrybackend.m_name));

    LanguageBackend languagebackend;
    qmlRegisterSingletonInstance<LanguageBackend>("org.kde.novalive", 1, 0, "LanguageBackend", &languagebackend);
    engine.rootContext()->setContextProperty("languageModel", QVariant::fromValue(languagebackend.m_language));

    qmlRegisterType<MpvObject>("org.kde.novalive", 1, 0, "MpvObject");
    qmlRegisterType<MauiMan::ThemeManager>("org.kde.novalive", 1, 0, "ThemeManager");
    qmlRegisterType<MauiMan::SettingsStore>("org.kde.novalive", 1, 0, "SettingsStore");

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

    engine.rootContext()->setContextProperty("initModule", arguments.first);
    engine.rootContext()->setContextProperty("initData", QUrl::toStringList(arguments.second));

    engine.load(url);

#ifdef Q_OS_MACOS
    //    MAUIMacOS::removeTitlebarFromWindow();
    //    MauiApp::instance()->setEnableCSD(true); //for now index can not handle cloud accounts
#endif

    return app.exec();
}
