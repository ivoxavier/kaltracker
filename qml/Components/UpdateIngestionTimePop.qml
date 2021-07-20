/*
 * 2021  Ivo Xavier
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
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import "../js/DataBaseTools.js" as DataBase



Popover { 

    Connections{
        //target: abc
        //onId: console.log(idIngestion)
    }
    contentWidth: hourPicker.width
        Column{ 
                
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: units.gu(2)
            //topPadding: units.gu(1)
                    
                    
            DatePicker {
                id: hourPicker
                mode: "Hours|Minutes"
                date: new Date()
                // make sure we have the whole component in screen
                
                width: Math.min(root.width - units.gu(7), units.gu(16))
                height: units.gu(14)
                onDateChanged: {
                    console.log(Qt.formatTime(date, "hh:mm"))                    
                }
            }
                
                    
        }
    Component.onDestruction: console.log("jkashdkjaslkdjh")            
}
        

