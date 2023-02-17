/*
 * 2022  Ivo Xavier
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
import Qt.labs.settings 1.0
import QtQuick.Controls.Suru 2.2
import "components"
import "style"
import "plugins"


Page {   
    id: scan_page
    objectName: 'ScanPage'
    header: PageHeader {
       //visible: app_settings.is_page_headers_enabled ? true : false
       title: i18n.tr("Scanning")

       StyleHints {
            /*foregroundColor: "white"
            backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
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

    QQC2.SwipeView{
        id: swipe_view
        currentIndex:0
        anchors.top:parent.header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height
        onCurrentIndexChanged: {
            if (currentIndex == 0){
                print("start camera")
                capture_shot.start();
                camera.start();
            }
            else{
                print("stop camera")
                capture_shot.stop();
                camera.stop();
            }
        }

        Item{
            // index 0
            BarCodeReader{}
        }

        Item{
            // index 1
            ManualCodeSearch{}
        }
    }

    QQC2.PageIndicator{
        id: swipe_view_indicator
        count: swipe_view.count
        currentIndex: swipe_view.currentIndex
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter   
    } 

}    