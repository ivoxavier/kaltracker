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
import QtQuick.Controls 2.2 as QQC2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Ubuntu.Components.ListItems 1.3 
import Ubuntu.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import "../../js/WaterTrackerTable.js" as WaterTrackerTable
import "../../js/WaterDrinkCalc.js" as WaterDrinkCalc
import "../../js/GetData.js" as GetData
UbuntuShape{
    id: slot_shape

    //public API's
    property alias img_path: add_meal_image_shape.img_path
    property alias water_cups_drinked : bar.value 

    radius: "small"
    aspect: UbuntuShape.DropShadow
    
    ListItem{
        height: slot_layout.height
        divider.visible: false
        
        ListItemLayout{
            id: slot_layout

            QQC2.ProgressBar {
                id: bar
                width: root.width - units.gu(25.5)
                height : units.gu(3.5)
                padding: 2
                background: Rectangle {
                implicitWidth: 200
                implicitHeight: 6
                color: "#e6e6e6"
                radius: 10
                }
                contentItem: Item {
                implicitWidth: 200
                implicitHeight: 4

                Rectangle {
                    id: inner_bar
                    width: bar.visualPosition * parent.width
                    height: parent.height
                    radius: 10
                    color: "#5abcd8"
                }
            }
        }
            Rectangle{ 
                height: units.gu(3.5)
                width:  height
                color: "#f1f1f1"
                radius: height*0.5  
                Icon {
                    id: add_icon_yes
                    property int category
                    name: "add"
                    anchors.centerIn: parent
                    height : units.gu(2.5)
                    MouseArea{
                        anchors.fill: parent
                        onPressed:{
                            bar.scale = 0.8
                            WaterTrackerTable.saveCup() 
                        }
                        onReleased:{
                            GetData.getCups()
                            bar.scale = 1
                            progression : true
                        }
                    }
                }
            }

            UbuntuShape{
                id: add_meal_image_shape
                //public API
                property alias img_path: img.source

                SlotsLayout.position: SlotsLayout.Leading
                width: units.gu(5)
                height: units.gu(5)
                radius: "large"
                aspect: UbuntuShape.DropShadow
                source: Image{
                    id: img
                    source: add_meal_image_shape.img_path
                }
            }  
        }
    }
}  