/*
 * 2022  Ivo Fernandes <pg27165@alunos.uminho.pt>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * utFoods is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


import QtQuick 2.9
import QtQuick.Window 2.0
import Ubuntu.Components 1.3
import QtMultimedia 5.12
import QtGraphicalEffects 1.0
//import QZXing 3.3
import Ubuntu.Content 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Components.Popups 1.3
import Qt.labs.settings 1.0
import QtQuick.Controls.Suru 2.2
import "components"
import "../js/ThemeColors.js" as ThemeColors

Page {   
    id: scan_page
    objectName: 'ScanPage'
    header: PageHeader {
       visible: app_settings.is_page_headers_enabled ? true : false
       title: i18n.tr("Scanning")

       StyleHints {
            foregroundColor: "white"
            backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background 
        }
    }

    //stores the type meal choosed by user
    property int meal_scan_page

    //stores the barcode found and pass it to api openfoodsfact dialog
    property var bar_code_founded

    Component{
       id: product_found_dialog
       IsProductFoundDialog{barcode: bar_code_founded; is_product_found_dialog_meal: meal_scan_page}
    }

    Icon {
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

   Camera {
        id: camera

        focus.focusMode: Camera.FocusContinuous//Camera.FocusMacro + Camera.FocusContinuous
        focus.focusPointMode: Camera.FocusPointCenter

        captureMode: Camera.CaptureViewfinder
        exposure.exposureMode: Camera.ExposureBarcode
    }

    Timer {
        id: capture_shot
        interval: 250
        repeat: true
        running: Qt.application.active
        onTriggered: {
            video_output.grabToImage(function(result) {
                code_reader.decodeImage(result.image);
            });
        }
    }

    VideoOutput {
        id: video_output

        anchors{
            top:  app_settings.is_page_headers_enabled ? parent.header.bottom : parent.top
            left: parent.left
            right: parent.right
            bottom: app_settings.is_page_headers_enabled ? parent.bottom : navigation_shape.top
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


  /* QZXing {
        id: code_reader

        enabledDecoders: QZXing.DecoderFormat_UPC_A

        onTagFound: {
            //capture_shot.stop();
            //camera.stop();
            bar_code_founded = tag
            PopupUtils.open(product_found_dialog)
        }

        tryHarder: true
    }

    Component.onCompleted: console.log("AQUIUIASUDIOASUIDUAS", meal_scan_page)*/

    NavigationBar{id: navigation_shape} 
}