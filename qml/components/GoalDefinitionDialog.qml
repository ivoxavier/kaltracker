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
import Ubuntu.Components.ListItems 1.3 
import QtQuick.Controls.Suru 2.2
import QtQuick.Controls 2.2 as QQC2
import '../../js/DefineGoalCalories.js' as DefinePeriod
import "../../js/ThemeColors.js" as ThemeColors

Dialog {
    id: module_goal_dialog
    title: i18n.tr("Module your goal")
    
    property alias type_of_goal: module_advise_text.format_string

    Text{
        id: module_advise_text
        property string format_string
        text: i18n.tr("A healthy %1 weight must be distributed among a safe period.").arg(format_string)
        font.pixelSize: units.gu(2)
        width: parent.width
        color : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 
        wrapMode: Text.Wrap;
        horizontalAlignment: Text.AlignJustify 
    }
    
    ListItem{
        divider.visible : false
        ListItemLayout{
            title.text: i18n.tr("0,5kg by week")
            title.color : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 
            QQC2.RadioButton{
                id: radio_button_set1
                checked: false
                onClicked: {
                    module_goal_dialog.is_goal_defined = true
                    root.user_goal = DefinePeriod.periodOne()
                    radio_button_set2.checked = false
                    radio_button_set3.checked = false
                    radio_button_set4.checked = false
                }
            }
        }
    }
    
    ListItem{
        divider.visible : false
        ListItemLayout{
            title.text : i18n.tr("1kg by week")
            title.color : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 
            QQC2.RadioButton{
                id: radio_button_set2
                checked: false
                onClicked: {
                    module_goal_dialog.is_goal_defined = true
                    root.user_goal = DefinePeriod.periodTwo()
                    radio_button_set1.checked = false
                    radio_button_set3.checked = false
                    radio_button_set4.checked = false
                }
            }
        }
    }
    

    ListItem{
        divider.visible : false
        ListItemLayout{
            title.text : i18n.tr("3kg by month")
            title.color : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 

            QQC2.RadioButton{
                id: radio_button_set3
                checked: false
                onClicked: {
                    module_goal_dialog.is_goal_defined = true
                    root.user_goal = DefinePeriod.periodThree()
                    radio_button_set1.checked = false
                    radio_button_set2.checked = false
                    radio_button_set4.checked = false
                }
            }
        }
    }

    ListItem{
        divider.visible : false
        ListItemLayout{
            title.text :  i18n.tr("4kg by month")
            title.color : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 
            QQC2.RadioButton{
                id: radio_button_set4
                checked: false
                onClicked: {
                    module_goal_dialog.is_goal_defined = true
                    root.user_goal = DefinePeriod.periodFour()
                    radio_button_set1.checked = false
                    radio_button_set2.checked = false
                    radio_button_set3.checked = false
                }
            }
        }
    }
        
    Button{
        text: i18n.tr("Back")
        color: UbuntuColors.blue
        onClicked:{
                module_goal_dialog.is_goal_defined = false
                set_plan_page.is_loose_weight = false
                set_plan_page.is_gain_weight = false
                PopupUtils.close(module_goal_dialog)
            }
        }
    
    property bool is_goal_defined : false

    Button{
        text: i18n.tr("Confirm")
        enabled: module_goal_dialog.is_goal_defined
        color: UbuntuColors.green
        onClicked: {
            PopupUtils.close(module_goal_dialog)
            page_stack.push(set_activity_page)
        }
    }
}
