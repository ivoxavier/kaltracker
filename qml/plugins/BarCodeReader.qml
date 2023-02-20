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
        name: camera.flash.mode === Camera.FlashVideoLight ? "torch-off" : "torch-on"
        color: "white"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                camera.flash.mode = (camera.flash.mode === Camera.FlashVideoLight ? Camera.FlashOff : Camera.FlashVideoLight)
                
            }
        }
    }

    Component{ 
        id: manual_search_popover_component
        Popover{
            id: popover_manual_search
            width: root.width //- units.gu(2)
            height: units.gu(12)
            y: 30
            
            Column{
                id: main_column_pop
                width: parent.width
                anchors.centerIn: parent
                ListItem{
                    color: app_style.shape.shapeColor
                    ListItemLayout{
                        title.text: i18n.tr("Click here for manual search...")
                        title.color: app_style.label.labelColor 
                    }
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    swipe_view.currentIndex = 1;
                    PopupUtils.close(popover_manual_search)
                }
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

    Timer {
        id: timer_capture_shot
        interval: 250
        repeat: true
        running: bar_code_components.is_reading
        onTriggered: {
            video_output.grabToImage(function(result) {
                code_reader.decodeImage(result.image);
            });
        }
    }

    Timer{
        id: timer_for_manual_code_search
        interval: 8000
        repeat: true
        running: true
        onTriggered: {
            PopupUtils.open(manual_search_popover_component)
            timer_for_manual_code_search.stop()
        }
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
    
        QZXing {
            id: code_reader

            enabledDecoders: QZXing.DecoderFormat_UPC_A

            onTagFound: {
                timer_capture_shot.stop();
                //camera.stop();
                bar_code_founded = tag
                PopupUtils.open(product_found_dialog)
            }

            tryHarder: true

        }
}