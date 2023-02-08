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


LomiriShape{
    id: slot_shape

    // make public API's
    property alias img_path: slot_img_credentials.img_path
    property alias color : slot_shape.backgroundColor
    property alias text : plan_label.text
    property alias text_color : plan_label.color

    radius: "large"
    aspect: LomiriShape.DropShadow
    
    ListItem{
        height: slot_layout.height
        divider.visible: false
        ListItemLayout{
            id: slot_layout

            Text{id: plan_label}

            LomiriShape{
                id: slot_img_credentials
                property alias img_path: img.source
                SlotsLayout.position: SlotsLayout.Leading
                width: units.gu(5)
                height: units.gu(5)
                radius: "large"
                aspect: LomiriShape.DropShadow
                //backgroundColor:"black"
                source: Image{
                    id: img
                    source: slot_img_credentials.img_path
                }
            }  
        }
    }
}  
