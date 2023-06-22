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
import QtQuick.LocalStorage 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Controls 2.2 as QQ2
import "../style"
import "../logicalFields"
import '../../js/RecommendedCalories.js' as RecommendedCalories
import "../../js/ControlRecommendedCalories.js" as ControlRecommendedCalories
import "../../js/UpdateUserTable.js" as UpdateUserTable
import "../../js/WeightTrackerTable.js" as WeightTrackerTable

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
            onTextChanged: {
                if(page_stack.currentPage.objectName == "UserProfileConfigPage"){
                    logical_fields.user_profile.equation_recommended_calories = text
                }else{
                    update_user_values_page.update_recommended_calories = text
                }
                
            }
        }
    }

    Button{
        text: i18n.tr("Confirm")
        color: LomiriColors.green
        onClicked: {
            if(page_stack.currentPage.objectName == "UserProfileConfigPage"){
                ////stores plan type
                app_settings.plan_type = logical_fields.user_profile.type_goal
                
                page_stack.pop(user_profile_config_page)
                page_stack.push(create_storage_page)
            } else{
                UpdateUserTable.updateWeight(update_user_values_page.update_weight)
                UpdateUserTable.updateHeight(update_user_values_page.update_height)

                WeightTrackerTable.newWeight(update_user_values_page.update_weight)

                app_settings.water_weight_calc = update_user_values_page.update_weight

                app_settings.plan_type = update_user_values_page.update_type_goal
                app_settings.rec_cal =  update_user_values_page.update_recommended_calories

                UpdateUserTable.updateAge(update_user_values_page.update_age)
                UpdateUserTable.updateRecCal(update_user_values_page.update_recommended_calories)
                UpdateUserTable.updateActivity(update_user_values_page.update_activity_level)
                app_settings.is_weight_tracker_chart_enabled = true
                root.initDB()
                PopupUtils.close(recommended_calories_dialog)
                page_stack.pop(update_user_values_page)
            }
            
        }
    }

    Button{
        text: i18n.tr("Back")
        onClicked:{
                PopupUtils.close(recommended_calories_dialog)
            }
        }

    Component.onCompleted: {
        if(page_stack.currentPage.objectName == "UserProfileConfigPage"){
            ControlRecommendedCalories.initialConfig()
            recommended_calories_dialog.equation_calories = logical_fields.user_profile.equation_recommended_calories
        } else{
            ControlRecommendedCalories.updatingProfile()
            recommended_calories_dialog.equation_calories = update_user_values_page.update_recommended_calories
        }
        
    }
}