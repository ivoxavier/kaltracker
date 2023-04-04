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
import Lomiri.Components.Popups 1.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Suru 2.2
import QtQuick.Controls 2.2 as QQ2
import "../style"
import '../../js/RecommendedCalories.js' as RecommendedCalories
import "../../js/ControlRecommendedCalories.js" as ControlRecommendedCalories

Dialog {
    id: recommended_calories_dialog
    title: i18n.tr("Recommended Calories")

    //stores the recommended calories by the St. Mifflin Jeor Equation
    property int equation_calories
    
    property bool is_manual_edit : false

    RowLayout{
        Layout.preferredWidth: parent.width
        Text{
            id: recommended_calories_label
            Layout.alignment: Qt.AlignCenter
            text: i18n.tr("%1 Calories").arg(recommended_calories_dialog.equation_calories) 
            font.pixelSize: units.gu(3)
            font.bold: true
            color : app_style.label.labelColor
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

    }
    

    Text{
        text: i18n.tr("Calculated Using St. Mifflin Jeor Equation")
        font.pixelSize: units.gu(1.5)
        font.bold: false
        color : app_style.label.labelColor
        width: parent.width
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }

    RowLayout{
        Layout.preferredWidth: parent.width

        Icon{
            Layout.alignment: Qt.AlignCenter
            name: "edit"
            height: units.gu(3)
            MouseArea{
                anchors.fill: parent
                onClicked: recommended_calories_dialog.is_manual_edit = !recommended_calories_dialog.is_manual_edit
            }
        }

    }
    
    LomiriShape{
        width : parent.width
        height : units.gu(10)
        radius: "large"
        aspect: LomiriShape.Inset

        visible: recommended_calories_dialog.is_manual_edit

        TextInput{
            anchors.fill: parent
            overwriteMode: true
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            color : app_style.label.labelColor  
            onTextChanged: root.equation_recommended_calories = text
        }
    }

    Button{
        text: i18n.tr("Confirm")
        color: LomiriColors.green
        onClicked: {
            ////stores plan type
            app_settings.plan_type = root.type_goal
            
            page_stack.pop(user_profile_config_page)
            page_stack.push(create_storage_page)
        }
    }

    Button{
        text: i18n.tr("Back")
        onClicked:{
                PopupUtils.close(recommended_calories_dialog)
            }
        }

    Component.onCompleted: {
        ControlRecommendedCalories.calcCal()
        recommended_calories_dialog.equation_calories = root.equation_recommended_calories
    }
}