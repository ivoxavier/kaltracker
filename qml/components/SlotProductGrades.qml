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
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import "../style"

LomiriShape{
    id: slot_shape
    Layout.preferredWidth: root.width - units.gu(32)
    Layout.preferredHeight: width//units.gu(12)

    //public API's
    property alias grade: grade_level.text
    property alias subject: grade_name.text
    property alias color: slot_shape.backgroundColor

    radius: "large"
    aspect: LomiriShape.DropShadow
    
    ColumnLayout{
        width: slot_shape.width
        spacing: units.gu(1)
        
        Text{id:grade_level;Layout.alignment: Qt.AlignCenter;color:"white";font.bold : true;font.pixelSize: units.gu(4);font.capitalization: Font.AllUppercase}
        
        Rectangle{
            Layout.alignment: Qt.AlignCenter
            width: parent.width
            height: width
            color:"transparent"
            Text{id:grade_name;
                anchors.fill: parent
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                color:"white";
                font.bold : true;font.pixelSize: units.gu(1.5)}
        }
    }
}  