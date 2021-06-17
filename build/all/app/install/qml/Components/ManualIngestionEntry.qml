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
       id: manualIngestionEntryDialog
       objectName: "Manual Ingestion Entry Dialog"
       title: i18n.tr("Manual Entry")                                                                                               

        property string foodsType: foodPicker.selectedIndex === 0 ? "Food" : "Drink"
        Row{
            spacing: units.gu(2)
            
            
            Picker {
                id: foodPicker
                height: units.gu(4)
                width: units.gu(7)
                circular: false

                model:
                [
                i18n.tr('Food'),
                i18n.tr('Drink')
                ]
                selectedIndex:0

                delegate:   PickerDelegate { 
                                Label {
                                    text: modelData
                                    y:units.gu(1)
                                    x:units.gu(1)
                                }
                                
                            }
            }

            TextField {
                id: ingestionEntry
                width: units.gu(12)
                placeholderText: i18n.tr("Ingestion")
            }

            TextField {
                id: kcalEntry
                placeholderText: i18n.tr("kcal")
                width: units.gu(8)
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator {}
            }
        }


        Row{
            spacing : units.gu(10)                          
            //anchors.horizontalCenter: parent.horizontalCenter
            width: manualIngestionEntryDialog.title.width
            Button {
                text: i18n.tr("Back")
                onClicked:{
                    PopupUtils.close(manualIngestionEntryDialog)
                } 
            }

            Button {
                text: i18n.tr("Save")
                color: "green"
                onClicked: {
                    DataBase.saveNewIngestion(ingestionEntry.text,foodsType, kcalEntry.text)
                    root.initDB()
                    root.refreshListModel()
                    PopupUtils.close(manualIngestionEntryDialog)
                }
            }
        }  
}
