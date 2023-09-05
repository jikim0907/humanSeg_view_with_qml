#include "interfacemanager.h"
#include "cxxopts.h"
#include "buffer.h"
#include "viewer.h"
#include "video_writer.h"
#include "opencv2/opencv.hpp"

InterfaceManager* InterfaceManager::mInstance = NULL;

InterfaceManager::InterfaceManager(QObject *parent) :
    QObject(parent)
{
    mInstance = this;

}

//QImage InterfaceManager::getDetectContImg(){

//    std::cout << "tmp" << std::endl;
//        return tmp_cont_img;
//}



InterfaceManager *InterfaceManager::getInstance()
{
    std::cout << "getinstance"<<mInstance <<endl;
    return mInstance;
}
