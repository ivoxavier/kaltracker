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

LomiriShape {
    id: slot_shape

    property alias title: slot_layout.title
    property alias subtitle: slot_layout.subtitle
    property alias img_path: img.source
    property int meal_category: 0

    radius: "large"
    aspect: LomiriShape.DropShadow
    backgroundColor: app_style.shape.shapeColor

    scale: card_mouse_area.pressed ? 0.97 : 1.0
    Behavior on scale {
        NumberAnimation {
            duration: 120
            easing.type: Easing.OutQuad
        }
    }

    ListItemLayout {
            id: slot_layout
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width

            title.font.weight: Font.DemiBold
            title.color: app_style.label.labelColor
            subtitle.font.weight: Font.Normal
            subtitle.color: app_style.label.secondaryColor

            Rectangle {
                SlotsLayout.position: SlotsLayout.Leading
                width: units.gu(5)
                height: units.gu(5)
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

            Rectangle {
                SlotsLayout.position: SlotsLayout.Trailing
                width: units.gu(3.6)
                height: units.gu(3.6)
                radius: height * 0.5
                color: app_style.shape.textInput.shapeColor

                Icon {
                    anchors.centerIn: parent
                    name: "add"
                    width: units.gu(2.2)
                    height: units.gu(2.2)
                    color: app_style.label.labelColor
                }
            }
        }

    MouseArea {
        id: card_mouse_area
        anchors.fill: parent
        onClicked: {
            logical_fields.ingestion.meal_type = slot_shape.meal_category
            page_stack.push(quick_list_foods_page)
        }
    }
}
