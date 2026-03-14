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
import InternetChecker 0.1
import "../style"
import "../logicalFields"

Dialog { 
    id: is_product_found_dialog
    
    property string barcode
    property bool is_code_empty : false
    
    property bool no_internet : false 

    
    InternetChecker {
        id: internetChecker
        onInternetStatusChanged: {
            if (isConnected) {
            
                openFoodFactJSON.source = "https://world.openfoodfacts.org/api/v0/product/" + barcode + ".json";
            } else {
        
                loading_circle.running = false
                loading_circle.visible = false
                no_internet = true
            }
        }
    }

    
    onBarcodeChanged: {
        if (barcode !== "") {
            loading_circle.running = true
            loading_circle.visible = true
            no_internet = false
            is_code_empty = false
            internetChecker.checkInternetConnection()
        }
    }

    JSONListModel {
        id: openFoodFactJSON
        query: "$[*]"
        onJsonChanged: {
            var _json = openFoodFactJSON.model.get(0);
            if (typeof _json !== "undefined" && typeof _json.product_name !== "undefined" ) {
                logical_fields.ingestion.product_name = _json.product_name
                logical_fields.ingestion.nutriscore = (typeof _json.nutriscore_grade == "undefined") ? "a" :  _json.nutriscore_grade
                logical_fields.ingestion.cal = (typeof _json.nutriments.energy_value == "undefined") ? 0 : _json.nutriments.energy_value
                logical_fields.ingestion.fat = (typeof _json.nutriments.fat_100g == "undefined") ? 0.0 : _json.nutriments.fat_100g
                logical_fields.ingestion.protein = (typeof _json.nutriments.proteins_100g == "undefined") ? 0.0 : _json.nutriments.proteins_100g
                logical_fields.ingestion.carbo = (typeof _json.nutriments.carbohydrates_100g == "undefined") ? 0.0 : _json.nutriments.carbohydrates_100g
                logical_fields.ingestion.nova_groups = (typeof _json.nova_groups == "undefined") ? "0" : _json.nova_groups
                next_button.enabled = true
                loading_circle.running = false
                loading_circle.visible = false
            } else {
                loading_circle.running = false
                loading_circle.visible = false
                enter_manually.visible = true
                is_code_empty = true
            }
        }
    }

    
    title: no_internet ? i18n.tr("No Internet Connection") : (is_code_empty ? i18n.tr("BarCode Not Found") : i18n.tr("BarCode Found"))

    ActivityIndicator{
        id: loading_circle
        running : true
        visible: true
    }

    
    Label {
        text: i18n.tr("Please activate your internet connection and try again.")
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        visible: no_internet
        color: app_style.label.labelColor
    }

    Label{
        text: i18n.tr("No product in DB, you may consider register the item on openfoodsfacts. Or enter the details manually")
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        visible : is_code_empty && !no_internet 
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
        text: i18n.tr("Name: %1").arg(typeof product_name !== "undefined" ? product_name : "")
        visible : !is_code_empty && !no_internet && !loading_circle.running
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
        visible: is_code_empty || no_internet
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
        visible: !no_internet && !is_code_empty
        onClicked:{
            page_stack.pop(scan_page)  
            PopupUtils.close(is_product_found_dialog)
            page_stack.push(set_food_page)    
        }
    }  
}