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
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Controls.Suru 2.2
import "../components"
import "../style"

Item {
    width: parent ? parent.width : units.gu(40)
    height: parent ? parent.height : units.gu(60)

    RowLayout {
        anchors.centerIn: parent
        width: parent.width - units.gu(4)
        height: parent.height - units.gu(18)
        spacing: units.gu(2)

        
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: units.gu(1.5)

            NutrientIcon {
                Layout.alignment: Qt.AlignHCenter
                img_path: "../../assets/olive-oil-svgrepo-com.svg"
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: i18n.tr("Fat")
                font.weight: Font.DemiBold
                color: app_style.label.labelColor
            }
            
            Rectangle {
                id: fatSlider
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: units.gu(20)
                color: Qt.rgba(0.5, 0.5, 0.5, 0.15)
                radius: units.gu(1)
                clip: true

                property real minValue: 0
                property real maxValue: 100 
                property real currentValue: logical_fields.ingestion.fat
                
                
                property real fillHeight: (currentValue - minValue) / (maxValue - minValue) * height

                
                Rectangle {
                    width: parent.width
                    height: parent.fillHeight
                    anchors.bottom: parent.bottom 
                    color: "#F2B705" 
                    radius: parent.radius
                    
                    Behavior on height {
                        NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                    }
                }

                
                Label {
                    anchors.centerIn: parent
                    text: fatSlider.currentValue.toFixed(1) + " g"
                    font.pixelSize: units.gu(2.5)
                    font.weight: Font.DemiBold
                    color: app_style.label.labelColor
                    z: 2
                }

                MouseArea {
                    anchors.fill: parent
                    preventStealing: true

                    function updateValue(mouse) {
                        var clickY = Math.max(0, Math.min(mouse.y, height));
                        var percent = 1.0 - (clickY / height);
                        var rawValue = fatSlider.minValue + (percent * (fatSlider.maxValue - fatSlider.minValue));
                        logical_fields.ingestion.fat = Number(rawValue.toFixed(1));
                    }

                    onPressed: updateValue(mouse)
                    onPositionChanged: updateValue(mouse)
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: units.gu(1.5)

            NutrientIcon {
                Layout.alignment: Qt.AlignHCenter
                img_path: "../../assets/cheese-svgrepo-com.svg"
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: i18n.tr("Protein")
                font.weight: Font.DemiBold
                color: app_style.label.labelColor
            }

            Rectangle {
                id: proteinSlider
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: units.gu(20)
                color: Qt.rgba(0.5, 0.5, 0.5, 0.15)
                radius: units.gu(1)
                clip: true

                property real minValue: 0
                property real maxValue: 100
                property real currentValue: logical_fields.ingestion.protein
                property real fillHeight: (currentValue - minValue) / (maxValue - minValue) * height

                Rectangle {
                    width: parent.width
                    height: parent.fillHeight
                    anchors.bottom: parent.bottom
                    color: "#4A90E2"
                    radius: parent.radius
                    
                    Behavior on height {
                        NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                    }
                }

                Label {
                    anchors.centerIn: parent
                    text: proteinSlider.currentValue.toFixed(1) + " g"
                    font.pixelSize: units.gu(2.5)
                    font.weight: Font.DemiBold
                    color: app_style.label.labelColor
                    z: 2
                }

                MouseArea {
                    anchors.fill: parent
                    preventStealing: true

                    function updateValue(mouse) {
                        var clickY = Math.max(0, Math.min(mouse.y, height));
                        var percent = 1.0 - (clickY / height);
                        var rawValue = proteinSlider.minValue + (percent * (proteinSlider.maxValue - proteinSlider.minValue));
                        logical_fields.ingestion.protein = Number(rawValue.toFixed(1));
                    }

                    onPressed: updateValue(mouse)
                    onPositionChanged: updateValue(mouse)
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: units.gu(1.5)

            NutrientIcon {
                Layout.alignment: Qt.AlignHCenter
                img_path: "../../assets/bread-svgrepo-com.svg"
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: i18n.tr("Carbo")
                font.weight: Font.DemiBold
                color: app_style.label.labelColor
            }

            
            Rectangle {
                id: carboSlider
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: units.gu(20)
                color: Qt.rgba(0.5, 0.5, 0.5, 0.15)
                radius: units.gu(1)
                clip: true

                property real minValue: 0
                property real maxValue: 100
                property real currentValue: logical_fields.ingestion.carbo
                property real fillHeight: (currentValue - minValue) / (maxValue - minValue) * height

                Rectangle {
                    width: parent.width
                    height: parent.fillHeight
                    anchors.bottom: parent.bottom
                    color: "#4CAF50"
                    radius: parent.radius
                    
                    Behavior on height {
                        NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                    }
                }

                Label {
                    anchors.centerIn: parent
                    text: carboSlider.currentValue.toFixed(1) + " g"
                    font.pixelSize: units.gu(2.5)
                    font.weight: Font.DemiBold
                    color: app_style.label.labelColor
                    z: 2
                }

                MouseArea {
                    anchors.fill: parent
                    preventStealing: true

                    function updateValue(mouse) {
                        var clickY = Math.max(0, Math.min(mouse.y, height));
                        var percent = 1.0 - (clickY / height);
                        var rawValue = carboSlider.minValue + (percent * (carboSlider.maxValue - carboSlider.minValue));
                        logical_fields.ingestion.carbo = Number(rawValue.toFixed(1));
                    }

                    onPressed: updateValue(mouse)
                    onPositionChanged: updateValue(mouse)
                }
            }
        }
    }
}