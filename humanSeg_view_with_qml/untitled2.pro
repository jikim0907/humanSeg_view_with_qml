QT += quick

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        camera.cpp \
        interfacemanager.cpp \
        main.cpp \
        predictor.cpp \
        video_writer.cpp \
        viewer.cpp

RESOURCES += qml.qrc
QMAKE_CXXFLAGS += -std=c++11
# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target


INCLUDEPATH += /usr/local/include/opencv4
LIBS += -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_imgcodecs -lopencv_videoio

INCLUDEPATH += $$(HOME)/dependencies/tensorflow/
INCLUDEPATH += $$(HOME)/dependencies/tensorflow/tensorflow/lite/tools/make/downloads/absl
INCLUDEPATH += $$(HOME)/dependencies/tensorflow/tensorflow/lite/tools/make/downloads/flatbuffers/include

LIBS += $$(HOME)/dependencies/tensorflow/tensorflow/lite/tools/make/gen/linux_x86_64/lib/libtensorflow-lite.a

HEADERS += \
    buffer.h \
    camera.h \
    cxxopts.h \
    interfacemanager.h \
    predictor.h \
    video_writer.h \
    viewer.h

DISTFILES += \
    data/aurora_540.mp4 \
    data/models/mobilenet_v3_segm_256.tflite \
    data/test.mp4 \
    readme_imgs/demo.gif
