#include "viewer.h"
using namespace cv;
using namespace std;

Viewer::Viewer(QQuickItem *parent)
    : QQuickPaintedItem{parent}
{
}

Viewer::~Viewer()
{

}

QImage Viewer::getViewerImage() const
{
    return m_viewer_image;
}

QImage Viewer::cvMatToQImage(const cv::Mat& cvImage) {
    if (cvImage.empty()) {
        return QImage();
    }

    if (cvImage.type() == CV_8UC1) { // Grayscale image
        return QImage(cvImage.data, cvImage.cols, cvImage.rows, static_cast<int>(cvImage.step), QImage::Format_Grayscale8);
    }
    else if (cvImage.type() == CV_8UC3) { // Color image
        cv::Mat rgbImage;
        cv::cvtColor(cvImage, rgbImage, cv::COLOR_BGR2RGB); // OpenCV의 BGR 순서를 RGB로 변경
        return QImage(rgbImage.data, rgbImage.cols, rgbImage.rows, static_cast<int>(rgbImage.step), QImage::Format_RGB888);
    }
    else if (cvImage.type() == CV_8UC4) { // 4-channel image
        return QImage(cvImage.data, cvImage.cols, cvImage.rows, static_cast<int>(cvImage.step), QImage::Format_ARGB32);
    }

    return QImage();
}

cv::Mat Viewer::drawContours_Human(cv::Mat img_color){
    cv::Mat img_gray, img_binary;
    cvtColor(img_color, img_gray, COLOR_BGR2GRAY);

    threshold(img_gray, img_binary, 254, 255, THRESH_BINARY);
    Mat kernel = getStructuringElement(MORPH_RECT, Size(5, 5));

    morphologyEx(img_binary, img_binary, MORPH_CLOSE, kernel);
    cv::bitwise_not(img_binary, img_binary);
    cv::GaussianBlur(img_binary,img_binary,Size(25,25),0,0);
    vector<vector<Point>> contours;
    findContours(img_binary, contours, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);
    cv::Mat img_png(img_color.rows,img_color.cols,CV_8UC4,Scalar(0,0,0,0)); //4channel

    drawContours(img_png, contours, 0, Scalar(255,153,255,255),60);
    drawContours(img_png, contours, 0, Scalar(153,255,204,255),40);
    drawContours(img_png, contours, 0, Scalar(255,204,102,255),20);
    drawContours(img_png, contours, 0, Scalar(255,153,204,255),-1);


    return img_png;
}

void Viewer::findContours_view(){
    std::string input = "../data/test.mp4";
    mCam = new Camera();
    mCam->init(input);
    mCam->start();

    mPredictor = new Predictor();

    bool ret = false;

    while (mCam->is_running) {
        ret = mCam->get_frame(img);
        if (!ret) {
            break;
        }

        masked_img = mPredictor->predict(img);

        if (!img.empty()) {
            masked_img = drawContours_Human(masked_img);
            contour_img = cvMatToQImage(masked_img);
            dowork();
        }
        if (cv::waitKey(1) == 27){ // ESC
            break;
        }
    }
}

void Viewer::dowork(){
    m_viewer_image = contour_img.copy();
    update();
}

void Viewer::setViewerImage(const QImage &image){
    if (m_viewer_image != image) {
        m_viewer_image = image;
        emit viewerImageChanged();
        std::cout << "update?" <<std::endl;
        update();
    }
}

// Draw the QImage in the QQuickPaintedItem
void Viewer::paint(QPainter *painter)
{
    qDebug()<<__FUNCTION__<<"painter Draw";
    painter->drawImage(0, 0, m_viewer_image);
}


