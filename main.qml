import QtQuick 2.12
import QtMultimedia 5.15
import QtQml 2.15
import QtQuick.Window 2.12

Window {
    id: main
    width: 480
    height: 480
    property color textColor: "white"
    property color bkgColor: "black"
    property int count: 100
    property int secMax: 60
    property int elapsed: 0
    property int seconds: secMax
    property real beerFill: main.seconds / main.secMax
    property real drunkFill: main.elapsed / main.count
    color: bkgColor
    visible: true
    title: count
    Rectangle {
        id: sec
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height * 0.7
        color: main.bkgColor
        Behavior on height {
            SmoothedAnimation {
                duration: 3000
                velocity: -1
            }
        }
        Rectangle {
            id: backdrop
            color: "#FFA900"
            anchors.fill: parent
        }

        Video {
            id: beer
            source: "qrc:/beer.mp4"
            autoPlay: true
            loops: MediaPlayer.Infinite
            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectCrop
            flushMode: VideoOutput.LastFrame
            muted: true;
            autoLoad: true;
        }

        Rectangle {
            id: beerCurtain
            anchors.top: sec.top
            anchors.left: sec.left
            anchors.right: sec.right
            height: (1 - main.beerFill) * sec.height
            color: main.bkgColor
            Behavior on height {
                SmoothedAnimation {
                    duration: 800
                    velocity: -1
                }
            }
        }
        Text {
            id: secText
            anchors.fill: parent
            font.pixelSize: height * 0.8
            horizontalAlignment: Text.AlignHCenter
            color: main.textColor
            text: main.seconds
        }
    }
    Rectangle {
        id: minute
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: sec.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 2
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.0;
                color: "white";
            }
            GradientStop {
                position: 1.0;
                color: "red";
            }
        }

        Rectangle {
            id: drunk
            anchors.top: minute.top
            anchors.right: minute.right
            anchors.bottom: minute.bottom
            width: (1 - main.drunkFill) * minute.width
            color: main.bkgColor
            Behavior on width {
                SmoothedAnimation {
                    duration: 3000
                    velocity: -1
                }
            }
        }
        Text {
            id: minuteText
            anchors.fill: parent
            text: main.elapsed
            font.pixelSize: height * 0.8
            color: main.textColor
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Audio {
        id: gong
        source: "qrc:/gong.wav"
    }

    Timer {
        id: tick
        interval: 1000;
        running: start.running;
        repeat: true;
        triggeredOnStart: true;
        onTriggered: {
            if (--main.seconds <= 0) {
                main.elapsed++;
                main.seconds = main.secMax;
                gong.play();
                if (main.elapsed === main.count) {
                    running = false;
                    sec.height = 0;
                }
            }
        }
    }

    Text {
        id: start;
        property bool running: false;
        visible: !running
        anchors.fill: sec
        color: main.textColor
        font.pixelSize: width / 16;
        text: "Klikkaa niin aletaan juomaan"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
    }
    MouseArea {
        id: click;
        anchors.fill: parent
        onClicked: {
            start.running = !start.running;
            start.running ? beer.play() : beer.pause();
            start.text = "Kusitauko, klikkaa niin jatketaan";
        }
    }

}
