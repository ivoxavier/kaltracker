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
import Lomiri.Components 1.3
//import QtQuick.Controls 2.2 as QC
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import Lomiri.Components.Pickers 1.3


Row{
	width: root.width
    layoutDirection: Qt.RightToLeft 
    rightPadding: units.gu(2)
    bottomPadding: units.gu(3)

    IconButton{
        icon_source: "../../assets/apple-fruit-svgrepo-com.svg"
        MouseArea{
            anchors.fill: parent
            onClicked: page_stack.push(quick_addition_page,{meal_quick_addition_page : meal_quick_list_foods_page})
        }
    }
}