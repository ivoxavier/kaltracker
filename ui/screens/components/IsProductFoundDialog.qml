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
import "../theme"
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
                // Chama o novo C++ Service
                openFoodFactsService.fetchProduct(barcode);
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

    // Ligações aos sinais do C++
    Connections {
        target: openFoodFactsService
        
        onProductFound: { // Recebe o QVariantMap (productData)
            logical_fields.ingestion.product_name = productData.product_name
            logical_fields.ingestion.nutriscore = productData.nutriscore
            logical_fields.ingestion.cal = productData.cal
            logical_fields.ingestion.fat = productData.fat
            logical_fields.ingestion.protein = productData.protein
            logical_fields.ingestion.carbo = productData.carbo
            logical_fields.ingestion.nova_groups = productData.nova_groups === "" ? "0" : productData.nova_groups
            
            // Podes gravar aqui a fibra, sal, quantidade e até imagem se adicionares os campos no futuro!

            next_button.enabled = true
            loading_circle.running = false
            loading_circle.visible = false
        }
        
        onProductNotFound: {
            loading_circle.running = false
            loading_circle.visible = false
            enter_manually.visible = true
            is_code_empty = true
        }
        
        onNetworkError: {
            loading_circle.running = false
            loading_circle.visible = false
            no_internet = true
            console.log("Erro da API: " + errorString)
        }
    }

    title: no_internet ? i18n.tr("No Internet Connection") : (is_code_empty ? i18n.tr("BarCode Not Found") : i18n.tr("BarCode Found"))

    ActivityIndicator {
        id: loading_circle
        running: true
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

    Label {
        text: i18n.tr("No product in DB, you may consider register the item on openfoodsfacts. Or enter the details manually")
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        visible : is_code_empty && !no_internet 
        color: app_style.label.labelColor
    }

    Label {
        text: i18n.tr("Code: %1").arg(barcode)
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color: app_style.label.labelColor
    }
    
    Label {
        id: product_name_label
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        // Lemos diretamente do logical_fields já atualizado
        text: i18n.tr("Name: %1").arg(logical_fields.ingestion.product_name)
        visible : !is_code_empty && !no_internet && !loading_circle.running
        color: app_style.label.labelColor
    }

    Button {
        text: i18n.tr("Scan Again")
        color: app_style.button.actionButton.buttonColor
        onClicked: {
            barCodeReader.is_reading = true
            PopupUtils.close(is_product_found_dialog)
        }
    }    

    Button {
        id: enter_manually
        text: i18n.tr("Enter Product Details Manually")
        color: app_style.button.actionButton.buttonColor
        visible: is_code_empty || no_internet
        onClicked: {
            page_stack.pop(scan_page)  
            PopupUtils.close(is_product_found_dialog)
        }
    } 

    Button {
        id: next_button
        text: i18n.tr("Next")
        color: app_style.button.confirmButton.buttonColor
        enabled: false
        visible: !no_internet && !is_code_empty
        onClicked: {
            page_stack.pop(scan_page)  
            PopupUtils.close(is_product_found_dialog)
            page_stack.push(set_food_page)    
        }
    }  
}