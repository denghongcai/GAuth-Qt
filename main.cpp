#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include <QtDeclarative/QtDeclarative>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QmlApplicationViewer viewer;
    qmlRegisterType<QTimer>("timer", 1, 0, "Timer");
    viewer.setMainQmlFile(QLatin1String("qml/Auth/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
