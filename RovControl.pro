QT += quick
QT += widgets qml
CONFIG += c++11
#CONFIG += console

#INCLUDEPATH += libs/opencv3410/include
# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
        src/Log/MyLogging.cpp \
        src/Log/baselog.cpp \
        src/RovApplication.cpp \
        src/RovControlCore.cpp \
        src/RovToolBox.cpp \
        src/Settings/SettingsManager.cpp \
        src/Settings/joysticksettings.cpp \
        src/joystick/joysticker.cpp \
        src/joystick/joystickmanager.cpp \
        src/joystick/joythread.cpp \
        src/keyboard/KeyManager.cpp \
        src/robot/Oilvalve.cpp \
        src/socket/ReceiveManager.cpp \
        src/socket/SendManager.cpp \
        src/socket/SocketManager.cpp \
        src/socket/SocketThread.cpp \
        src/videostreaming/ImageProvider.cpp \
        src/videostreaming/ImageProvider2.cpp \
        src/videostreaming/VideoManager.cpp \
        src/videostreaming/VideoReceiver.cpp

VERSION = 3.1
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
RESOURCES += qml.qrc \
    res.qrc

TRANSLATIONS += \
    SubRov_qt6_zh_CN.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = C:/Qt/6.0.1/msvc2019_64/qml

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =  C:/Qt/Tools/QtCreator/bin

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    src/Log/MyLogging.h \
    src/Log/baselog.h \
    src/RovApplication.h \
    src/RovControlCore.h \
    src/RovToolBox.h \
    src/Settings/SettingsManager.h \
    src/Settings/joysticksettings.h \
    src/joystick/joysticker.h \
    src/joystick/joystickmanager.h \
    src/joystick/joythread.h \
    src/keyboard/KeyManager.h \
    src/robot/Oilvalve.h \
    src/socket/ReceiveManager.h \
    src/socket/SendManager.h \
    src/socket/SocketManager.h \
    src/socket/SocketThread.h \
    src/user_proc/user_proc.h \
    src/videostreaming/ImageProvider.h \
    src/videostreaming/ImageProvider2.h \
    src/videostreaming/VideoManager.h \
    src/videostreaming/VideoReceiver.h


LIBS += $$PWD/libs/users/user_proc.lib
#LIBS += -L$$PWD/libs -luser_proc

CONFIG(debug, debug|release ){
    CONFIG+= DebugBuild
    DESTDIR  = $${OUT_PWD}/debug
} else : CONFIG(release, debug| release){
    CONFIG += ReleaseBuild
    DESTDIR = $${OUT_PWD}/release
}


win32{
    CONFIG += WindowsBuild

}

## Application icon get
iOSBuild{
    ICON = logo.ico
}
WindowsBuild{
    RC_ICONS = "./res/sys/favicon_1.ico"
}
unix {
    CONFIG += LinuxBuild
}

