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
import QtQuick.Controls 2.2 as QQC2
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import QtCharts 2.3
import "../js/DataBaseTools.js" as DataBase

Page {
    
    id: manualIngestionPage
    objectName: 'Manual Ingestion Page'
    


    header: PageHeader {
        title: "Manual Ingestion"
        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }

    ActionBar {

            StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
            }
            
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            
            numberOfSlots: 1

            actions: [

                Action{

                    iconName: "ok"
                    
                     onTriggered: {

                         if (shareValues.now_or_after_ingestion === "now" ){
                             console.log("Saving [now ingestion], foods: " + root.stackProductName)
                             DataBase.saveNewIngestion(root.stackProductName,
                          root.nutriscore_grade,
                          root.stackType,
                          (root.stackEnergyKcal * quantity_portions) * size_portions,
                          (root.stackFat * quantity_portions) * size_portions, 
                          (root.stackSaturated * quantity_portions) * size_portions,
                          (root.stackCarborn * quantity_portions) * size_portions,
                          (root.stackSugars * quantity_portions) * size_portions,
                          (root.stackProtein * quantity_portions) * size_portions)
                          root.initDB()
                          root.refreshListModel()
                          PopupUtils.open(ingestionStoredDialog)
                          
                         } else{
                             console.log("saving schedule ingestion")
                               DataBase.saveScheduleIngestion(root.stackProductName,
                                root.nutriscore_grade,
                                root.stackType,
                                (root.stackEnergyKcal * quantity_portions) * size_portions,
                                (root.stackFat * quantity_portions) * size_portions, 
                                (root.stackSaturated * quantity_portions) * size_portions,
                                (root.stackCarborn * quantity_portions) * size_portions,
                                (root.stackSugars * quantity_portions) * size_portions,
                                (root.stackProtein * quantity_portions) * size_portions,
                        root.userSchedule_date,
                        root.userSchedule_time)
                        root.initDB()
                        root.refreshListModel()
                        PopupUtils.open(ingestionStoredDialog)
                        
                         }
                        
                     }
                }
            ]
        }
    }

    property int quantity_portions : 1
    property double size_portions : 1

     Component {
        id: ingestionStoredDialog
        SaveDataDialog{

            msg:i18n.tr("Ingestion Stored")
            
            labelColor:UbuntuColors.green
            }
    }

    ScrollView{ 
        id: scrollView
        width: parent.width
        height : parent.height
        clip : true                 

        Column{
            id: column
            topPadding:  manualIngestionPage.header.height
            width: manualIngestionPage.width
            


            ListItem {
                    id: fatItem
                    ListItemLayout{
                        title.text: "Fat/100g"
                        subtitle.text:  Math.round((root.stackFat * quantity_portions) * size_portions) + "g"
                    }
                }



            ListItem {

                ListItemLayout{
                    title.text: i18n.tr("Quantity portions")

                    QQC2.SpinBox{

                        height:  (manualIngestionPage.header.height / 1.8)
                        width:  (manualIngestionPage.width / 2) - units.gu(10)

                        value: 1
                        onValueChanged: quantity_portions = value         
                        
                     }
                }
            }
                
            ListItem {
                ListItemLayout{
                    title.text: i18n.tr("Size of portions")
                    Picker {
                        id: userActivityLevelEntry
                        anchors.verticalCenter: parent.verticalCenter
                        width: units.gu(10)
                        height: units.gu(5)
                        circular: false
                        selectedIndex: 0
                        model: [ "1/1", "1/2", "1/3", "1/4", "1/5", "1/6"] 
                        delegate: PickerDelegate { 
                            Label {
                                text: modelData
                                
                                anchors.horizontalCenter: parent.horizontalCenter
                                
                                anchors.verticalCenter: parent.verticalCenter
                        }
                        }
                        onSelectedIndexChanged: {
                        switch (selectedIndex) {
                        case 0:
                            console.log("1/1")
                            size_portions  = 1
                            break;
                        case 1:
                            console.log("1/2")
                            size_portions  = 0.50
                            break;
                        case 2:
                            console.log("1/3")
                            size_portions  = 0.33
                            break;
                        case 3:
                            console.log("1/4")
                            size_portions  = 0.25
                            break;
                        case 4:
                            console.log("1/5")
                            size_portions  = 0.20
                            break;
                        case 5:
                            console.log("1/6")
                            size_portions  = 0.17
                            break;
                            default:
                            break;
                    }
                }
            } 
                    }
                }
                

            }   
      }
  
}

