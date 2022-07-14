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
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Ubuntu.Components.ListItems 1.3 
import Ubuntu.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2


UbuntuShape{
    id: slot_shape

    // make public API's
    property alias color : slot_shape.backgroundColor
    property alias value: value_text.text
    property alias message: message_text.text
    radius: "large"
    aspect: UbuntuShape.Flat
    
    ListItem{
        height: slot_layout.height
        divider.visible: false

        SlotsLayout{
            id: slot_layout
            mainSlot: ColumnLayout{
                
                Text{id: value_text;
                font.pixelSize: units.gu(3);
                Layout.alignment: Qt.AlignCenter}
                Text{id: message_text;Layout.alignment: Qt.AlignCenter}

            }
            
        }
    }
}  
