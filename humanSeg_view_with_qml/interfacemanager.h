#ifndef INTERFACEMANAGER_H
#define INTERFACEMANAGER_H

#include <QObject>
#include "opencv2/opencv.hpp"
#include "predictor.h"
#include "camera.h"

class InterfaceManager: public QObject
{
    Q_OBJECT

public:
    InterfaceManager(QObject *parent = 0);
    static InterfaceManager *getInstance();
    static InterfaceManager *mInstance;

private:
//    Q_INVOKABLE QImage getDetectContImg();

};

#endif // INTERFACEMANAGER_H
