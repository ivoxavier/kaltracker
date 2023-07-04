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
import Qt.labs.settings 1.0
import QtQuick.Controls.Suru 2.2
import "components"
import "style"
import "plugins"


Page {   
    id: scan_page
    objectName: 'ScanPage'
    header: PageHeader {
       title: swipe_view.currentIndex == 0 ? 
       i18n.tr("Reading Bar Code...") : i18n.tr("Manual search")

       StyleHints {
            /*foregroundColor: "white"
            backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
        }
    }

    //stores the barcode found and pass it to api openfoodsfact dialog
    property var bar_code_founded

    property string barcode

    Component{
       id: product_found_dialog
       IsProductFoundDialog{barcode: bar_code_founded}
    }

    

    QQC2.SwipeView{
        id: swipe_view
        currentIndex:0
        anchors.top:parent.header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height
        interactive: false
        onCurrentIndexChanged: currentIndex === 0 ?
        barCodeReader.is_reading = true : barCodeReader.is_reading = false
            

        //index 0
        BarCodeReader{id:barCodeReader}

        Item{
            // index 1
            ManualCodeSearch{}
        }
    }

   /* QQC2.PageIndicator{
        id: swipe_view_indicator
        count: swipe_view.count
        currentIndex: swipe_view.currentIndex
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter   
    } */

    
    Row{
        id: ok_button
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: root.width
        layoutDirection: Qt.RightToLeft 
        rightPadding: units.gu(1)
        bottomPadding: units.gu(1)
        visible: false
        IconButton{
            icon_name : "ok"
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    page_stack.pop(scan_page)  
                    page_stack.push(set_food_page) 
                }
            }  
        }
    }
}   