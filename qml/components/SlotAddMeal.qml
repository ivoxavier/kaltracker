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

    //public API's
    property alias title: slot_layout.title
    property alias subtitle: slot_layout.subtitle
    property alias meal_category : add_icon_yes.category
    property alias img_path: add_meal_image_shape.img_path
    property alias color : slot_shape.backgroundColor
    
    radius: "small"
    aspect: LomiriShape.DropShadow
    
    ListItem{
        height: slot_layout.height
        divider.visible: false

        ListItemLayout{
            id: slot_layout
            title.font.bold: true
            title.color : Suru.theme === 0 ? root.kaltracker_light_theme.text_color : root.kaltracker_dark_theme.text_color
            subtitle.font.bold: true
            Rectangle{
                height: units.gu(3.5)
                width:  height
                color: "#f1f1f1"
                radius: height*0.5
                Icon {
                    id: add_icon_yes
                    property int category
                    anchors.centerIn: parent
                    name: "add"
                    height : units.gu(2.5)
                    MouseArea{
                        anchors.fill: parent
                        onClicked: page_stack.push(quick_list_foods_page,{meal_quick_list_foods_page: slot_shape.meal_category}) 
                     }
                }
            }
            

            LomiriShape{
                id: add_meal_image_shape
                //public API
                property alias img_path: img.source

                SlotsLayout.position: SlotsLayout.Leading
                width: units.gu(5)
                height: units.gu(5)
                radius: "large"
                aspect: LomiriShape.DropShadow
                source: Image{
                    id: img
                    source: add_meal_image_shape.img_path
                }
            }  
        }
    }
}  