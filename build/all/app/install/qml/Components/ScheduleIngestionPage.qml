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
import Ubuntu.Components.ListItems 1.3 as ListItem
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.LocalStorage 2.0
import QtQuick.XmlListModel 2.7
import "../js/DataBaseTools.js" as DataBase
import "./ListModel"


    
Page {
    id: scheduleIngestionPage
    objectName: "ScheduleIngestionPage"

    property int queryCategory
    property string to_eat
    property string to_type
    property int to_energy
    property double to_fat
    property double to_saturated
    property double to_carborn
    property double to_sugars
    property double to_fiber
    property double to_proteins
    property double to_salt
    property string schedule_date
    property string schedule_time

    header: PageHeader {
        id: header
        title: i18n.tr('Schedule')

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
            
            numberOfSlots: 0
            actions: [
    
                Action{
                  text: i18n.tr("Food")
                  onTriggered: queryCategory = 0
                },

                Action{
                  text: i18n.tr("Drink")
                  onTriggered: queryCategory = 1  
                }
            ]
        }
            }
      
    
   
    Component {
        id: ingestionStoredDialog
        SaveDataDialog{

            msg:i18n.tr("Ingestion Stored")
            
            labelColor:UbuntuColors.green
            }
    }

    Label{
        id: categoryLabel
        anchors.top: scheduleIngestionPage.header.bottom
        font.bold: true
        text: queryCategory !=0 ? i18n.tr("Drink") : i18n.tr("Food")
    }
    ScrollView{
        id:scrollView
        anchors{
            top: categoryLabel.bottom
            right: scheduleIngestionPage.right
            left: scheduleIngestionPage.left
            bottom: scheduleIngestionPage.verticalCenter
        }
        
           Item {
    
        Component{
            id: pops
            Popover {

                    Label{
                        
                        text: "Set date&time then long press on foods"
                    }
                    
                }
        }
    }

        ListView {
            id: foodsList
            model: FoodsDrinks{}
     
            delegate: ListItem.Standard{            
                    text: product_name
                   
                    onClicked:{
                         console.log("newIngestion: " + product_name)
                        root.stackProductName = product_name
                        root.stackType = type
                        root.stackEnergyKcal = energy_kcal_100g
                        root.stackFat = fat_100g
                        root.stackSaturated = saturated_fat_100g
                        root.stackCarborn = carbohydrates_100g
                        root.stackSugars = sugars_100g
                        root.stackFiber = fiber_100g
                        root.stackProtein = proteins_100g
                        root.stackSalt = salt_100g
                        root.user_schedule_time
                        root.user_schedule_date
                        root.now_after_ingestion = "schedule"
                    }
                }
        } 
    }
    Column{
        anchors.top: scrollView.bottom
        topPadding: units.gu(1)
  
        
        spacing: units.gu(3)
        width: scheduleIngestionPage.width
        Row{
            spacing:units.gu(2)
            
            anchors.horizontalCenter: parent.horizontalCenter
            
            DatePicker {
                id: monthPicker
                mode: "Days|Months|Years"
                // make sure we have the whole component in screen
                width: Math.min(root.width - units.gu(9), units.gu(23))
                height: units.gu(14)
                onDateChanged: {
                    console.log(Qt.formatDate(date, "yyyy-MM-dd"))
                   root.user_schedule_date = Qt.formatDate(date, "yyyy-MM-dd")
                }
            }

            DatePicker {
                id: hourPicker
                mode: "Hours|Minutes"
                date: new Date()
                // make sure we have the whole component in screen
                
                width: Math.min(root.width - units.gu(7), units.gu(16))
                height: units.gu(14)
                onDateChanged: {
                    console.log(Qt.formatTime(date, "hh:mm"))
                    root.user_schedule_time = Qt.formatTime(date, "hh:mm")
                    
                }
            }
        }

           Label{
                anchors.horizontalCenter: parent.horizontalCenter
               text: root.stackProductName
           }
           Button{
               
               anchors.horizontalCenter: parent.horizontalCenter
               
                text: i18n.tr("Ok")
                onClicked:{
                    mainStack.push(foodsTemplate)
                }
            }
        

    }
    

    Component.onCompleted: {
    queryCategory = 0
    
    }
}

