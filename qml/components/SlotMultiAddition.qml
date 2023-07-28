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
import QtQuick.LocalStorage 2.12
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import "../style"
import "../../js/IngestionsTable.js" as Ingestions

LomiriShape{
    id: slot_shape

    //public API's
    property alias selectCount : slot_layout.title
    property alias selectSum : slot_layout.subtitle

    radius: "large"
    aspect: LomiriShape.DropShadow
    backgroundColor: app_style.shape.shapeColor

    ListItem{
        height: slot_layout.height
        divider.visible: false
        ListItemLayout{
            id: slot_layout
            title.font.bold: true
            title.color : app_style.label.labelColor
            subtitle.font.bold: true

            Rectangle{
                height: units.gu(3.5)
                width:  height
                color: app_style.abstractButton.buttonColor
                radius: height*0.5
                Icon {
                    id: add_icon_yes
                    property int category
                    anchors.centerIn: parent
                    name: "ok"
                    height : units.gu(2.5) 
                    color: app_style.abstractButton.iconColor
                }
                MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            Ingestions.saveIngestion(list_view_foods.getSelection())
                            root.initDB()
                            page_stack.pop(stored_dialog)
                        }
                }
            }

            LomiriShape{
                SlotsLayout.position: SlotsLayout.Leading
                width: units.gu(5)
                height: units.gu(5)
                radius: "large"
                aspect: LomiriShape.DropShadow
                Icon{
                    anchors.fill: parent
                    name: 'stock_store'
                }
            }  
        }
    }
}  