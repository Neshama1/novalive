#include <QApplication>
#include <QQmlApplicationEngine>
#include <QCommandLineParser>
#include <QDate>
#include <QIcon>
#include <QQmlContext>

#include <MauiKit3/Core/mauiapp.h>

#include <KAboutData>
#include <KI18n/KLocalizedString>

#include "../project_version.h"

#include "genresbackend.h"
#include "countrybackend.h"
#include "languagebackend.h"
#include "mpvrenderer.h"

//Useful for setting quickly an app template
#define ORG_NAME "KDE"
#define PROJECT_NAME "Nova Live"
#define COMPONENT_NAME "novalive"
#define PROJECT_DESCRIPTION "Internet radio player based on Radio Browser, a free database that provides access to a station database with over 40,000 stations"
#define PROJECT_YEAR "2023"
#define PRODUCT_NAME "novalive"
#define PROJECT_PAGE "https://www.novaflowos.com"
#define REPORT_PAGE "https://bugs.kde.org/enter_bug.cgi?product=novalive"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    setlocale(LC_NUMERIC, "C");

    app.setOrganizationName(QStringLiteral(ORG_NAME));
    app.setWindowIcon(QIcon(":/logo.png"));

    KLocalizedString::setApplicationDomain(COMPONENT_NAME);

    KAboutData about(QStringLiteral(COMPONENT_NAME), i18n(PROJECT_NAME), PROJECT_VERSION_STRING, i18n(PROJECT_DESCRIPTION),
                     KAboutLicense::LGPL_V3, QString("© %1-%2 %3 Development Team").arg(PROJECT_YEAR, QString::number(QDate::currentDate().year()), ORG_NAME), QString(GIT_BRANCH) + "/" + QString(GIT_COMMIT_HASH));

    about.addAuthor(i18n("Miguel Beltrán"), i18n("Developer"), QStringLiteral("hopeandtruth6517@gmail.com"));

    about.setHomepage(PROJECT_PAGE);
    about.setProductName(PRODUCT_NAME);
    about.setBugAddress(REPORT_PAGE);
    about.setOrganizationDomain(PROJECT_URI);
    about.setProgramLogo(app.windowIcon());
    //about.addComponent("Akonadi");
    about.addCredit(i18n("MauiKit Developers"));

    KAboutData::setApplicationData(about);
    MauiApp::instance()->setIconName("qrc:/assets/logo.svg");

    QCommandLineParser parser;
    parser.setApplicationDescription(about.shortDescription());
    parser.process(app);
    about.processCommandLine(&parser);

    QQmlApplicationEngine engine;

    GenresBackend genresbackend;
    qmlRegisterSingletonInstance<GenresBackend>("org.kde.novalive", 1, 0, "GenresBackend", &genresbackend);
    engine.rootContext()->setContextProperty("genresModel",QVariant::fromValue(genresbackend.m_genres));

    CountryBackend countrybackend;
    qmlRegisterSingletonInstance<CountryBackend>("org.kde.novalive", 1, 0, "CountryBackend", &countrybackend);
    engine.rootContext()->setContextProperty("countryNameModel",QVariant::fromValue(countrybackend.m_name));

    LanguageBackend languagebackend;
    qmlRegisterSingletonInstance<LanguageBackend>("org.kde.novalive", 1, 0, "LanguageBackend", &languagebackend);
    engine.rootContext()->setContextProperty("languageModel",QVariant::fromValue(languagebackend.m_language));

    qmlRegisterType<MpvObject>("org.kde.novalive", 1, 0, "MpvObject");

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
