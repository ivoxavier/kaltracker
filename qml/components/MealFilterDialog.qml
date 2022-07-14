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
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12
import QtQuick.Controls.Suru 2.2
import "../../js/ThemeColors.js" as ThemeColors

Dialog {
    id: meal_filter_dialog
    title: i18n.tr("Show Ingestions From")

    Row{
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: units.gu(1)

        Label{
            anchors.verticalCenter: parent.verticalCenter
            text: i18n.tr("How Many Days Ago:")
            font.bold: true
        }

        UbuntuShape{
            width: units.gu(4)
            height : width
            radius : "large"
            aspect : UbuntuShape.Inset

            TextInput{
                anchors.verticalCenter: parent.verticalCenter
                width : parent.width
                overwriteMode: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                inputMethodHints: Qt.ImhDigitsOnly
                font.bold: true
                onTextChanged : {
                    home_page.amount_of_days_back = text
                    var yesterday_date = new Date()
                    yesterday_date.setDate(yesterday_date.getDate() - home_page.amount_of_days_back)
                    bottom_edge.yesterday_formated_date = yesterday_date.toLocaleDateString(root.locale, 'yyyy-MM-dd')  
                }
            }
        }
    }

    OptionSelector{
        expanded : true
        model : [i18n.tr("Breakfast"), i18n.tr("Lunch"), i18n.tr("Dinner"), i18n.tr("Snacks")]
        selectedIndex: -1
        onSelectedIndexChanged :  bottom_edge.meal_filter = selectedIndex
    }

    Button {
        text: i18n.tr("Back")
        onClicked:{
            PopupUtils.close(meal_filter_dialog)
        } 
    }
}