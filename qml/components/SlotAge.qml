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
    property alias placeholderText: field_text.placeholderText
    
    radius: "small"
    aspect: UbuntuShape.Flat
    
    ListItem{
        divider.visible: false

        ListItemLayout{
            id: slot_layout
            
            TextField {
                id: field_text
                anchors.verticalCenter: parent.verticalCenter
                inputMethodHints: Qt.ImhDigitsOnly
                width: parent.width - units.gu(3.7)
                onTextChanged: {
                    root.user_age = field_text.text
                    if(root.user_age > 0){
                        set_age_page.is_age_inputed = true
                    } else{
                        root.user_age = 0
                        set_age_page.is_age_inputed = false
                    }
                }
            }  
        }
    }
}  