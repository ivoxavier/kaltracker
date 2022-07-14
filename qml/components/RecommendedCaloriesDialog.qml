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
import QtQuick.Controls.Suru 2.2
import '../../js/RecommendedCalories.js' as RecommendedCalories
import "../../js/ControlRecommendedCalories.js" as ControlRecommendedCalories
import "../../js/ThemeColors.js" as ThemeColors

Dialog {
    id: recommended_calories_dialog
    title: i18n.tr("Recommended Calories")

    Text{
        id: recommended_calories_label
        text: i18n.tr("%1 Calories").arg(root.equation_recommended_calories)
        font.pixelSize: units.gu(2)
        font.bold: true
        color : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 
        width: parent.width
    }

    Text{
        text: i18n.tr("Calculated Using St. Mifflin Jeor Equation")
        font.pixelSize: units.gu(2)
        font.bold: true
        color : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 
        width: parent.width
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }
    
        
    Button{
        text: i18n.tr("Back")
        color: UbuntuColors.blue
        onClicked:{
                PopupUtils.close(recommended_calories_dialog)
            }
        }

    Button{
        text: i18n.tr("Confirm")
        color: UbuntuColors.green
        onClicked: ControlRecommendedCalories.confrim()
    }

    Component.onCompleted: ControlRecommendedCalories.calcCal()
}