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
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.0
import SddmComponents 2.0
import "logic.js" as Logic

Rectangle {
    id: root
    property date dateTime: new Date()
    property variant geometry: screenModel.geometry(screenModel.primary)
    width: geometry.width
    height: geometry.height
    Item {
        id: mainFrame
        anchors.fill: parent
        // Image background
        Background {
            id: mainFrameBackgroundImage
            anchors.fill: parent
            source: Logic.isImage ? Logic.cfgBackground : ""
            visible: Logic.isImage
        }
        // Video background
        Rectangle {
            id: mainFrameBackgroundVideo
            anchors.fill: parent
            visible: Logic.isVideo
            color: "#111"
            MediaPlayer {
                id: previewPlayer
                source: Logic.cfgBackground
                onPositionChanged: { previewPlayer.pause() }
            }
            VideoOutput {
                anchors.fill: parent
                source: previewPlayer
                fillMode: VideoOutput.PreserveAspectCrop
            }
            MediaPlayer {
                id: videoPlayer
                source: Logic.cfgBackground
                autoPlay: true
                loops: MediaPlayer.Infinite
            }
            VideoOutput {
                id: videoOutput
                source: videoPlayer
                fillMode: VideoOutput.PreserveAspectCrop
                anchors.fill: parent
            }
        }
        //DE-entries
        Item {
            id: centerArea
            width: parent.width
            height: parent.height * 0.4
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenterOffset: -(height * 0.2)
            SessionListView {
                id: sessionFrame
                anchors.fill: parent
                onSelected: {
                    loginBox.sessionIndex = emittedIndex
                    loginBox.input.forceActiveFocus()
                }
            }
            LoginBox {
                id: loginBox
                anchors.top: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                onDeselected: {
                    sessionFrame.aSessionList.forceActiveFocus()
                }
            }
        }
        Footer {
            anchors.bottom: parent.bottom
            width: parent.width
            height: parent.height/25
        }
    }
}