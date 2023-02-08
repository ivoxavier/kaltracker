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
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import "../style"

LomiriShape{
    id: slot_shape

    Layout.preferredWidth: units.gu(20)//root.width - units.gu(25)
    Layout.preferredHeight: width

    //public API's
    property alias icon_source : slot_icon.source
    property alias slot_label : label_text.text
    property alias slot_path_label : label_path.text
    
    radius: "large"
    aspect: LomiriShape.DropShadow
    backgroundColor: app_style.shape.shapeColor

    ColumnLayout{
        width: parent.width
        Icon{
            id: slot_icon
            Layout.alignment: Qt.AlignCenter
            height : units.gu(11)
        }
        Label{
            id: label_text
            Layout.alignment: Qt.AlignCenter
        }

        BlankSpace{}

        Label{
            id: label_path
            Layout.alignment: Qt.AlignCenter
            font.pixelSize: units.gu(1)
        }
    }
}  