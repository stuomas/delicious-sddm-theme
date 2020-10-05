/***************************************************************************
* Copyright (c) 2019 Tuomas Salokanto <stuomas@protonmail.com>
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/

import QtQuick 2.3
import SddmComponents 2.0
import QtGraphicalEffects 1.0
import "logic.js" as Logic

Item {
    id: loginItem
    property int sessionIndex: sessionModel.lastIndex
    property string userName: userModel.lastUser
    property alias input: passwdInput
    signal deselected()
    Connections {
        target: sddm
        onLoginSucceeded: {
            Qt.quit()
        }
    }
    width: parent.width
    height: parent.height
    Rectangle {
        id: passBox
        anchors.horizontalCenter: parent.horizontalCenter
        height: 50 * Logic.cfgFontScale
        width: (parent.width / 7) * Logic.cfgFontScale
        opacity: passwdInput.focus
        color: "#55000000"
        radius: 6
        Image {
            id: ico
            source: Logic.iconPath + "reveal.svg"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: (ico.width / 4) * Logic.cfgFontScale
            layer {
                enabled: { passwdInput.echoMode == TextInput.Normal }
                effect: ColorOverlay {
                    color: "#D00"
                }
            }   
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    passwdInput.echoMode = (passwdInput.echoMode == TextInput.Password) ? TextInput.Normal : TextInput.Password
                }
            }
            layer {
                enabled: true
                effect: ColorOverlay {
                    color: "#EEE" //Logic.cfgIconColor
                }
            }
        }
        Text {
            id: passPrompt
            anchors.fill: parent
            //MULTIPLE USERS
            //text: (userName == "") ? "[Select user]" : "[Password for %1]".arg(userName)
            //SINGLE USER
            text: "[Enter Password]"
            color: "#55FFFFFF"
            clip: true
            font.pointSize: 12 * Logic.cfgFontScale
            font.family: Logic.cfgFontFamily
            //ADJUST TO WORK WITH YOUR SCREEN RESOLUTION
            anchors.leftMargin: ico.width * 1.5
            opacity: (passwdInput.focus && passwdInput.text === "")
            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }
        TextInput {
            id: passwdInput
            anchors.fill: parent
            clip: true
            color: Logic.cfgFontColor
            font.pointSize: 12 * Logic.cfgFontScale
            selectByMouse: true
            echoMode: TextInput.Password
            verticalAlignment: TextInput.AlignVCenter
            anchors.leftMargin: ico.width * 1.5
            anchors.rightMargin: ico.width / 2
            layer {
                enabled: true
                effect: DropShadow {
                    verticalOffset: 0
                    color: Logic.cfgGlowColor
                    radius: 9
                    samples: 20
                }
            }
            onAccepted: {
                sddm.login(userName, passwdInput.text, sessionIndex)
            }
            Keys.onEscapePressed: {
                passwdInput.clear()
                deselected()
            }
        }
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }
}
