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
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import Lomiri.Components.Pickers 1.3
import QtQuick.LocalStorage 2.12
import "../../js/ControlBarCodeInfo.js" as ControlBarCodeInfo

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

    property bool is_code_empty : false

    JSONListModel {
        id: openFoodFactJSON
        source: "https://world.openfoodfacts.org/api/v0/product/" + barcode + ".json";
        query: "$[*]"
        onJsonChanged: ControlBarCodeInfo.getData()
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
    }

    Label{
        text: i18n.tr("Code:%1").arg(barcode)
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    
    }
    
    Label{
        id: product_name_label
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: i18n.tr("Name: %1").arg(product_name)
        visible : is_code_empty ? false : true
    }

    Label{
        id: nutriscore_label
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: i18n.tr("Nutriscore: %1").arg(nutriscore_grade)
        visible : is_code_empty ? false : true
    }

    Label{
        id: cal_label
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: i18n.tr("Calories/100gr: %1").arg(energy_kcal_100g)
        visible : is_code_empty ? false : true
    }

    Label{
        id: fat_label
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: i18n.tr("Fat/100gr: %1").arg(fat_100g)
        visible : is_code_empty ? false : true
    }

    Label{
        id: protein_label
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: i18n.tr("Protein/100gr: %1").arg(protein_100g)
        visible : is_code_empty ? false : true
    }

    Label{
        id: carbo_label
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: i18n.tr("Carbohydrates/100gr: %1").arg(carbohydrates_100g)
        visible : is_code_empty ? false : true
    }

    Button{
        id: next_button
        text: i18n.tr("Next")
        color: LomiriColors.green
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
            meal_set_food_page: is_product_found_dialog_meal})    
        }
    }  

    Button{
        text: i18n.tr("Scan Again")
        color: LomiriColors.blue
        onClicked:{
            PopupUtils.close(is_product_found_dialog)
        }
    }    

    Button{
        id: enter_manually
        text: i18n.tr("Enter Product Details Manually")
        color: LomiriColors.blue
        visible: false
        onClicked:{
            page_stack.pop(scan_page)  
            PopupUtils.close(is_product_found_dialog)
        }
    }  
}