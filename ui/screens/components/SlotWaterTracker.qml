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
import "../theme"

LomiriShape {
    id: slot_shape

    // Public API (compatível com a HomePage)
    property alias img_path: img.source
    property real water_cups_drinked: 0

    readonly property real clampedProgress: Math.max(0, Math.min(1, water_cups_drinked))

    radius: "large"
    aspect: LomiriShape.DropShadow
    backgroundColor: app_style.shape.shapeColor

    RowLayout {
        anchors {
            fill: parent
            leftMargin: units.gu(2)
            rightMargin: units.gu(2)
        }
        spacing: units.gu(1.5)

        // Ícone da água (mesmo estilo plano do SlotAddMeal)
        Rectangle {
            Layout.preferredWidth: units.gu(5)
            Layout.preferredHeight: units.gu(5)
            Layout.alignment: Qt.AlignVCenter
            radius: units.gu(1.4)
            color: app_style.shape.textInput.shapeColor

            Image {
                id: img
                anchors.centerIn: parent
                width: units.gu(3.4)
                height: units.gu(3.4)
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
        }

        // Centro: Título + Percentagem + Barra animada
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: units.gu(0.8)

            RowLayout {
                Layout.fillWidth: true

                Label {
                    text: i18n.tr("Water")
                    font.weight: Font.DemiBold
                    color: app_style.label.labelColor
                    Layout.fillWidth: true
                }

                Label {
                    text: Math.round(Math.max(0, slot_shape.water_cups_drinked) * 100) + "%"
                    font.pixelSize: units.gu(1.4)
                    font.weight: Font.DemiBold
                    color: app_style.label.secondaryColor
                }
            }


            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: units.gu(0.9)
                radius: height / 2
                color: app_style.progressBar.backgroundColor
                clip: true

                Rectangle {
                    height: parent.height
                    width: parent.width * slot_shape.clampedProgress
                    radius: parent.radius
                    color: app_style.progressBar.waterBar.waterProgress

                    Behavior on width {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }
        }


        Rectangle {
            Layout.preferredWidth: units.gu(3.6)
            Layout.preferredHeight: units.gu(3.6)
            Layout.alignment: Qt.AlignVCenter
            radius: height * 0.5
            color: app_style.shape.textInput.shapeColor

            scale: add_mouse_area.pressed ? 0.88 : 1.0
            Behavior on scale {
                NumberAnimation {
                    duration: 120
                    easing.type: Easing.OutQuad
                }
            }

            Icon {
                anchors.centerIn: parent
                name: "add"
                width: units.gu(2.2)
                height: units.gu(2.2)
                color: app_style.label.labelColor
            }

            MouseArea {
                id: add_mouse_area
                anchors.fill: parent
                anchors.margins: -units.gu(0.8)
                onClicked: {
                    dataAnalysisRepository.saveCup(logical_fields.application.date_utils.long_date)
                    root.initDB()
                }
            }
        }
    }
}
