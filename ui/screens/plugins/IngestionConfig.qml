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
import QtQuick.Layouts 1.3
import Lomiri.Components 1.3
import "../components"
import "../theme"
import "../logicalFields"

Column {
    id: ingestion_config_root
    width: parent ? parent.width : root.width
    topPadding: units.gu(1)
    bottomPadding: units.gu(3)
    spacing: units.gu(1.5)

    Label {
        x: units.gu(2.5)
        text: i18n.tr("NUTRITIONAL BREAKDOWN")
        font.pixelSize: units.gu(1.3)
        font.weight: Font.DemiBold
        color: app_style.label.secondaryColor
    }

    LomiriShape {
        width: parent.width - units.gu(3)
        anchors.horizontalCenter: parent.horizontalCenter
        height: units.gu(10.5)
        radius: "large"
        aspect: LomiriShape.DropShadow
        backgroundColor: app_style.shape.shapeColor

        RowLayout {
            anchors.fill: parent
            anchors.margins: units.gu(1.5)
            spacing: units.gu(1)


            Column {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: units.gu(0.5)

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: units.gu(3)
                    height: units.gu(0.5)
                    radius: height / 2
                    color: app_style.nutrientsColors.fat
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Number(logical_fields.ingestion.fat_ingested).toFixed(1) + "g"
                    font.pixelSize: units.gu(2.1)
                    font.weight: Font.DemiBold
                    color: app_style.label.labelColor
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: i18n.tr("Fat")
                    font.pixelSize: units.gu(1.3)
                    color: app_style.label.secondaryColor
                }
            }

            Rectangle {
                Layout.preferredWidth: units.dp(1)
                Layout.preferredHeight: units.gu(5.5)
                color: Qt.rgba(0.5, 0.5, 0.5, 0.15)
            }


            Column {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: units.gu(0.5)

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: units.gu(3)
                    height: units.gu(0.5)
                    radius: height / 2
                    color: app_style.nutrientsColors.carbo
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Number(logical_fields.ingestion.carbo_ingested).toFixed(1) + "g"
                    font.pixelSize: units.gu(2.1)
                    font.weight: Font.DemiBold
                    color: app_style.label.labelColor
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: i18n.tr("Carbs")
                    font.pixelSize: units.gu(1.3)
                    color: app_style.label.secondaryColor
                }
            }

            Rectangle {
                Layout.preferredWidth: units.dp(1)
                Layout.preferredHeight: units.gu(5.5)
                color: Qt.rgba(0.5, 0.5, 0.5, 0.15)
            }


            Column {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: units.gu(0.5)

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: units.gu(3)
                    height: units.gu(0.5)
                    radius: height / 2
                    color: app_style.nutrientsColors.protein
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Number(logical_fields.ingestion.protein_ingested).toFixed(1) + "g"
                    font.pixelSize: units.gu(2.1)
                    font.weight: Font.DemiBold
                    color: app_style.label.labelColor
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: i18n.tr("Protein")
                    font.pixelSize: units.gu(1.3)
                    color: app_style.label.secondaryColor
                }
            }
        }
    }


    Item { width: 1; height: units.gu(0.5) }

    Label {
        x: units.gu(2.5)
        text: i18n.tr("SIZE PORTION")
        font.pixelSize: units.gu(1.3)
        font.weight: Font.DemiBold
        color: app_style.label.secondaryColor
    }

    LomiriShape {
        width: parent.width - units.gu(3)
        anchors.horizontalCenter: parent.horizontalCenter
        height: units.gu(9)
        radius: "large"
        aspect: LomiriShape.DropShadow
        backgroundColor: app_style.shape.shapeColor

        SizePicker {
            anchors {
                fill: parent
                margins: units.gu(1)
            }
            onSelectedIndexChanged: {
                var portionValues = [1, 0.50, 0.33, 0.25, 0.20, 0.17];
                logical_fields.ingestion.size_portions =
                    selectedIndex >= 0 && selectedIndex < portionValues.length
                    ? portionValues[selectedIndex]
                    : 0.17;
            }
        }
    }

    Item { width: 1; height: units.gu(0.5) }

    Label {
        x: units.gu(2.5)
        text: i18n.tr("QUANTITY")
        font.pixelSize: units.gu(1.3)
        font.weight: Font.DemiBold
        color: app_style.label.secondaryColor
    }

    LomiriShape {
        width: parent.width - units.gu(3)
        anchors.horizontalCenter: parent.horizontalCenter
        height: units.gu(9)
        radius: "large"
        aspect: LomiriShape.DropShadow
        backgroundColor: app_style.shape.shapeColor

        RowLayout {
            anchors {
                fill: parent
                leftMargin: units.gu(3)
                rightMargin: units.gu(3)
            }


            Rectangle {
                Layout.preferredWidth: units.gu(5.5)
                Layout.preferredHeight: units.gu(5.5)
                Layout.alignment: Qt.AlignVCenter
                radius: width / 2
                color: app_style.shape.textInput.shapeColor
                opacity: logical_fields.ingestion.quantity_portions > 1 ? 1.0 : 0.4

                scale: minus_ma.pressed ? 0.9 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }

                Icon {
                    anchors.centerIn: parent
                    name: "remove"
                    width: units.gu(2.4)
                    height: units.gu(2.4)
                    color: app_style.label.labelColor
                }

                MouseArea {
                    id: minus_ma
                    anchors.fill: parent
                    enabled: logical_fields.ingestion.quantity_portions > 1
                    onClicked: logical_fields.ingestion.quantity_portions--
                }
            }


            Label {
                id: weight_value_label
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: units.gu(3.6)
                font.weight: Font.DemiBold
                color: app_style.label.labelColor
                text: logical_fields.ingestion.quantity_portions
            }


            Rectangle {
                Layout.preferredWidth: units.gu(5.5)
                Layout.preferredHeight: units.gu(5.5)
                Layout.alignment: Qt.AlignVCenter
                radius: width / 2
                color: app_style.shape.textInput.shapeColor

                scale: plus_ma.pressed ? 0.9 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }

                Icon {
                    anchors.centerIn: parent
                    name: "add"
                    width: units.gu(2.4)
                    height: units.gu(2.4)
                    color: app_style.button.confirmButton.buttonColor
                }

                MouseArea {
                    id: plus_ma
                    anchors.fill: parent
                    onClicked: logical_fields.ingestion.quantity_portions++
                }
            }
        }
    }
}
