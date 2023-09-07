import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Window 2.12
import QtMultimedia 5.12
import interfacemanager 1.0
import viewer 1.0

ApplicationWindow {
    visible: true
    width: 1280
    height: 960
    title:"contour_result"

    Item {
        id: mediaplay_contorl
        anchors.fill: parent

        MediaPlayer {
            id: mediaPlayer
            source: "qrc:///data/aurora_540.mp4"
            autoPlay: true // 자동 재생 설정


            onStatusChanged: {
                if (status === MediaPlayer.EndOfMedia) {
                    mediaPlayer.stop(); // 동영상 재생 중지
                    mediaPlayer.play(); // 다시 재생
                }
            }
        }

        VideoOutput {
            id: videoOutput
            anchors.fill: parent
            source: mediaPlayer
            fillMode: VideoOutput.Stretch
        }
    }

    Item {
        id: view_control
        width: parent.width
        height: parent.height

        Viewer {
            id: cont_img
            anchors.fill: parent
            visible: true
            Component.onCompleted: {
                cont_img.findContours_view();
            }
        }
    }
}
