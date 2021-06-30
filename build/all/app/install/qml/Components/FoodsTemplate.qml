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
import QtCharts 2.3
import "../js/DataBaseTools.js" as DataBase

Page {
    
    id: foodsTemplatePage
    objectName: 'Foods Template Page'
    
    header: PageHeader {
        title: "Add Ingestion"
        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }


    }


    Column{
        anchors.top: foodsTemplatePage.header.bottom
        width: parent.width

        ListItem {
            id: productName
            ListItemLayout{
                title.text: stackValues.stackProductName
                subtitle.text: "By OpenFoodsFacts"
            }
        }

        Rectangle{
            width: parent.width
            height: (foodsTemplatePage.header.height + productName.height) + units.gu(2.5)
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
                    
                    text: stackValues.stackEnergyKcal
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
                //width: (parent.width / 2)
                color: "transparent"
                    
                    ChartView {

                        id: chartPie
                        anchors.fill: parent
                        legend.alignment: Qt.AlignRight
                        antialiasing: true
                        backgroundColor: root.defaultForegroundColor
                        PieSeries {
                            id: pieSeries
                            PieSlice { label: i18n.tr("Kcal"); value: stackValues.stackEnergyKcal }
                            PieSlice { label: i18n.tr("Goal") ; value: userSettings.userConfigsGoal }
                    
                        }
                    }
            } 
        }
        
         ListItem {
            id: fatItem
            ListItemLayout{
                title.text: "Fat/100g"
                subtitle.text: stackValues.stackFat + "g"
            }
        }

        ListItem {
            id: saturatedItem
            ListItemLayout{
                title.text: "Saturated/100g"
                subtitle.text: stackValues.stackSaturated + "g"
                showDivider: false
            }
        }
        ListItem {
            id: carbohydratesItem
            ListItemLayout{
                title.text: "CarbornHydrates/100g"
                subtitle.text: stackValues.stackCarborn + "g"
            }
        }

        ListItem {
            id: sugarsItem
            ListItemLayout{
                title.text: "Sugars/100g"
                subtitle.text: stackValues.stackSugars + "g"
            } 
        }

        /*ListItem {
            id: fiberItem
            ListItemLayout{
                title.text: "Fibers"
                subtitle.text: stackValues.stackFiber + "g"
            }
        }*/

        ListItem {
            id: proteinsItem
            ListItemLayout{
                title.text: "Protein/100g"
                subtitle.text: stackValues.stackProtein + "g"
            }
        }

        ListItem {
            id: saltItem
            ListItemLayout{
                title.text: "Salt/100g"
                subtitle.text: stackValues.stackSalt + "g"
            }
        }
    }   
}

