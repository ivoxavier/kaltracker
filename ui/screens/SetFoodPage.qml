/*
 * 2022-2026  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 * ...
 */


import QtQuick 2.9
import Lomiri.Components 1.3
import QtQuick.Controls 2.2 as QQC2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.Popups 1.3
import "../components"
import "../theme"
import "../plugins"
import "../logicalFields"

Page {
    id: set_food_page
    objectName: 'SetFoodPage'
    
    header: PageHeader {
        title: swipe_view.currentIndex === 0 ? 
               i18n.tr("Set Your Ingestion") : i18n.tr("Product Details")
        
        trailingActionBar.actions: [
            Action {
                iconName: "tick" 
                text: i18n.tr("Save")
                onTriggered: saveIngestionData()
            }
        ]
    }
    
    BackgroundStyle {}
    
    Rectangle {
        id: hero_header
        anchors.top: parent.header.bottom
        width: parent.width
        height: units.gu(12)
        color: "transparent"
        
        opacity: 0
        scale: 0.95

        Component.onCompleted: entry_anim.start()

        ParallelAnimation {
            id: entry_anim
            NumberAnimation { target: hero_header; property: "opacity"; to: 1; duration: 450; easing.type: Easing.OutQuart }
            NumberAnimation { target: hero_header; property: "scale"; to: 1; duration: 550; easing.type: Easing.OutBack }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: units.gu(2)
            spacing: units.gu(2)
            Item {
                Layout.preferredWidth: units.gu(8)
                Layout.preferredHeight: units.gu(8)

                Rectangle {
                    anchors.fill: parent
                    radius: units.gu(1.5)
                    color: app_style.button.actionButton.buttonColor
                    visible: logical_fields.ingestion.image_url === ""

                    Label {
                        anchors.centerIn: parent
                        text: logical_fields.ingestion.product_name !== "" ? 
                              logical_fields.ingestion.product_name.charAt(0).toUpperCase() : "?"
                        font.pixelSize: units.gu(4)
                        font.weight: Font.Bold
                        color: "white"
                    }
                }

                Image {
                    anchors.fill: parent
                    source: logical_fields.ingestion.image_url
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    visible: logical_fields.ingestion.image_url !== ""

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: LomiriColors.ash
                        border.width: 1
                        radius: units.gu(1.5)
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: units.gu(0.5)

                Label {
                    Layout.fillWidth: true
                    text: logical_fields.ingestion.product_name !== "" ? logical_fields.ingestion.product_name : i18n.tr("Unknown Product Name")
                    font.weight: Font.Bold
                    font.pixelSize: units.gu(2.2)
                    color: app_style.label.labelColor
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }
                
                Label {
                    Layout.fillWidth: true
                    text: logical_fields.ingestion.quantity !== "" ? logical_fields.ingestion.quantity : ""
                    font.pixelSize: units.gu(1.5)
                    color: LomiriColors.ash
                    visible: text !== ""
                }
            }
        }
        
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: units.dp(1)
            color: LomiriColors.ash
            opacity: 0.15
        }
    }
    
    function getChartPieValues() {
        return [
            {
                value: logical_fields.ingestion.fat_ingested,
                color: app_style.chart.circle.productNutrients.fatPie,
                highlight: app_style.chart.circle.productNutrients.pieHighlight,
                label: i18n.tr("Fat/100g")
            },
            {
                value: logical_fields.ingestion.protein_ingested,
                color: app_style.chart.circle.productNutrients.proteinPie,
                highlight: app_style.chart.circle.productNutrients.pieHighlight,
                label: i18n.tr("Protein/100g")
            },
            {
                value: logical_fields.ingestion.carbo_ingested,
                color: app_style.chart.circle.productNutrients.carbPie,
                highlight: app_style.chart.circle.productNutrients.pieHighlight,
                label: i18n.tr("Carbo/100g")
            }
        ]
    }
    
    Component { id: sucess_dialog; StoreIngestionDialog { msg: i18n.tr("Stored!") } }
    Component { id: error_dialog; MessageDialog { msg: i18n.tr("Something went wrong. Please, restart the app and try again.") } }

    function saveIngestionData() {
        try {
            var current_date = logical_fields.application.date_utils.long_date;

            if (ingestionRepository.checkUserFoodExists(logical_fields.ingestion.product_name) >= 1) {
                ingestionRepository.saveIngestion({
                    "name": logical_fields.ingestion.product_name,
                    "nutriscore": logical_fields.ingestion.nutriscore,
                    "calories": logical_fields.ingestion.cal_ingested,
                    "fat": logical_fields.ingestion.fat_ingested,
                    "carbs": logical_fields.ingestion.carbo_ingested,
                    "protein": logical_fields.ingestion.protein_ingested,
                    "mealType": logical_fields.ingestion.meal_type,
                    "date": current_date 
                })
            } else {
                ingestionRepository.saveUserFood({
                    "name": logical_fields.ingestion.product_name,
                    "nutriscore": logical_fields.ingestion.nutriscore,
                    "cal": logical_fields.ingestion.cal,
                    "fat": logical_fields.ingestion.fat,
                    "carbo": logical_fields.ingestion.carbo,
                    "protein": logical_fields.ingestion.protein
                })

                ingestionRepository.saveIngestion({
                    "name": logical_fields.ingestion.product_name,
                    "nutriscore": logical_fields.ingestion.nutriscore,
                    "calories": logical_fields.ingestion.cal_ingested,
                    "fat": logical_fields.ingestion.fat_ingested,
                    "carbs": logical_fields.ingestion.carbo_ingested,
                    "protein": logical_fields.ingestion.protein_ingested,
                    "mealType": logical_fields.ingestion.meal_type,
                    "date": current_date
                })
            }
            root.initDB()
            PopupUtils.open(sucess_dialog)
        } catch (err) {
            PopupUtils.open(error_dialog)
        } 
    }

    QQC2.SwipeView {
        id: swipe_view
        currentIndex: 0
        anchors.top: hero_header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true 

        Item {
            width: swipe_view.width; height: swipe_view.height
            Flickable {
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: ingestions_config.implicitHeight + units.gu(10)
                interactive: true; clip: true

                IngestionConfig {
                    id: ingestions_config
                    width: parent.width
                }
            }
        }
        
        Item {
            width: swipe_view.width; height: swipe_view.height
            Flickable {
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: product_details.implicitHeight + units.gu(10)
                interactive: true; clip: true

                ProductDetails {
                    id: product_details
                    width: parent.width
                }
            }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: units.gu(2)
        width: swipe_view_indicator.width + units.gu(4)
        height: swipe_view_indicator.height + units.gu(1)
        color: LomiriColors.ink
        opacity: 0.5
        radius: units.gu(2)
        
        QQC2.PageIndicator {
            id: swipe_view_indicator
            count: swipe_view.count
            currentIndex: swipe_view.currentIndex
            anchors.centerIn: parent
        } 
    }
}