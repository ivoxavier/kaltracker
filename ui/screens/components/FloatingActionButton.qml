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
import QtGraphicalEffects 1.0

Item {
    id: fab_root
    width: units.gu(7)
    height: units.gu(7)

    property string iconName: ""
    property string iconSource: ""
    property string backgroundColor: app_style.button.actionButton.buttonColor
    property string iconColor: "white"
    signal clicked()

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: fab_root.backgroundColor

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            color: Qt.rgba(0, 0, 0, 0.25)
            radius: units.gu(1)
            samples: 16
            verticalOffset: units.dp(2)
        }

        Icon {
            anchors.centerIn: parent
            width: units.gu(3)
            height: units.gu(3)
            name: fab_root.iconName !== "" ? fab_root.iconName : ""
            source: fab_root.iconSource !== "" ? fab_root.iconSource : ""
            color: fab_root.iconColor
        }

        MouseArea {
            anchors.fill: parent
            onClicked: fab_root.clicked()
            onPressed: parent.opacity = 0.7
            onReleased: parent.opacity = 1.0
            onCanceled: parent.opacity = 1.0
        }
    }
}
