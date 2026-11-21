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

Item {
    id: slot_root


    property alias slot_icon_label: macro_label.text
    property alias bar_color: inner_bar.color
    property real nutrient_value: 0

    readonly property real clampedValue: isNaN(nutrient_value) ? 0 : Math.max(0, Math.min(1, nutrient_value))

    ColumnLayout {
        anchors.fill: parent
        spacing: units.gu(0.6)

        RowLayout {
            Layout.fillWidth: true

            Label {
                id: macro_label
                font.pixelSize: units.gu(1.3)
                font.weight: Font.DemiBold
                color: app_style.label.secondaryColor
                Layout.fillWidth: true
            }

            Label {
                text: Math.round(slot_root.clampedValue * 100) + "%"
                font.pixelSize: units.gu(1.2)
                font.weight: Font.DemiBold
                color: app_style.label.labelColor
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: units.gu(0.8)
            radius: height / 2
            color: app_style.progressBar.backgroundColor
            clip: true

            Rectangle {
                id: inner_bar
                height: parent.height
                width: parent.width * slot_root.clampedValue
                radius: parent.radius

                Behavior on width {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }
}
