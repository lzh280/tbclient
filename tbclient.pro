TEMPLATE = app
TARGET = tbclient

VERSION = 2.1.2
DEFINES += VER=\\\"$$VERSION\\\"

QT += network webkit
CONFIG += mobility
MOBILITY += location systeminfo multimedia

INCLUDEPATH += src

HEADERS += \
    src/utility.h \
    src/tbnetworkaccessmanagerfactory.h \
    src/downloader.h \
    src/httpuploader.h \
    src/audiorecorder.h \
    src/scribblearea.h \
    src/flickcharm.h \
    src/qwebviewitem.h

SOURCES += main.cpp \
    src/utility.cpp \
    src/tbnetworkaccessmanagerfactory.cpp \
    src/downloader.cpp \
    src/httpuploader.cpp \
    src/audiorecorder.cpp \
    src/scribblearea.cpp \
    src/flickcharm.cpp \
    src/qwebviewitem.cpp

TRANSLATIONS += i18n/tbclient_zh.ts
RESOURCES += tbclient-res.qrc

#qml folders
folder_symbian3.source = qml/tbclient
folder_symbian3.target = qml

folder_symbian1.source = qml/symbian1
folder_symbian1.target = qml

folder_harmattan.source = qml/harmattan
folder_harmattan.target = qml

folder_js.source = qml/js
folder_js.target = qml

folder_gfx.source = qml/gfx
folder_gfx.target = qml

folder_emo.source = qml/emo
folder_emo.target = qml

DEPLOYMENTFOLDERS = folder_emo

simulator {
    DEPLOYMENTFOLDERS += folder_js folder_harmattan folder_gfx
}

contains(MEEGO_EDITION,harmattan){
    DEFINES += Q_OS_HARMATTAN
    CONFIG += qdeclarative-boostable
    CONFIG += videosuiteinterface-maemo-meegotouch  #video suite
    CONFIG += shareuiinterface-maemo-meegotouch share-ui-plugin share-ui-common #share ui
    CONFIG += mdatauri  #mdatauri
    QT += dbus
    MOBILITY += gallery

    DEPLOYMENTFOLDERS += folder_js folder_harmattan folder_gfx
}

symbian {
    contains(S60_VERSION, 5.0){
        DEFINES += Q_OS_S60V5
        INCLUDEPATH += $$[QT_INSTALL_PREFIX]/epoc32/include/middleware
        INCLUDEPATH += $$[QT_INSTALL_PREFIX]/include/Qt
    } else {
        CONFIG += qt-components
        RESOURCES += symbian-res.qrc
        MMP_RULES += "OPTION gcce -march=armv6 -mfpu=vfp -mfloat-abi=softfp -marm"
    }

    CONFIG += localize_deployment

    TARGET.UID3 = 0x2006622A
    TARGET.CAPABILITY *= \
        NetworkServices \
        SwEvent \
        LocalServices \
        ReadUserData \
        WriteUserData \
        ReadDeviceData \
        WriteDeviceData \
        Location \
        UserEnvironment

    LIBS *= \
        -lMgFetch -lbafl \              #for Selecting Picture
        -lapparc -lws32 -lapgrfx \      #for Launching app
        -lServiceHandler -lnewservice \ #and -lbafl for Camera
        -lavkon \                       #for notification

    DEFINES += QVIBRA

    TARGET.EPOCHEAPSIZE = 0x40000 0x4000000

    vendorinfo = "%{\"Yeatse\"}" ":\"Yeatse\""
    my_deployment.pkg_prerules += vendorinfo
    DEPLOYMENT += my_deployment

    # Symbian have a different syntax
    DEFINES -= VER=\\\"$$VERSION\\\"
    DEFINES += VER=\"$$VERSION\"
}

contains(DEFINES, QVIBRA): include(./QVibra/vibra.pri)

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
