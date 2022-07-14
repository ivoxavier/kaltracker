/*
 * 2022  Ivo Xavier
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
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Controls 2.2 as QQC2

QQC2.ProgressBar {
    id: bar
    property alias nutrient_value : bar.value

    property alias bar_color : inner_bar.color

    padding: 2
    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 6
        color: "#e6e6e6"
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
            color: "#17a81a"
        }
    }
}