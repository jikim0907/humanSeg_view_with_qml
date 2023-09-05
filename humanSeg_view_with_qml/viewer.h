#ifndef VIEWER_H
#define VIEWER_H

#include <QQuickPaintedItem>
#include <QPainter>
#include <QImage>
#include <QObject>
#include <cmath>
#include <QDebug>

#include "opencv2/opencv.hpp"
#include "predictor.h"
#include "camera.h"

class Viewer: public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QImage m_viewer_image READ getViewerImage WRITE setViewerImage NOTIFY viewerImageChanged)

public:
    Viewer(QQuickItem *parent = nullptr);
    ~Viewer();
    QImage m_viewer_image;

    Q_INVOKABLE void findContours_view();
    QImage cvMatToQImage(const cv::Mat& cvImage);
    QImage contour_img;
    cv::Mat img, masked_img;
    int start_time, end_time;

    Predictor *mPredictor;
    Camera *mCam;

    QImage getViewerImage() const;
    cv::Mat drawContours_Human(cv::Mat img_color);
    void setViewerImage(const QImage &image);

    cv::Scalar fill_Color{0,165,255,255};
    cv::Scalar border_Color{0,0,0,255};
    void paint(QPainter *painter) override;

signals:
    void viewerImageChanged();

public slots:
    void dowork();
};

#endif // VIEWER_H
