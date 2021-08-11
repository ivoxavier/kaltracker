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
    
    property bool isActivated: false


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

                         if (root.now_or_after_ingestion === 1 ){
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
                          
                         } else{

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
                         }
                        
                     }
                }
            ]
        }
    }

    property int quantity_portions : 1
    property double size_portions : 1


    Item{
    
        Component{
                id: nutriensPop
            
            Popover{ 
                Column{ 
                
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: units.gu(2)
                topPadding: units.gu(1)

                    Row{
                        spacing: units.gu(2)
                        Label{
                            
                            anchors.verticalCenter: parent.verticalCenter
                            
                            text: "Fat/100g"
                        }

                        TextField{
                            id: fatEntry
                            text: "0.0"
                            horizontalAlignment: TextInput.AlignHCenter
                            inputMethodHints: Qt.ImhDigitsOnly
                            onTextChanged: {
                                root.stackFat = fatEntry.text
                                console.log(root.stackFat)
                            }
                            
                        }
                        
                    }
                    
                    Row{
                        spacing: units.gu(2)
                        Label{
                            anchors.verticalCenter: parent.verticalCenter
                            text:"Saturated/100g"
                        }

                        TextField{
                            id: saturatedEntry
                            text: "0.0"
                            horizontalAlignment: TextInput.AlignHCenter
                            inputMethodHints: Qt.ImhDigitsOnly
                            onTextChanged: {
                                root.stackSaturated = saturatedEntry.text
                                console.log(root.stackSaturated)
                            }
                            
                        }

                    }

                    Row{
                        spacing: units.gu(2)
                        Label{
                            anchors.verticalCenter: parent.verticalCenter
                            text:"C.hydrates/100g"
                        }

                        TextField{
                            id: carbornEntry
                            text: "0.0"
                            horizontalAlignment: TextInput.AlignHCenter
                            inputMethodHints: Qt.ImhDigitsOnly
                            onTextChanged: {
                                root.stackCarborn = carbornEntry.text
                                console.log(root.stackCarborn)
                            }
                            
                        }

                    }

                    Row{
                        spacing: units.gu(2)
                        Label{
                            anchors.verticalCenter: parent.verticalCenter
                            text:"Sugars/100g"
                        }

                        TextField{
                            id: sugarsEntry
                            text: "0.0"
                            horizontalAlignment: TextInput.AlignHCenter
                            inputMethodHints: Qt.ImhDigitsOnly
                            onTextChanged: {
                                root.stackSugars = sugarsEntry.text
                                console.log(root.stackSugars)
                            }
                    
                        }

                    }

                    Row{
                        spacing: units.gu(2)
                        Label{
                            anchors.verticalCenter: parent.verticalCenter
                            text:"Proteins/100g"
                        }

                        TextField{
                            id: proteinsEntry
                            text: "0.0"
                            horizontalAlignment: TextInput.AlignHCenter
                            inputMethodHints: Qt.ImhDigitsOnly
                            onTextChanged: {
                                root.stackProtein = proteinsEntry.text
                                console.log(root.stackProtein)
                            }
                            
                        }

                    }
                    
            }
            
            }
        }
    }





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
                        TextField{
                            id: productNameEntry
                            SlotsLayout.position: SlotsLayout.Leading
                            width: (scrollView.width / 2) + units.gu(5)
                            height: units.gu(5) 
                            placeholderText : "Product name"
                            onTextChanged: {
                                root.stackProductName = productNameEntry.text
                            }
                        }

                        Picker {
                        SlotsLayout.position: SlotsLayout.Trailing
                        width: units.gu(12)
                        height: units.gu(5)
                        circular: false
                        selectedIndex: 0
                        model: [ i18n.tr("Food"), i18n.tr("Drink")] 
                        delegate: PickerDelegate { 
                            Label {
                                text: modelData
                                
                                anchors.horizontalCenter: parent.horizontalCenter
                                
                                anchors.verticalCenter: parent.verticalCenter
                        }
                        }
                        onSelectedIndexChanged: {
                            selectedIndex === 0 ? root.stackType = "Food" : root.stackType = "Drink"
                            console.log(root.stackType)

                }
            } 

                    }
                }


            ListItem {

                    ListItemLayout{
                        title.text: i18n.tr("kcal/100g")
                            TextField{
                                id: kcalEntry
                                width: units.gu(12)
                                height: units.gu(5) 
                                text: "0.0"
                                horizontalAlignment: TextInput.AlignHCenter
                                inputMethodHints: Qt.ImhDigitsOnly
                                onTextChanged: {
                                    root.stackEnergyKcal = kcalEntry.text
                                    console.log(root.stackEnergyKcal)
                                }
                            }

                            Button{
                                id: nutriensButton
                                text: i18n.tr("Nutrients")
                                iconName: "down"
                                iconPosition: "right"
                                width: units.gu(14)
                                onClicked:{
                                    PopupUtils.open(nutriensPop, nutriensButton)
                                }
                            }
 
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

            ListItem{
                 ListItemLayout{
                    title.text: i18n.tr("Schedulde")

                    CheckBox {
                        checked: false
                        onCheckedChanged: {
                            
                            isActivated = !isActivated
                            root.now_or_after_ingestion = 1
                        }
                    }
                }
            }

            ListItem{
                height: monthPicker.height + units.gu(2)
                 ListItemLayout{

                    DatePicker {
                        id: monthPicker
                        enabled: isActivated
                        mode: "Days|Months|Years"
                        width: Math.min(root.width - units.gu(9), units.gu(23))
                        height: units.gu(14)
                        onDateChanged: {
                            root.userSchedule_date = Qt.formatDate(date, "yyyy-MM-dd")
                        }
                    }

                    DatePicker {
                        id: hourPicker
                        enabled: isActivated
                        mode: "Hours|Minutes"
                        date: new Date()
                        width: Math.min(root.width - units.gu(7), units.gu(16))
                        height: units.gu(14)
                        onDateChanged: {
                            root.userSchedule_time = Qt.formatTime(date, "hh:mm")
                    
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted:{

            root.stackType = "Food"
            root.stackEnergyKcal = 0
            root.stackFat = 0
            root.stackSaturated = 0
            root.stackCarborn = 0
            root.stackSugars = 0
            root.stackProtein = 0
            

    }   
}
  


