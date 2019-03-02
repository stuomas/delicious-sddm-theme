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
import QtGraphicalEffects 1.0
import "logic.js" as Logic

Item {
    signal selected(int emittedIndex)
    property alias currentItem: sessionList.currentItem
    property alias aSessionList: sessionList
    ListView {
        id: sessionList
        model: sessionModel
        property int entryWidth: 220
        implicitWidth: contentItem.childrenRect.width
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        currentIndex: sessionModel.lastIndex
        orientation: ListView.Horizontal
        spacing: 0
        delegate: Rectangle {
            property bool activeSel: sessionList.currentIndex == index //index is a property of delegate
            color: "transparent"
            width: sessionList.entryWidth
            height: sessionList.entryWidth
            Text {
                visible: !Logic.cfgIconGlowEnabled
                anchors.bottom: logo.top
                anchors.bottomMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                text: "▼"
                font.family: Logic.cfgFontFamily
                color: Logic.cfgFontColor
                font.pointSize: 20 * Logic.cfgFontScale
                opacity: activeSel
                Behavior on opacity {
                    NumberAnimation { duration: 100 }
                }
            }
            ImageButton {
                id: logo
                anchors.topMargin: 50
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize.width: sessionList.entryWidth / 1.5
                sourceSize.height: sessionList.entryWidth / 1.5
                source: Logic.iconPath + "%1.%2".arg(Logic.getIcon(model.name)).arg(Logic.cfgIconFormat)
                visible: false //because ColorOverlay/Glow, try with layers?
            }
            MouseArea {
                width: logo.width
                height: logo.height
                onClicked: {
                    selected(index)
                    sessionList.currentIndex = index
                }  
            }
            Glow {  
                anchors.fill: logo
                radius: 12
                samples: 26
                spread: 0.3
                color: Logic.cfgGlowColor
                source: logo
                visible: activeSel && Logic.cfgIconGlowEnabled
            }
            ColorOverlay {
                anchors.fill: logo
                source: logo
                color: Logic.cfgIconColor
            }
            Text {
                anchors.top: logo.bottom
                anchors.topMargin: 20
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: model.name
                font.family: Logic.cfgFontFamily
                font.pointSize: 16 * Logic.cfgFontScale
                color: Logic.cfgFontColor
                opacity: activeSel
                wrapMode: Text.WordWrap
                layer {
                    enabled: true
                    effect: DropShadow {
                        verticalOffset: 0
                        color: Logic.cfgGlowColor
                        radius: 9
                        samples: 20
                    }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 100 }
                }
            }
            Keys.onLeftPressed: {
                sessionList.decrementCurrentIndex()
                sessionList.currentItem.forceActiveFocus()
            }
            Keys.onRightPressed: {
                sessionList.incrementCurrentIndex()
                sessionList.currentItem.forceActiveFocus()
            }
            Keys.onEnterPressed: {
                selected(index)
                sessionList.currentIndex = index
            }
            Keys.onReturnPressed: {
                selected(index)
                sessionList.currentIndex = index
            }

            Timer {
                interval: 100
                running: true
                onTriggered: sessionList.forceActiveFocus()
            }
        }
    }
}
