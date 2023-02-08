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
import "../style"
import '../../js/RecommendedCalories.js' as RecommendedCalories
import "../../js/ControlRecommendedCalories.js" as ControlRecommendedCalories

Dialog {
    id: recommended_calories_dialog
    title: i18n.tr("Recommended Calories")

    Text{
        id: recommended_calories_label
        text: i18n.tr("%1 Calories").arg(root.equation_recommended_calories)
        font.pixelSize: units.gu(2)
        font.bold: true
        color : app_style.label.labelColor
        width: parent.width
    }

    Text{
        text: i18n.tr("Calculated Using St. Mifflin Jeor Equation")
        font.pixelSize: units.gu(2)
        color : app_style.label.labelColor 
        width: parent.width
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
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

    Component.onCompleted: ControlRecommendedCalories.calcCal()
}