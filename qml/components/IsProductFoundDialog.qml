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
import Lomiri.Components.Pickers 1.3
import QtQuick.LocalStorage 2.12
import "../style"

Dialog { 
    id: is_product_found_dialog
    
    property string barcode
    property int is_product_found_dialog_meal
    property string product_name
    property string nutriscore_grade
    property double fat_100g
    property double carbohydrates_100g
    property double protein_100g
    property int energy_kcal_100g

    property string nova_group

    property bool is_code_empty : false

    JSONListModel {
        id: openFoodFactJSON
        source: "https://world.openfoodfacts.org/api/v0/product/" + barcode + ".json";
        query: "$[*]"
        onJsonChanged: {
            var _json = openFoodFactJSON.model.get(0);
            if (typeof _json !== "undefined" && typeof _json.product_name !== "undefined" ) {
                product_name = _json.product_name
                nutriscore_grade = (typeof _json.nutriscore_grade == "undefined") ? "a" :  _json.nutriscore_grade
                energy_kcal_100g = (typeof _json.nutriments.energy_value == "undefined") ? 0 : _json.nutriments.energy_value
                fat_100g = (typeof _json.nutriments.fat_100g == "undefined") ? 0.0 : _json.nutriments.fat_100g
                protein_100g = (typeof _json.nutriments.proteins_100g == "undefined") ? 0.0 : _json.nutriments.proteins_100g
                carbohydrates_100g = (typeof _json.nutriments.carbohydrates_100g == "undefined") ? 0.0 : _json.nutriments.carbohydrates_100g
                nova_group = (typeof _json.nova_groups == "undefined") ? "0" : _json.nova_groups
                next_button.enabled = true
                loading_circle.running = false
                loading_circle.visible = false
            }else{
                loading_circle.running = false
                loading_circle.visible = false
                enter_manually.visible = true
                is_code_empty = true
            }
        }
    }

    title: is_code_empty ? i18n.tr("BarCode Not Found")  : i18n.tr("BarCode Found")

    ActivityIndicator{
        id: loading_circle
        running : true
        visible: true
    }

    Label{
        text: i18n.tr("No product in DB, you may consider register the item on openfoodsfacts. Or enter the details manually")
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        visible : is_code_empty ? true : false
        color: app_style.label.labelColor
    }

    Label{
        text: i18n.tr("Code:%1").arg(barcode)
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color: app_style.label.labelColor
    
    }
    
    Label{
        id: product_name_label
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: i18n.tr("Name: %1").arg(product_name)
        visible : is_code_empty ? false : true
        color: app_style.label.labelColor
    }


    Button{
        text: i18n.tr("Scan Again")
        color: app_style.button.actionButton.buttonColor
        onClicked:{
            barCodeReader.is_reading = true
            PopupUtils.close(is_product_found_dialog)
        }
    }    

    Button{
        id: enter_manually
        text: i18n.tr("Enter Product Details Manually")
        color: app_style.button.actionButton.buttonColor
        visible: false
        onClicked:{
            page_stack.pop(scan_page)  
            PopupUtils.close(is_product_found_dialog)
        }
    } 

    Button{
        id: next_button
        text: i18n.tr("Next")
        color: app_style.button.confirmButton.buttonColor
        enabled: false
        onClicked:{
            page_stack.pop(scan_page)  
            PopupUtils.close(is_product_found_dialog)
            page_stack.push(set_food_page,{product_name_set_food_page: product_name,
            cal_set_food_page: energy_kcal_100g,
            carbo_set_food_page: carbohydrates_100g,
            fat_set_food_page: fat_100g,
            protein_set_food_page: protein_100g,
            nutriscore_set_food_page: nutriscore_grade,
            meal_set_food_page: is_product_found_dialog_meal,
            nova_groups_set_food_page: nova_group})    
        }
    }  
}