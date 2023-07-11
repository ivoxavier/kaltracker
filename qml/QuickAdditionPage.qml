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
import Lomiri.Components 1.3
import QtQuick.Controls 2.2 as QQC2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.LocalStorage 2.12
import QtQuick.Controls.Suru 2.2
import "components"
import "style"
import "plugins"
import "../js/UserTable.js" as UserTable
import "../js/IngestionsTable.js" as IngestionsTable
import "../js/UserFoodsListTable.js" as UserFoodsListTable


Page{
    id: quick_addition_page
    objectName: 'QuickAdditionPage'
    header: PageHeader {
                title : swipe_view.currentIndex == 0 ?
                i18n.tr("Product Details") : i18n.tr("Product Macros")

               StyleHints {
                    /*foregroundColor: "white"
                    backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
            }
        }

    BackgroundStyle{}
 
   
    Component{
        id: sucess_dialog
        StoreIngestionDialog{msg:i18n.tr("Stored!")}
    }

    Component{
        id: error_dialog
        MessageDialog{msg:i18n.tr("Something went wrong. Please, restart the app and try again.")}
    }

    Timer{id: timer;repeat: false}

    QQC2.SwipeView{
        id: swipe_view
        currentIndex:0
        anchors.top:parent.header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height

        Item{
            //index 0
            Flickable{
                anchors.fill: parent
                contentWidth: swipe_view.width
                contentHeight: product_name_calories.implicitHeight
                interactive: true

                ProductNameCalories{id:product_name_calories}
            }

        }

        Item {
            //index 1
            ProductMacros{id:product_macros}
        }

    }

    
    RowAbstractConfirmButton{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }
    
    QQC2.PageIndicator{
        id: swipe_view_indicator
        count: swipe_view.count
        currentIndex: swipe_view.currentIndex
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter   
    }
}