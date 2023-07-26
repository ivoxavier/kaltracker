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
import QtQuick.Controls.Suru 2.2
import "../logicalFields"
import "../../js/ControlFoodsNutriscore.js" as ControlFoodsNutriscore

ListView{
    id: foodsListView

    highlightRangeMode: ListView.ApplyRange
    highlightMoveDuration: LomiriAnimation.SnapDuration

    model: sorted_model

    //property that allows decide QuickFoodsPage to either show or not the empty state icon
    property int modelCount : foodsListView.count

    //property that allows decision on QuickFoodsPage to either show the RowAbstracts Buttons
    property int selectionCount : foodsListView.ViewItems.selectedIndices.length


    function getCalSelection(){
        var indices = foodsListView.ViewItems.selectedIndices
        var user_selection = []
        for (var i in indices){
            user_selection.push(foodsListView.model.get(indices[i]).energy_kcal_100g)
        }
        return user_selection.reduce((acc, currentValue) => acc + currentValue, 0);
    }


    Timer{
        id: multiAddition_timer
        interval: 10; running: true; repeat: true
        onTriggered: getCalSelection()
    }


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
                
                LomiriShape{
                    SlotsLayout.position: SlotsLayout.Leading
                    
                    height: units.gu(6)
                    width: height
                    color: ControlFoodsNutriscore.backgroundColor(score_label.text)
                    radius: "large"
                    aspect: LomiriShape.Inset
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
                if(selectMode){
                    selectMode = !selectMode
                    //clear the selection
                    foodsListView.ViewItems.selectedIndices = -1
                    //makes the selectionCount reset to 0 for SlotMultiAdditon makes proper math
                    list_view_foods.selectionCount = 0
                }
                logical_fields.ingestion.product_name = product_name
                logical_fields.ingestion.cal = energy_kcal_100g
                logical_fields.ingestion.carbo = carbohydrates_100g
                logical_fields.ingestion.fat = fat_100g
                logical_fields.ingestion.protein = proteins_100g
                logical_fields.ingestion.nutriscore = nutriscore_grade
                page_stack.push(set_food_page)
            }
            onPressAndHold: selectMode = !selectMode
        }
}