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

    property string new_time
    
    contentWidth: hourPicker.width
        Column{ 
                
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: units.gu(1)
                    
            Label{
                
                anchors.horizontalCenter: parent.horizontalCenter
                
                text: i18n.tr("Set new time")

                fontSizeMode:Text.Fit 
                font.pixelSize: FontUtils.sizeToPixels("medium")
            }

            DatePicker {
                id: hourPicker
                mode: "Hours|Minutes"
                date: new Date()
                // make sure we have the whole component in screen
                
                width: Math.min(root.width - units.gu(7), units.gu(16))
                height: units.gu(14)
                onDateChanged: {
                    new_time = Qt.formatTime(date, "hh:mm")
                 
                }
            }

            Button{
                text: i18n.tr("Update")
                anchors.horizontalCenter: parent.horizontalCenter
                color: UbuntuColors.green
                onClicked:{
                    DataBase.updateIngestionTime(root.id_ingestion_update_time, new_time)
                    root.refreshListModel()
                }
            }    
                    
        }        
}
        

