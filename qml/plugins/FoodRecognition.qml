/*
* 2022-2023  Ivo Xavier
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; version 3.
*
* kaltracker is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.9
import QtQuick.Window 2.0
import Lomiri.Components 1.3
import QtMultimedia 5.12
import QtGraphicalEffects 1.0
import QZXing 3.3
import QtQuick.Controls 2.2 as QQC2
import Lomiri.Content 1.3
import Lomiri.Components.Pickers 1.3
import Lomiri.Components.Popups 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Controls.Suru 2.2
import "../components"
import "../style"


Item{
    id: bar_code_components
    property bool is_reading: true


    Icon {
        id: torch_icon
        height: units.gu(6)
        z:100
        width: height
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: units.gu(2)
        }
        name: "camera-app-symbolic"
        color: "white"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                //camera.flash.mode = (camera.flash.mode === Camera.FlashVideoLight ? Camera.FlashOff : Camera.FlashVideoLight)
                
            }
        }
    }


    Camera {
        id: camera

        focus.focusMode: Camera.FocusContinuous//Camera.FocusMacro + Camera.FocusContinuous
        focus.focusPointMode: Camera.FocusPointCenter

        captureMode: Camera.CaptureViewfinder
        exposure.exposureMode: Camera.ExposureBarcode
    }



    VideoOutput {
        id: video_output

        anchors{
            top:  parent.header.bottom 
            left: parent.left
            right: parent.right
            bottom:  parent.bottom 
        }

        fillMode: VideoOutput.PreserveAspectCrop
        source: camera
        focus: true
        orientation: Screen.primaryOrientation == Qt.PortraitOrientation ? -90 : 0
    }

    Rectangle {
        id: zoneOverlay
        anchors.fill: parent
        color: "#000000"
    }

    Item {
        id: zoneMask
        anchors.fill: parent

        Rectangle {
            color: "red"
            height: units.gu(35)
            width: units.gu(50)
            anchors.centerIn: parent
        }
    }

    OpacityMask {
        opacity: 0.83
        invert: true
        source: ShaderEffectSource {
            sourceItem: zoneOverlay
            hideSource: true
        }
        maskSource: ShaderEffectSource {
            sourceItem: zoneMask
            hideSource: true
        }
        anchors.fill: parent
    }
    
}