import QtQuick 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12

Window {
    id: main
    width: 640
    height: 480
    visible: true
    title: count
    property color textColor: "white"
    property color bkgColor: "black"
    property int count: 100
    property int secMax: 60
    property int elapsed: 0
    property int seconds: 0
    property real beerFill: main.seconds / main.secMax
    property real drunkFill: main.elapsed / main.count
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
            id: beer
            anchors.bottom: sec.bottom
            anchors.left: sec.left
            anchors.right: sec.right
            height: main.beerFill * sec.height
            color: "#e78e18"
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
        color: main.bkgColor
        Rectangle {
            id: drunk
            anchors.top: minute.top
            anchors.left: minute.left
            anchors.bottom: minute.bottom
            width: main.drunkFill * minute.width
            color: "red"
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
        running: false;
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

    Rectangle {
        id: start;
        anchors.fill: parent
        color: main.bkgColor
        Text {
            anchors.fill: parent
            color: main.textColor
            font.pixelSize: height / 10;
            text: "Klikkaa niin aletaan juomaan"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        MouseArea {
            id: click;
            anchors.fill: parent
            onClicked: {
                start.visible = false;
                tick.running = true;
            }
        }

    }

}
