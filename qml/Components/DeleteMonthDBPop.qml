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



Dialog { 
        id: deleteMonthDB
        property string month_to_delete
        property string year_to_delete

        title: i18n.tr("Enter a month & year")
        Row{ 
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: units.gu(2)      
            TextField {
                id: month_to_delete_entry
                width: units.gu(8)
                placeholderText: i18n.tr("Month")
                horizontalAlignment: TextInput.AlignHCenter
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator{}
            
                onTextChanged:{
                    if(resultOperation.visible){
                        resultOperation.visible = !resultOperation.visible
                    }
                    if (month_to_delete_entry.text <= 9){

                        //necessary as date formart in database is 'yyyy-mm-dd'
                       month_to_delete = `${0}${month_to_delete_entry.text}`
                      
                    }
                    
                    else{
                        month_to_delete = month_to_delete_entry.text
                       
                    }
                }
            }

            TextField {
                id: year_to_delete_entry
                width: units.gu(9)
                placeholderText: i18n.tr("Year")
                horizontalAlignment: TextInput.AlignHCenter
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator{}
                onTextChanged:{
                    if(resultOperation.visible){
                        resultOperation.visible = !resultOperation.visible
                    }
                    
                    year_to_delete = year_to_delete_entry.text
                }
            }

            Button{
                id: delete_button
                text: i18n.tr("Delete")
                color: UbuntuColors.red
                onClicked:{
                    DataBase.deleteMonthYearIngestion(month_to_delete, year_to_delete)
                    resultOperation.visible = !resultOperation.visible
                }
            }  

                 
        } 

        Label{
            id: resultOperation
            text: i18n.tr("Delete sucsseful")
            visible: false
            color: theme.palette.normal.positive
        }
        Button{
                text: i18n.tr("Back")
                onClicked:{
                    PopupUtils.close(deleteMonthDB)
                }
            }        
}
        

