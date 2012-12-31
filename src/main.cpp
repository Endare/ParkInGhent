// Default empty project template
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/platform/RouteMapInvoker>
#include <bb/platform/LocationMapInvoker>

#include <QLocale>
#include <QTranslator>
#include <Qt/qdeclarativedebug.h>
#include "ParkingsGent.hpp"

using namespace bb::cascades;

void myMessageOutput(QtMsgType type, const char *msg)
 {
     //in this function, you can write the message to any stream!
     switch (type) {
     case QtDebugMsg:
         fprintf(stderr, "Debug: %s\n", msg);
         break;
     case QtWarningMsg:
         fprintf(stderr, "Warning: %s\n", msg);
         break;
     case QtCriticalMsg:
         fprintf(stderr, "Critical: %s\n", msg);
         break;
     case QtFatalMsg:
         fprintf(stderr, "Fatal: %s\n", msg);
         abort();
         break;
     }
 }

Q_DECL_EXPORT int main(int argc, char **argv)
{
	qInstallMsgHandler(myMessageOutput);
    qmlRegisterType<bb::platform::RouteMapInvoker>("bb.platform", 1, 0, "RouteMapInvoker");
    qmlRegisterType<bb::platform::LocationMapInvoker>("bb.platform", 1, 0, "LocationMapInvoker");
    // this is where the server is started etc
    Application app(argc, argv);

    // localization support
    QTranslator translator;
    QString locale_string = QLocale().name();
    QString filename = QString( "ParkingsGent_%1" ).arg( locale_string );
    if (translator.load(filename, "app/native/qm")) {
        app.installTranslator( &translator );
    }

    new ParkingsGent(&app);

    // we complete the transaction started in the app constructor and start the client event loop here
    return Application::exec();
    // when loop is exited the Application deletes the scene which deletes all its children (per qt rules for children)
}
