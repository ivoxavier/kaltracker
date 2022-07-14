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
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Ubuntu.Components.ListItems 1.3 
import Ubuntu.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import "../../js/ControlFoodsNutriscore.js" as ControlFoodsNutriscore
import "../../js/ThemeColors.js" as ThemeColors

ListView{
    highlightRangeMode: ListView.ApplyRange
    highlightMoveDuration: UbuntuAnimation.SnapDuration

    model: sorted_model
           
    delegate: ListItem{  
        divider.visible: false
        height: units.gu(8)
        
        ListItemLayout{
            id: slot_layout
                title.font.bold: true
                title.text: product_name
                subtitle.text: "%1 calories".arg(energy_kcal_100g) 
                summary.text : score_label.text === "a" ?
                i18n.tr("Very good nutritional quality") : score_label.text === "b" ?
                i18n.tr("Good nutritional quality") : score_label.text === "c" ?
                i18n.tr("Average nutritional quality") : score_label.text === "d" ?
                i18n.tr("Poor nutritional quality") : i18n.tr("Bad nutritional quality")
                
                UbuntuShape{
                    SlotsLayout.position: SlotsLayout.Leading
                    
                    height: units.gu(6)
                    width: height
                    color: ControlFoodsNutriscore.backgroundColor(score_label.text)
                    radius: "large"
                    aspect: UbuntuShape.Inset
                    Label{
                        id: score_label
                        anchors.centerIn: parent
                        text: nutriscore_grade
                        textSize: Label.Large
                        font.capitalization: Font.AllUppercase
                        color: "white"
                    }
                }
                ProgressionSlot{}
            }
            onClicked: {
                page_stack.push(set_food_page,{product_name_set_food_page: product_name,
                cal_set_food_page: energy_kcal_100g,
                carbo_set_food_page: carbohydrates_100g,
                fat_set_food_page: fat_100g,
                protein_set_food_page: proteins_100g,
                nutriscore_set_food_page: nutriscore_grade,
                meal_set_food_page: meal_quick_list_foods_page})
            }  
        }
    }