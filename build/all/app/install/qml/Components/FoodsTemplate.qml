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
import "UiAddOns"

Page {
    
    id: foodsTemplatePage
    objectName: 'Foods Template Page'


    

    Connections{
        enabled: false
        target: newIngestionPage
        onNew_ingestion_details: {
            
        
        //console.log(product_name,nutriscore_grade,type,energy_kcal_100g,fat_100g,saturated_fat_100g,carbohydrates_100g,sugars_100g,proteins_100g)
      
        }
    }

    property string type_ingestion

    property color score_grade_foreground
    property string score_grade_label

    property bool isEnabled: false

    


    header: PageHeader {
        title: root.stackProductName
       
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
            topPadding:  foodsTemplatePage.header.height
            width: foodsTemplatePage.width
            
            Rectangle{
                width: parent.width
                height: (foodsTemplatePage.header.height + foodsTemplatePage.header.height) + units.gu(2.5)
                color: "transparent"
                
                Rectangle{
                    
                    id: kcalRectangle
                    anchors.left: parent.left
                    height: parent.height
                    width: (parent.width / 2) - units.gu(5.5)
                    color: "transparent"
                    
                    Label{
                        id: kcalNumber
                        anchors.centerIn: parent
                            
                        text: Math.round((root.stackEnergyKcal * quantity_portions) * size_portions)
                        textSize: Label.Large
                        font.bold: true
                     }

                    Label{ 
                        anchors.top: kcalNumber.bottom
                            
                        anchors.horizontalCenter: parent.horizontalCenter
                            
                        text: i18n.tr("Calories")
                            
                    }
                        
                }

                Rectangle{
                    anchors.right: parent.right
                    anchors.left: kcalRectangle.right
                    height: parent.height
                    color: "transparent"
                            
                    ChartView {
                        id: chartPie
                        anchors.fill: parent
                        legend.alignment: Qt.AlignRight
                        antialiasing: true
                        backgroundColor: root.defaultForegroundColor
                        PieSeries {
                            id: pieSeries
                            PieSlice { label: i18n.tr("Kcal"); value: (root.stackEnergyKcal * quantity_portions) * size_portions}
                            PieSlice { label: i18n.tr("Goal") ; value: root.userGoal}  
                        }
                    }
                } 
            }

            ListItemHeader{
                    title.text: i18n.tr("Quantity of ingestion")
                }

            ListItem {
                divider.visible: false
                ListItemLayout{
                    title.text: i18n.tr("Quantity of portions")

                    QQC2.SpinBox{

                        height:  (foodsTemplatePage.header.height / 1.8)
                        width:  (foodsTemplatePage.width / 2) - units.gu(10)

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


            ListItemHeader{
                    title.text: i18n.tr("Scheduling")
                }

            ListItem{
                 ListItemLayout{
                    title.text: i18n.tr("Time & date")

                    CheckBox {
                        id: checkBoxSchedule
                        checked: false
                        onCheckedChanged: {
                            
                            isEnabled = !isEnabled
                            root.now_or_after_ingestion = checkBoxSchedule.checked === false ? 0 : 1                   
                        }
                    }
                }
            }


            ListItem{
                height: monthPicker.height + units.gu(2)
                visible: isEnabled
                 ListItemLayout{

                    DatePicker {
                        id: monthPicker
                
                        mode: "Days|Months|Years"
                        date: new Date()
                        width: Math.min(root.width - units.gu(9), units.gu(23))
                        height: units.gu(14)
                        onDateChanged: {
                            root.userSchedule_date = Qt.formatDate(date, "yyyy-MM-dd")
                        }
                    }

                    DatePicker {
                        id: hourPicker

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
                
                ListItemHeader{
                    title.text: i18n.tr("Details")
                }

                ListItem {
                    id: nutritionScore
                    
                    ListItemLayout{
                        
                        title.text: "Nutrition score"
                        subtitle.text:  score_label.text === "a" ?
                        i18n.tr("Very good nutritional quality") : score_label.text === "b" ?
                        i18n.tr("Good nutritional quality") : score_label.text === "c" ?
                        i18n.tr("Average nutritional quality") : score_label.text === "d" ?
                        i18n.tr("Poor nutritional quality") : i18n.tr("Bad nutritional quality")
                        
                        
                        UbuntuShape {
                            id: imageShape

                            height: units.gu(5)
                            width: height
                            color: score_label.text === 'a' ?
                            "green" : score_label.text === 'b' ?
                            "#09b227" : score_label.text === 'c' ?
                            "#cba000" : score_label.text === 'd' ?
                            "#e57a01" : score_label.text === 'e' ?
                            UbuntuColors.red : "black"
                            radius: "large"
                            aspect: UbuntuShape.Inset
                            Label{
                                id: score_label
                                anchors.centerIn: parent
                                text: root.nutriscore_grade
                                textSize: Label.Large
                                font.capitalization: Font.AllUppercase
                                color: "white"
                            }
                        }
                    }
                }
                
                
                ListItemHeader{
                    title.text: i18n.tr("Nutrients")
                }

                ListItem {
                    id: fatItem
                    divider.visible: false
                    ListItemLayout{
                        title.text: i18n.tr("Fat/100g")
                        subtitle.text:  Math.round((root.stackFat * quantity_portions) * size_portions) + "g"
                    }
                }

                ListItem {
                    id: saturatedItem
                    divider.visible: false
                    ListItemLayout{
                        title.text: i18n.tr("Saturated/100g")
                        subtitle.text: Math.round((root.stackSaturated * quantity_portions)  * size_portions) + "g"
                        
                    }
                }

                ListItem {
                    id: carbohydratesItem
                    divider.visible: false
                    ListItemLayout{
                        title.text: i18n.tr("CarbornHydrates/100g")
                        subtitle.text: Math.round((root.stackCarborn * quantity_portions) * size_portions) + "g"
                    }
                }

                ListItem {
                    id: sugarsItem
                    divider.visible: false
                    ListItemLayout{
                        title.text: i18n.tr("Sugars/100g")
                        subtitle.text: Math.round((root.stackSugars * quantity_portions) * size_portions) + "g"
                    } 
                }


                ListItem {
                    id: proteinsItem
                    divider.visible: false
                    ListItemLayout{
                        title.text: i18n.tr("Protein/100g")
                        subtitle.text: Math.round((root.stackProtein * quantity_portions) * size_portions) + "g"
                    }
                }

            }   
      }
   
}

