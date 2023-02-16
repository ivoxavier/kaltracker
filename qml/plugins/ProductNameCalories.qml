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
import Lomiri.Components.Pickers 1.3
import QtCharts 2.3
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import "../components"
import "../style"


ColumnLayout{
    width: root.width

    BlankSpace{}

    Text{
        Layout.alignment: Qt.AlignCenter
        text: i18n.tr("Product name")
        font.bold : true
        color : app_style.label.labelColor
    }

    LomiriShape{  
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(2)
        Layout.preferredHeight: units.gu(4)
        radius: "large"
        aspect: LomiriShape.Inset
        backgroundColor: app_style.shape.textInput.shapeColor
        TextInput{
            anchors.fill: parent
            overwriteMode: true
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            color : app_style.label.labelColor 
            onTextChanged: product_name_quick_addition_page = text
        }
    }

    BlankSpace{}

    Text{
        Layout.alignment: Qt.AlignCenter
        text: i18n.tr("Calories")
        font.bold : true
        color : app_style.label.labelColor 
    }

    LomiriShape{  
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(2)
        Layout.preferredHeight: units.gu(4)
        radius: "large"
        aspect: LomiriShape.Inset
        backgroundColor: app_style.shape.textInput.shapeColor
        
        TextInput{
            anchors.fill: parent
            overwriteMode: true
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            inputMethodHints: Qt.ImhDigitsOnly
            color : app_style.label.labelColor 
            onEditingFinished:{ 
                cal_quick_addition_page = text
            }
        }
    }
        BlankSpace{}

        Text{
            Layout.alignment: Qt.AlignCenter
            text: i18n.tr("Nutriscore Grade")
            font.bold : true
            color : app_style.label.labelColor
        }

        OptionSelector {
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: root.width - units.gu(10)
            expanded: true
            model: [i18n.tr("A: Very Good Nutritional Quality"),
            i18n.tr("B: Good Nutritional Quality"),
            i18n.tr("C: Average Nutritional Quality"),
            i18n.tr("D: Poor Nutritional Quality"),
            i18n.tr("E: Bad Nutritional Quality")]
            selectedIndex: -1
            onSelectedIndexChanged: {
                nutriscore_quick_addition_page = selectedIndex == 0 ?
                "a" : selectedIndex == 1 ?
                "b" : selectedIndex == 2 ?
                "c" : selectedIndex == 3 ?
                "d" : "e"
            }
        }
}