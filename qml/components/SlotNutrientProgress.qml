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
import QtQuick.Controls 2.2 as QQC2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import "../style"

LomiriShape{
    id: slot_shape

    // make public API's
    property alias slot_icon_label : slot_icon_label.text
    property alias bar_color : inner_bar.color
    property alias nutrient_value : bar.value

    aspect: LomiriShape.Flat

    ColumnLayout{
        id: slot_layout
        width: parent.width
        spacing: units.gu(0.5)

        Text{
            id: slot_icon_label
            Layout.alignment: Qt.AlignCenter
            color : app_style.label.labelColor 
        }

        Rectangle{  
            Layout.alignment: Qt.AlignCenter
            width: parent.width
            height : units.gu(1)
            color: "transparent"
            QQC2.ProgressBar {
                id: bar
                width:  parent.width
                height : parent.height
                padding: 2
                background: Rectangle {
                implicitWidth: 200
                implicitHeight: 6
                color: app_style.progressBar.backgroundColor
                radius: 10
                }
                contentItem: Item {
                    implicitWidth: 200
                    implicitHeight: 4
                    Rectangle {
                        id: inner_bar
                        width: bar.visualPosition * parent.width
                        height: parent.height
                        radius: 10
                    }
                }
            }
        }
    }
}  