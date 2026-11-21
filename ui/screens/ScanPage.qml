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
import QtQuick.Layouts 1.3
import QtMultimedia 5.12
import QZXing 3.3
import QtQuick.Controls 2.2 as QQC2
import InternetChecker 0.1
import "../components"
import "../theme"
import "../plugins"

Page {   
    id: scan_page
    objectName: 'ScanPage'
    
    property int meal_scan_page: 0

    property bool showResult: false
    property bool isLoading: false
    property bool isCodeEmpty: false
    property bool noInternet: false
    

    property string bar_code_founded: ""
    property string productImageUrl: ""
    property string productQuantity: ""


    header: PageHeader {
       title: showResult ? 
              (noInternet ? i18n.tr("No Internet") : (isCodeEmpty ? i18n.tr("Not Found") : i18n.tr("Product Found"))) : 
              (swipe_view.currentIndex === 0 ? i18n.tr("Reading Bar Code...") : i18n.tr("Manual search"))

       trailingActionBar.actions: [
            Action {
                iconName: swipe_view.currentIndex === 0 ? "find" : "camera-app"
                text: swipe_view.currentIndex === 0 ? i18n.tr("Manual") : i18n.tr("Camera")
                visible: !showResult
                onTriggered: {
                    swipe_view.currentIndex = (swipe_view.currentIndex === 0) ? 1 : 0;
                }
            }
        ]
    }


    InternetChecker {
        id: internetChecker
        onInternetStatusChanged: {
            if (isConnected) {
                openFoodFactsService.fetchProduct(bar_code_founded);
            } else {
                isLoading = false
                noInternet = true
            }
        }
    }

    Connections {
        target: openFoodFactsService
        
        function onProductFound(productData) { 
            logical_fields.ingestion.product_name = productData.product_name
            logical_fields.ingestion.nutriscore = productData.nutriscore
            logical_fields.ingestion.cal = productData.cal
            logical_fields.ingestion.fat = productData.fat
            logical_fields.ingestion.protein = productData.protein
            logical_fields.ingestion.carbo = productData.carbo
            logical_fields.ingestion.nova_groups = productData.nova_groups === "" ? "0" : productData.nova_groups
            
            productImageUrl = productData.image_url;
            productQuantity = productData.quantity;

            isLoading = false
            isCodeEmpty = false
        }
        
        function onProductNotFound() {
            isLoading = false
            isCodeEmpty = true
        }
        
        function onNetworkError(errorString) {
            isLoading = false
            noInternet = true
            console.log("API Error: " + errorString)
        }
    }


    function processBarcode(code) {
        barCodeReader.is_reading = false;
        bar_code_founded = code;
        
        showResult = true;
        isLoading = true;
        noInternet = false;
        isCodeEmpty = false;
        
        internetChecker.checkInternetConnection();
    }

    function resetScanner() {
        showResult = false;
        if (swipe_view.currentIndex === 0) {
            barCodeReader.is_reading = true;
        }
    }


    QQC2.SwipeView {
        id: swipe_view
        currentIndex: 0
        visible: !showResult
        
        anchors.top: parent.header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        
        interactive: false
        clip: true
        
        onCurrentIndexChanged: {
            if (!showResult) {
                barCodeReader.is_reading = (currentIndex === 0);
            }
        }
            
        Item {
            width: swipe_view.width; height: swipe_view.height
            BarCodeReader { id: barCodeReader; anchors.fill: parent }
        }

        Item {
            width: swipe_view.width; height: swipe_view.height
            ManualCodeSearch { id: manualSearch; anchors.fill: parent }
        }
    }

    Item {
        id: resultView
        visible: showResult
        
        anchors.top: parent.header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        
        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width - units.gu(6)
            spacing: units.gu(2)


            ActivityIndicator {
                Layout.alignment: Qt.AlignCenter
                running: isLoading
                visible: running
            }


            ColumnLayout {
                Layout.fillWidth: true
                visible: !isLoading && !isCodeEmpty && !noInternet
                spacing: units.gu(1.5)

                Image {
                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredHeight: units.gu(18)
                    Layout.preferredWidth: units.gu(18)
                    source: productImageUrl !== "" ? productImageUrl : "../../assets/apple-fruit-svgrepo-com.svg"
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: LomiriColors.ash
                        border.width: 1
                        radius: units.gu(1)
                        visible: productImageUrl !== ""
                    }
                }

                Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: logical_fields.ingestion.product_name !== "" ? 
                          logical_fields.ingestion.product_name : i18n.tr("Unknown Product Name")
                    font.weight: Font.Bold
                    font.pixelSize: units.gu(2.5)
                    color: app_style.label.labelColor
                }

                Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: productQuantity !== "" ? productQuantity : i18n.tr("N/A")
                    color: LomiriColors.ash
                    font.pixelSize: units.gu(1.5)
                }

                RowLayout {
                    Layout.alignment: Qt.AlignCenter
                    spacing: units.gu(3)
                    
                    Label { text: "🔥 " + Math.round(logical_fields.ingestion.cal) + " kcal"; color: app_style.label.labelColor }
                    Label { text: "🥩 " + Math.round(logical_fields.ingestion.protein) + "g"; color: app_style.label.labelColor }
                    Label { text: "🌾 " + Math.round(logical_fields.ingestion.carbo) + "g"; color: app_style.label.labelColor }
                }
                
                Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: i18n.tr("Code: %1").arg(bar_code_founded)
                    color: LomiriColors.ash
                    font.pixelSize: units.gu(1.2)
                    Layout.topMargin: units.gu(1)
                }
            }


            Label {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                visible: noInternet
                color: LomiriColors.red
                text: i18n.tr("Please check your internet connection and try again.")
            }

            Label {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                visible: isCodeEmpty && !noInternet
                color: app_style.label.labelColor
                text: i18n.tr("Product not in OpenFoodFacts database.\nYou can enter the details manually.")
            }


            Item { Layout.preferredHeight: units.gu(2) }

            Button {
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: parent.width * 0.8
                text: i18n.tr("Confirm & Next")
                color: LomiriColors.green
                visible: !noInternet && !isCodeEmpty && !isLoading
                onClicked: {
                    page_stack.pop(scan_page)  
                    page_stack.push(set_food_page)    
                }
            }
            
            Button {
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: parent.width * 0.8
                text: i18n.tr("Enter Manually")
                color: app_style.button.actionButton.buttonColor
                visible: isCodeEmpty || noInternet
                onClicked: {
                    page_stack.pop(scan_page)  

                }
            } 


            Button {
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: parent.width * 0.8
                text: i18n.tr("Scan Again / Cancel")
                color: "transparent"
                visible: !isLoading
                onClicked: {
                    resetScanner();
                }
            }    
        }
    }
}