# set out path
!iOSBuild {
    OBJECTS_DIR  = $${OUT_PWD}/obj
    MOC_DIR      = $${OUT_PWD}/moc
    UI_DIR       = $${OUT_PWD}/ui
    RCC_DIR      = $${OUT_PWD}/rcc
}
ReleaseBuild {
    DEFINES += QT_NO_DEBUG QT_MESSAGELOGCONTEXT
    CONFIG += force_debug_info  # Enable debugging symbols on release builds
    !iOSBuild {
        !AndroidBuild {
            CONFIG += ltcg              # Turn on link time code generation
        }
    }

    WindowsBuild {
        # Run compilation using VS compiler using multiple threads
        QMAKE_CXXFLAGS += -MP

        # Enable function level linking and enhanced optimized debugging
        QMAKE_CFLAGS_RELEASE   += /Gy /Zo
        QMAKE_CXXFLAGS_RELEASE += /Gy /Zo
        QMAKE_CFLAGS_RELEASE_WITH_DEBUGINFO   += /Gy /Zo
        QMAKE_CXXFLAGS_RELEASE_WITH_DEBUGINFO += /Gy /Zo

        # Eliminate duplicate COMDATs
        QMAKE_LFLAGS_RELEASE += /OPT:ICF
#        QMAKE_LFLAGS_RELEASE_WITH_DEBUGINFO += /OPT:ICF


        # Opencv lib path
#        OPENCV_ROOT = $$PWD/libs/opencv3410 #D:/ImDeveloper/Environment/opencv-3.4.10 #D:/ImDeveloper/Environment/opencv45/build

        OPENCV_ROOT = D:/ImDeveloper/Environment/opencv45/build2
        OPENCV_LIB = $$OPENCV_ROOT/lib/Release  # x64/vc14/lib
#        LIBS += -L$$OPENCV_LIB \
#            -lopencv_world3410 -lopencv_world3410d

#        LIBS += -L$$OPENCV_LIB \
#            -lopencv_world450 -lopencv_world450d

    LIBS += -L$$OPENCV_LIB \
        -lopencv_calib3d450 -lopencv_core450 -lopencv_dnn450 -lopencv_features2d450 -lopencv_flann450 \
        -lopencv_gapi450 -lopencv_highgui450 -lopencv_imgcodecs450 -lopencv_imgproc450 -lopencv_ml450 \
        -lopencv_objdetect450 -lopencv_photo450 -lopencv_stitching450 -lopencv_ts450 -lopencv_video450 \
        -lopencv_videoio450 -lade
        INCLUDEPATH += $$OPENCV_ROOT/include \
            $$OPENCV_ROOT/include/opencv2

        QMAKE_POST_LINK += $$escape_expand(\\n) xcopy \"$$PWD\\libs\\users\\user_*.dll\" \"$$DESTDIR\\libs\" /S/Y $$escape_expand(\\n)
        QMAKE_POST_LINK += $$escape_expand(\\n) xcopy \"$$PWD\\libs\\gstreamer\\*\" \"$$DESTDIR\\libs\" /S/Y $$escape_expand(\\n)
#        QMAKE_POST_LINK += $$escape_expand(\\n) xcopy \"$$PWD\\libs\\gstreamer\\*.dll\" \"$$DESTDIR\" /S/Y $$escape_expand(\\n)
        QMAKE_POST_LINK += $$escape_expand(\\n) xcopy \"$$OPENCV_ROOT\\bin\\opencv_*.dll\" \"$$DESTDIR\\libs\" /S/Y $$escape_expand(\\n)

#        GST_ROOT = c:/gstreamer/1.0/msvc_x86_64
#        exists($$GST_ROOT) {
#            CONFIG      += VideoEnabled

#            LIBS        += -L$$GST_ROOT/lib -lgstreamer-1.0 -lgstgl-1.0 -lgstvideo-1.0 -lgstbase-1.0
#            LIBS        += -lglib-2.0 -lintl -lgobject-2.0

#            INCLUDEPATH += \
#                $$GST_ROOT/include \
#                $$GST_ROOT/include/gstreamer-1.0 \
#                $$GST_ROOT/include/glib-2.0 \
#                $$GST_ROOT/lib/gstreamer-1.0/include \
#                $$GST_ROOT/lib/glib-2.0/include

#            DESTDIR_WIN = $$replace(DESTDIR, "/", "\\")
#            GST_ROOT_WIN = $$replace(GST_ROOT, "/", "\\")

#            # Copy main GStreamer runtime files
#            QMAKE_POST_LINK += $$escape_expand(\\n) xcopy \"$$GST_ROOT_WIN\\bin\*.dll\" \"$$DESTDIR_WIN\" /S/Y $$escape_expand(\\n)
#            QMAKE_POST_LINK += xcopy \"$$GST_ROOT_WIN\\bin\*.\" \"$$DESTDIR_WIN\" /S/Y $$escape_expand(\\n)

#            # Copy GStreamer plugins
#            QMAKE_POST_LINK += $$escape_expand(\\n) xcopy \"$$GST_ROOT_WIN\\lib\\gstreamer-1.0\\*.dll\" \"$$DESTDIR_WIN\\gstreamer-plugins\\\" /Y $$escape_expand(\\n)
#            QMAKE_POST_LINK += $$escape_expand(\\n) xcopy \"$$GST_ROOT_WIN\\lib\\gstreamer-1.0\\validate\\*.dll\" \"$$DESTDIR_WIN\\gstreamer-plugins\\validate\\\" /Y $$escape_expand(\\n)
#        }
#        QMAKE_POST_LINK += $$escape_expand(\\n) xcopy \"$$PWD/libs/joystick/winmm.dll\" \"$$DESTDIR\" /S/Y $$escape_expand(\\n)

        message("copy opencv")
    }
}
