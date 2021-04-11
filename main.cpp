#include <QGuiApplication>
#include <QQuickView>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QQuickView engine(url);
    engine.show();

    return app.exec();
    }
