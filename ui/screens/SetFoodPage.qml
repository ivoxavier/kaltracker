/*
 * 2022-2026  Ivo Xavier
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
import QtQuick.Controls 2.2 as QQC2
import QtQuick.Layouts 1.3
import Lomiri.Components.Popups 1.3
import "../components"
import "../theme"
import "../plugins"
import "../logicalFields"

Page {
    id: set_food_page
    objectName: 'SetFoodPage'

    header: PageHeader {
        title: swipe_view.currentIndex === 0
               ? i18n.tr("Set Your Ingestion")
               : i18n.tr("Product Details")

        trailingActionBar.actions: [
            Action {
                iconName: "tick"
                text: i18n.tr("Save")
                onTriggered: saveIngestionData()
            }
        ]
    }

    BackgroundStyle {}


    LomiriShape {
        id: hero_header
        anchors {
            top: parent.header.bottom
            left: parent.left
            right: parent.right
            topMargin: units.gu(1.5)
            leftMargin: units.gu(1.5)
            rightMargin: units.gu(1.5)
        }
        height: units.gu(10.5)
        radius: "large"
        aspect: LomiriShape.DropShadow
        backgroundColor: app_style.shape.shapeColor

        opacity: 0
        scale: 0.96

        Component.onCompleted: entry_anim.start()

        ParallelAnimation {
            id: entry_anim
            NumberAnimation { target: hero_header; property: "opacity"; to: 1; duration: 350; easing.type: Easing.OutQuart }
            NumberAnimation { target: hero_header; property: "scale"; to: 1; duration: 400; easing.type: Easing.OutCubic }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: units.gu(1.5)
            spacing: units.gu(1.5)

            Rectangle {
                Layout.preferredWidth: units.gu(7.5)
                Layout.preferredHeight: units.gu(7.5)
                radius: units.gu(1.4)
                color: logical_fields.ingestion.image_url === ""
                       ? app_style.button.actionButton.buttonColor
                       : app_style.shape.textInput.shapeColor
                clip: true

                Label {
                    anchors.centerIn: parent
                    visible: logical_fields.ingestion.image_url === ""
                    text: logical_fields.ingestion.product_name !== ""
                          ? logical_fields.ingestion.product_name.charAt(0).toUpperCase()
                          : "?"
                    font.pixelSize: units.gu(3.5)
                    font.weight: Font.Bold
                    color: "white"
                }

                Image {
                    anchors.fill: parent
                    anchors.margins: units.dp(3)
                    source: logical_fields.ingestion.image_url
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    smooth: true
                    visible: logical_fields.ingestion.image_url !== ""
                }
            }


            ColumnLayout {
                Layout.fillWidth: true
                spacing: units.gu(0.4)

                Label {
                    Layout.fillWidth: true
                    text: logical_fields.ingestion.product_name !== ""
                          ? logical_fields.ingestion.product_name
                          : i18n.tr("Unknown Product Name")
                    font.weight: Font.DemiBold
                    font.pixelSize: units.gu(2)
                    color: app_style.label.labelColor
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }

                Label {
                    Layout.fillWidth: true
                    text: logical_fields.ingestion.quantity !== "" ? logical_fields.ingestion.quantity : ""
                    font.pixelSize: units.gu(1.4)
                    color: app_style.label.secondaryColor
                    visible: text !== ""
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.preferredHeight: units.gu(3.4)
                Layout.preferredWidth: kcal_badge_label.implicitWidth + units.gu(2)
                Layout.alignment: Qt.AlignVCenter
                radius: height / 2
                color: app_style.shape.textInput.shapeColor

                Label {
                    id: kcal_badge_label
                    anchors.centerIn: parent
                    text: Math.round(logical_fields.ingestion.cal_ingested) + " kcal"
                    font.pixelSize: units.gu(1.4)
                    font.weight: Font.DemiBold
                    color: app_style.chart.circle.calories.outColor
                }
            }
        }
    }


    Rectangle {
        id: tab_bar
        anchors {
            top: hero_header.bottom
            left: parent.left
            right: parent.right
            topMargin: units.gu(1.5)
            leftMargin: units.gu(1.5)
            rightMargin: units.gu(1.5)
        }
        height: units.gu(4.6)
        radius: units.gu(1.2)
        color: app_style.shape.textInput.shapeColor

        // Indicador deslizante do separador ativo
        Rectangle {
            width: (parent.width - units.dp(8)) / 2
            height: parent.height - units.dp(8)
            y: units.dp(4)
            x: swipe_view.currentIndex === 0 ? units.dp(4) : (parent.width / 2)
            radius: units.gu(0.9)
            color: app_style.shape.shapeColor

            Behavior on x {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }
        }

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Label {
                    anchors.centerIn: parent
                    text: i18n.tr("Ingestion")
                    font.pixelSize: units.gu(1.6)
                    font.weight: swipe_view.currentIndex === 0 ? Font.DemiBold : Font.Normal
                    color: swipe_view.currentIndex === 0
                           ? app_style.label.labelColor
                           : app_style.label.secondaryColor
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: swipe_view.currentIndex = 0
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Label {
                    anchors.centerIn: parent
                    text: i18n.tr("Details")
                    font.pixelSize: units.gu(1.6)
                    font.weight: swipe_view.currentIndex === 1 ? Font.DemiBold : Font.Normal
                    color: swipe_view.currentIndex === 1
                           ? app_style.label.labelColor
                           : app_style.label.secondaryColor
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: swipe_view.currentIndex = 1
                }
            }
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
        ];
    }

    Component { id: sucess_dialog; StoreIngestionDialog { msg: i18n.tr("Stored!") } }
    Component { id: error_dialog; MessageDialog { msg: i18n.tr("Something went wrong. Please, restart the app and try again.") } }

    function saveIngestionData() {
        try {
            var current_date = logical_fields.application.date_utils.long_date;

            if (ingestionRepository.checkUserFoodExists(logical_fields.ingestion.product_name) < 1) {
                ingestionRepository.saveUserFood({
                    "name": logical_fields.ingestion.product_name,
                    "nutriscore": logical_fields.ingestion.nutriscore,
                    "cal": logical_fields.ingestion.cal,
                    "fat": logical_fields.ingestion.fat,
                    "carbo": logical_fields.ingestion.carbo,
                    "protein": logical_fields.ingestion.protein
                });
            }

            ingestionRepository.saveIngestion({
                "name": logical_fields.ingestion.product_name,
                "nutriscore": logical_fields.ingestion.nutriscore,
                "calories": logical_fields.ingestion.cal_ingested,
                "fat": logical_fields.ingestion.fat_ingested,
                "carbs": logical_fields.ingestion.carbo_ingested,
                "protein": logical_fields.ingestion.protein_ingested,
                "mealType": logical_fields.ingestion.meal_type,
                "date": current_date
            });

            root.initDB();
            PopupUtils.open(sucess_dialog);
        } catch (err) {
            PopupUtils.open(error_dialog);
        }
    }

    QQC2.SwipeView {
        id: swipe_view
        currentIndex: 0
        anchors {
            top: tab_bar.bottom
            topMargin: units.gu(1)
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        clip: true

        Item {
            width: swipe_view.width
            height: swipe_view.height

            Flickable {
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: ingestions_config.implicitHeight + units.gu(4)
                interactive: true
                clip: true

                IngestionConfig {
                    id: ingestions_config
                    width: parent.width
                }
            }
        }

        Item {
            width: swipe_view.width
            height: swipe_view.height

            Flickable {
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: product_details.implicitHeight + units.gu(4)
                interactive: true
                clip: true

                ProductDetails {
                    id: product_details
                    width: parent.width
                }
            }
        }
    }
}
