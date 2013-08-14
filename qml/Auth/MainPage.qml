import QtQuick 1.1
import com.nokia.symbian 1.1
import "Hotp.js" as Hotp
import "Init.js" as Init
//import "time.js" as TimeFunc
import "Storage.js" as Storage
import timer 1.0

Page {
    id: mainPage
    Text {
        id: text1
        height: 76
        text: qsTr("QGAuthenticator")
        anchors.right: parent.right
        anchors.rightMargin: 29
        anchors.left: parent.left
        anchors.leftMargin: 29
        anchors.top: parent.top
        anchors.topMargin: 58
        style: Text.Raised
        font.bold: true
        font.family: "Monaco"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: platformStyle.colorNormalLight
        font.pixelSize: 25
    }

    Timer {
        id: timeOut
        interval: 30000
        onTimeout: {
            console.log("TimeOut");
            var i;
            for(i = 0;i < authlist.count;i++){
                authlist.setProperty(i, "totp", Hotp.totp(authlist.get(i).secretKey,Hotp.get_timestamp()));
            }
        }
    }

    Timer {
        id: refreshTimer
        interval: 10
        onTimeout:{
            var now = new Date().getTime() / 1000;
            var initTime = (Hotp.get_timestamp() + 1) * 30 - now;
            var i;
            for(i = 0;i < authlist.count;i++){
                authlist.setProperty(i, "keepTime", initTime);
            }
        }
    }

    Timer {
        id: initTimeOut
        onTimeout: {
            initTimeOut.stop();
            console.log("initTimeOut");
            var i;
            for(i = 0;i < authlist.count;i++){
                authlist.setProperty(i, "totp", Hotp.totp(authlist.get(i).secretKey,Hotp.get_timestamp()));
            }
            timeOut.start();
        }
    }

    ListView {
        id: list_view1
        x: 25
        y: 120
        width: 258
        height: 415
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 56
        anchors.right: text1.left
        anchors.rightMargin: -280
        anchors.top: text1.bottom
        anchors.topMargin: 29
        scale: 1.100
        smooth: false
        clip:true

        delegate: Item {
            id: item1
            x: 5
            height: 60
            Row {
                id: row1
                y: 12
                width: 220
                height: 42
                anchors.left: parent.left
                anchors.leftMargin: 4
                spacing: 10
                Text {
                    id: uid
                    text: name
                    anchors.verticalCenterOffset: -10
                    anchors.verticalCenter: parent.verticalCenter
                    color: "White"
                }
                Text {
                    text: totp
                    anchors.verticalCenterOffset: -10
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    color: "Red"
                }
                Text {
                    text: secretKey
                    visible: false
                }

                ProgressBar {
                    x: 147
                    y: 15
                    width: 30
                    height: 15
                    maximumValue: 30
                    anchors.right: parent.right
                    anchors.rightMargin: 1
                    value: keepTime
                }
            }
        }
        model: ListModel {
            id: authlist
        }

        MouseArea{
            id: mousearea1
            enabled: true
            hoverEnabled: false
            anchors.fill: parent
            onPressAndHold: {
                btnOK.visible = true;
                btnCancel.visible = true;
                tfKey.visible = true;
                tfid.visible = true;
                tfKey.text = "Secret Key:";
                tfid.text = "ID:";
            }
        }

        TextField {
            id: tfid
            y: 74
            height: 50
            text: "ID:"
            anchors.right: parent.right
            anchors.rightMargin: 39
            anchors.left: parent.left
            anchors.leftMargin: 39
            anchors.bottom: tfKey.top
            anchors.bottomMargin: 3
            visible: false
        }

        TextField {
            id: tfKey
            height: 50
            text: "Secret Key:"
            anchors.right: parent.right
            anchors.rightMargin: 39
            anchors.left: parent.left
            anchors.leftMargin: 39
            anchors.top: parent.top
            anchors.topMargin: 127
            visible: false
        }

        ToolButton {
            id: btnOK
            width: 89
            height: 33
            text: "OK"
            anchors.left: tfKey.right
            anchors.leftMargin: -180
            anchors.top: tfKey.bottom
            anchors.topMargin: 0
            platformInverted: false
            pressed: false
            iconSource: ""
            visible: false

            onClicked: {
                var reg = /^[ABCDEFGHIJKLMNOPQRSTUVWXYZ234567]+$/ig;
                var k = tfKey.text.match(reg);
                if(k){
                    authlist.append({"name" : tfid.text , "totp": Hotp.totp(tfKey.text,Hotp.get_timestamp()), "secretKey": tfKey.text, "keepTime": 0});
                    Storage.insertData(tfid.text,tfKey.text);
                }
                else
                    tfKey.text = "Secret Key Error!";
            }

            ToolButton {
                id: btnCancel
                width: 96
                height: 33
                text: "Cancel"
                anchors.left: parent.left
                anchors.leftMargin: 88
                anchors.top: parent.top
                anchors.topMargin: 0
                visible: false
                onClicked: {
                    btnOK.visible = false;
                    btnCancel.visible = false;
                    tfKey.visible = false;
                    tfid.visible = false;
                }
            }
        }

    }
    Component.onCompleted: {
        Init.init();
    }
}
