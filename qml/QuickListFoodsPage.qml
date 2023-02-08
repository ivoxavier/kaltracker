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
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.LocalStorage 2.12
import QtQuick.Controls.Suru 2.2
import "components"
import "style"
import "../js/Regex.js" as Regex

Page{
    id: quick_list_foods_page
    objectName: 'QuickListFoodsPage'
    header: PageHeader {
        
        contents: TextField{
            id: search_text
            anchors.centerIn: parent
            width: parent.width
            placeholderText: i18n.tr("Search...")
            validator: RegExpValidator { regExp: Regex.regex_char}
            function searchTimer(delayMiliseconds, cb) {
                timer.interval = delayMiliseconds;
                timer.triggered.connect(cb);
                timer.start()
            }
            onTextChanged:{
                searchTimer(1000, function () {
                sorted_model.filter.pattern = new RegExp(search_text.text)
                })
            }
        }

        StyleHints {
           /* foregroundColor: "white"
            backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
        }
    }

    BackgroundStyle{}

    //receives meal category from HomePage.slotAddMeal
    property int meal_quick_list_foods_page

    Timer{id: timer;repeat: false}

    SortFilterModel{
        id: sorted_model

        model: UserFoodsList{}
        sort.property: "product_name"
        sort.order: Qt.DescendingOrder
        // case insensitive sorting
        sortCaseSensitivity: Qt.CaseInsensitive
        filter.property: "product_name"
        // .* filters all results
        //filter.pattern: /.*/
    }

    
    ListViewFoods{
        id: list_view_foods
        anchors{
            top: parent.header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: parent.height
        width: parent.width
    }

    RowAbstractBarcodeButton{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: quick_addition_button.top
        visible : app_settings.is_api_openfoodsfacts_enabled ? true : false
    }

    RowAbstractQuickAdditionButton{
        id: quick_addition_button
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }
}