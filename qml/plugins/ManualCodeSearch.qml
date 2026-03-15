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
import QtQuick.Window 2.0
import Lomiri.Components 1.3
import QtMultimedia 5.12
import QtGraphicalEffects 1.0
import QZXing 3.3
import QtQuick.Controls 2.2 as QQC2
import Lomiri.Content 1.3
import Lomiri.Components.Pickers 1.3
import Lomiri.Components.Popups 1.3
import Qt.labs.settings 1.0
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.3
import InternetChecker 0.1
import "../components"
import "../style"
import "../logicalFields"

ColumnLayout {
    width: root.width
    property string manual_barcode

    BlankSpace {}

    InternetChecker {
        id: internetChecker
        onInternetStatusChanged: {
            if (isConnected) {
                
                code_searcher_timer.running = true
                openFoodFactJSON.source = "https://world.openfoodfacts.org/api/v0/product/" + manual_barcode + ".json";
                openFoodFactJSON.query = "$[*]"
                openFoodFactJSON.load()    
            } else {
            
                activityIndicator.running = false
                activityIndicator.visible = false
                PopupUtils.open(messageNoInternet)
            }
        }
    }

    RowLayout {
        Layout.alignment: Qt.AlignCenter
        LomiriShape {  
            Layout.preferredWidth: root.width - units.gu(18)
            Layout.preferredHeight: units.gu(4)
            radius: "large"
            aspect: LomiriShape.Inset
            backgroundColor: app_style.shape.textInput.shapeColor
        
            TextField {
                anchors.fill: parent
                horizontalAlignment: TextField.AlignHCenter
                verticalAlignment: TextField.AlignVCenter
                inputMethodHints: Qt.ImhDigitsOnly
                color : app_style.label.labelColor 
                placeholderText: i18n.tr("Enter the code bar here")
                onTextChanged: { 
                    manual_barcode = text
                }
            }
        }

        Timer {
            id: code_searcher_timer
            interval: 9000
            repeat: true
            running: false
            onTriggered: {
                PopupUtils.open(messageError)
                code_searcher_timer.stop()
                activityIndicator.running = false
                activityIndicator.visible = false
            }
        }

        Button {
            Layout.preferredWidth: units.gu(8)
            Layout.preferredHeight: units.gu(4)
            Layout.alignment: Qt.AlignCenter
            iconName: "find"
            onClicked: {
                if (manual_barcode.length > 0) {
                    
                    activityIndicator.running = true
                    activityIndicator.visible = true
                    internetChecker.checkInternetConnection()
                }
            }
        }

        ActivityIndicator {
            id: activityIndicator
            visible: false
            running: false
            Layout.preferredHeight: units.gu(3.5)
        }
    }

    Component {
        id: messageError
        MessageDialog { msg: i18n.tr("Code not found. Try again, or check if the code is correct. There's a possibility that the product is not in the database as well. In that case, you can add it manually and go over to OpenFoodsFacts and add it there also.") }
    }

   
    Component {
        id: messageNoInternet
        MessageDialog { msg: i18n.tr("No Internet Connection. Please activate your internet connection and try again.") }
    }
    
    JSONListModel {
        id: openFoodFactJSON
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
                activityIndicator.running = false
                activityIndicator.visible = false
                code_searcher_timer.stop()
                ok_button.visible = true
            } else {
                // ...
            }
        }
    }

    BlankSpace {}

    Label {
        Layout.alignment: Qt.AlignLeft
        text: i18n.tr("Product name: ") + logical_fields.ingestion.product_name
    }
}