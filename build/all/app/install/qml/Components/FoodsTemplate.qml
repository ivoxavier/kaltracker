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
    
    id: foodsTemplatePage
    objectName: 'Foods Template Page'
    
    property string type_ingestion

    property color score_grade_foreground
    property string score_grade_label

    


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
                            
                        text: (root.stackEnergyKcal * quantity_portions) * size_portions
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
                            PieSlice { label: i18n.tr("Goal") ; value: userSettings.userConfigsGoal }
                            
                        }
                    }
                } 
            }

            ListItem {

                ListItemLayout{
                    title.text: i18n.tr("Quantity portions")

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
                        model: [ "1/1", "1/2", "1/3", "1/4"] 
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
                            default:
                            break;
                    }
                }
            } 
                    }
                }
                
                
                ListItem {
                    id: nutritionScore
                    ListItemLayout{
                        title.text: "Nutrition score"
                        subtitle.text:  score_label.text

                        
                        
                        UbuntuShape {
                            id: imageShape

                            height: units.gu(5)
                            width: height
                            color: score_label.text === 'a' ?
                            "green" : score_label.text === 'b' ?
                            "#09b227" : score_label.text === 'c' ?
                            "#cba000" : score_label.text === 'd' ?
                            "orange" : score_label.text === 'e' ?
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
                
                
                
                ListItem {
                    id: fatItem
                    ListItemLayout{
                        title.text: "Fat/100g"
                        subtitle.text:  Math.round((root.stackFat * quantity_portions) * size_portions) + "g"
                    }
                }

                ListItem {
                    id: saturatedItem
                    ListItemLayout{
                        title.text: "Saturated/100g"
                        subtitle.text: Math.round((root.stackSaturated * quantity_portions)  * size_portions) + "g"
                        
                    }
                }

                ListItem {
                    id: carbohydratesItem
                    ListItemLayout{
                        title.text: "CarbornHydrates/100g"
                        subtitle.text: Math.round((root.stackCarborn * quantity_portions) * size_portions) + "g"
                    }
                }

                ListItem {
                    id: sugarsItem
                    ListItemLayout{
                        title.text: "Sugars/100g"
                        subtitle.text: Math.round((root.stackSugars * quantity_portions) * size_portions) + "g"
                    } 
                }


                ListItem {
                    id: proteinsItem
                    ListItemLayout{
                        title.text: "Protein/100g"
                        subtitle.text: Math.round((root.stackProtein * quantity_portions) * size_portions) + "g"
                    }
                }

            }   
      }
    Component.onCompleted: console.log(shareValues.now_or_after_ingestion)
}

