/*
 * 2022  Ivo Fernandes <pg27165@alunos.uminho.pt>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * utFoods is distributed in the hope that it will be useful,
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

UbuntuShape{
    id: add_meal_image_shape
    //public API
    property alias img_path: img.source

    SlotsLayout.position: SlotsLayout.Leading
    width: units.gu(5)
    height: units.gu(5)
    radius: "small"
    aspect: UbuntuShape.DropShadow
    Icon{
        id : img
        anchors.centerIn: parent
        height: units.gu(3.5)
        source: add_meal_image_shape.img_path
    }

}  