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
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Ubuntu.Components.ListItems 1.3 
import Ubuntu.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2


UbuntuShape{
    id: slot_shape

    // make public API's
    property alias img_path: slot_img_credentials.img_path
    property alias color : slot_shape.backgroundColor
    property alias text : plan_label.text
    property alias text_color : plan_label.color

    radius: "small"
    aspect: UbuntuShape.DropShadow
    
    ListItem{
        height: slot_layout.height
        divider.visible: false
        ListItemLayout{
            id: slot_layout

            Text{
                id: plan_label
            }

            UbuntuShape{
                id: slot_img_credentials
                property alias img_path: img.source
                SlotsLayout.position: SlotsLayout.Leading
                width: units.gu(5)
                height: units.gu(5)
                radius: "large"
                aspect: UbuntuShape.DropShadow
                //backgroundColor:"black"
                source: Image{
                    id: img
                    source: slot_img_credentials.img_path
                }
            }  
        }
    }
}  
