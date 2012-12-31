APP_NAME = ParkingsGent

CONFIG += qt warn_on cascades10
LIBS += -lbbplatform -lbbsystem
QT += xml

include(config.pri)

lupdate_inclusion {
    SOURCES += \
        $$BASEDIR/../src/*.cpp $$BASEDIR/../assets/*.qml
}