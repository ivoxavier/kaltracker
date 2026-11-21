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
import "../theme"

Item {
    id: indicator_root

    property var slot_indicatior: 0
    property alias slot_icon_label: indicator_label.text

    Column {
        anchors.centerIn: parent
        spacing: units.gu(0.3)

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: indicator_root.slot_indicatior
            font.pixelSize: units.gu(2.4)
            font.weight: Font.DemiBold
            color: app_style.label.labelColor
        }

        Label {
            id: indicator_label
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: units.gu(1.2)
            font.weight: Font.DemiBold
            color: app_style.label.secondaryColor
        }
    }
}
