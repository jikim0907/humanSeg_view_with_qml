#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "interfacemanager.h"
#include "viewer.h"

static QObject *UserInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    //qDebug() << "Creating";

    InterfaceManager *interfacemanager = InterfaceManager::getInstance();

    return interfacemanager;
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    InterfaceManager *interfacemanager = new InterfaceManager;
    qmlRegisterSingletonType<InterfaceManager>("interfacemanager", 1, 0, "InterfaceManager", UserInstance);

    qmlRegisterType<Viewer>("viewer", 1, 0, "Viewer");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
