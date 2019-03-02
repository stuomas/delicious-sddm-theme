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
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "logic.js" as Logic

Item {
    property bool toggled
    ListView {
        id: usrList
        anchors.bottom: footer.top 
        height: spacing + usrList.count * 40
        width: 200
        opacity: 0
        spacing: 0
        model: userModel
        delegate: 
            Rectangle {
                width: usrList.width
                height: 40
                color: "#55000000"
                Text {
                    text: model.name
                    color: "#fff"
                    font.family: Logic.cfgFontFamily
                    font.pointSize: 12 * Logic.cfgFontScale
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                }
                MouseArea {
                    width: usrList.width
                    height: usrList.height
                    hoverEnabled: true
                    onEntered: {
                        footer.opacity = 1
                    }
                    onExited: {
                        footer.opacity = 0
                    }
                    onClicked: {
                        toggled = false
                        loginBox.userName = model.name
                        usrList.opacity = 0
                    }  
                }
            }
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }
    Rectangle { 
        id: footer
        color: "#55000000"
        opacity: 0
        anchors.fill: parent
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                footer.opacity = 1
            }
            onExited: {
                footer.opacity = 0
            }
        }
        Behavior on opacity {
                NumberAnimation { duration: 500 }
        }
        Row {       
            height: parent.height
            width: parent.width * 0.99
            anchors.horizontalCenter: parent.horizontalCenter   
            spacing: 0  
            Item {
                id: userDisplay
                width: parent.width / 3
                height: parent.height
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    property string hostname: (sddm.hostName == "") ? "hostname" : sddm.hostName
                    text: loginBox.userName + "@" + hostname
                    font.pointSize: 12 * Logic.cfgFontScale
                    font.family: Logic.cfgFontFamily
                    color: "#EEE" //Logic.cfgFontColor
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(!toggled) {
                                usrList.opacity = 1
                                toggled = true
                            } else {
                                usrList.opacity = 0
                                toggled = false
                            }
                        }
                    }
                }       
            }
            Item {
                id: powerOptions
                height: parent.height
                width: parent.width/3               
                Row {
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 0
                    ImageButton {
                        height: parent.height
                        source: Logic.iconPath + "suspend.svg"
                        enabled: sddm.canSuspend
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onEntered: {
                                footer.opacity = 1
                            }
                            onExited: {
                                footer.opacity = 0
                            }
                            onClicked: sddm.suspend()
                        }
                        layer {
                            enabled: true
                            effect: ColorOverlay {
                                color: "#EEE" //Logic.cfgIconColor
                            }
                        }             
                    }                 
                    ImageButton {
                        height: parent.height
                        source: Logic.iconPath + "reboot.svg"
                        enabled: sddm.canReboot
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onEntered: {
                                footer.opacity = 1
                            }
                            onExited: {
                                footer.opacity = 0
                            }
                            onClicked: sddm.suspend()
                        }
                        layer {
                            enabled: true
                            effect: ColorOverlay {
                                color: "#EEE" //Logic.cfgIconColor
                            }
                        }
                    }
                    ImageButton {
                        height: parent.height
                        source: Logic.iconPath + "shutdown.svg"
                        enabled: sddm.canPowerOff
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onEntered: {
                                footer.opacity = 1
                            }
                            onExited: {
                                footer.opacity = 0
                            }
                            onClicked: sddm.suspend()
                        }
                        layer {
                            enabled: true
                            effect: ColorOverlay {
                                color: "#EEE" //Logic.cfgIconColor
                            }
                        }
                    }
                }   
            }
            Item {
                width: parent.width/3
                height: parent.height
                Timer {
                    interval: 100; running: true; repeat: true;
                    onTriggered: dateTime = new Date()
                }
                Button {
                    id: keyboardButton
                    property int currentIndex: -1
                    text: instantiator.objectAt(currentIndex).shortName
                    Component.onCompleted: currentIndex = Qt.binding(function() {return keyboard.currentLayout});
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: time.left
                    anchors.rightMargin: 10
                    style: ButtonStyle {
                        background: Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            border.color: "transparent"
                        }
                    }
                    menu: Menu {
                        id: keyboardMenu
                        Instantiator {
                            id: instantiator
                            model: keyboard.layouts
                            onObjectAdded: keyboardMenu.insertItem(index, object)
                            onObjectRemoved: keyboardMenu.removeItem( object )
                            delegate: MenuItem {
                                text: modelData.longName
                                property string shortName: modelData.shortName
                                onTriggered: {
                                    keyboard.currentLayout = model.index
                                }
                            }
                        }
                    }
                }  
                Text {
                    id: time
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#EEE" //Logic.cfgFontColor
                    text : Qt.formatTime(dateTime, "hh:mm")
                    font.pointSize: 12 * Logic.cfgFontScale
                    font.family: Logic.cfgFontFamily
                }
            }
        }
    }
}