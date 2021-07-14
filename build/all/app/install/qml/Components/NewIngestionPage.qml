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
import Ubuntu.Components.Pickers 1.0
import Ubuntu.Components.ListItems 1.3 as ListItem
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.LocalStorage 2.0
import QtQuick.XmlListModel 2.7
import "../js/DataBaseTools.js" as DataBase
import "./ListModel"


    
Page {
    id: newIngestionPage
    objectName: "NewIngestionPage"

    property int queryCategory
    
    header: PageHeader {
        id: header
        title: i18n.tr('New Ingestion')

        //contents:   /* in case I find how to filter XML Model. Can delegate here a TextField */

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
      


    Label{
        id: categoryLabel
        anchors.top: newIngestionPage.header.bottom
        font.bold: true
        text: queryCategory !=0 ? i18n.tr("Drink") : i18n.tr("Food")
    }
    ScrollView{
        
        anchors{
            top: categoryLabel.bottom
            right: newIngestionPage.right
            left: newIngestionPage.left
            bottom: newIngestionPage.bottom 
        }
        
           

        ListView {
            id: foodsList
            model: FoodsDrinks{}
            
     
            delegate: ListItem.Standard{
                    text: product_name
                    onClicked:{
                        function forceMode(){
                            shareValues.now_or_after_ingestion = "now"
                        }
                        mainStack.push(foodsTemplate)
                        shareValues.now_or_after_ingestion = "now"
                        root.stackProductName = product_name
                        root.nutriscore_grade = nutriscore_grade
                        root.stackType = type
                        root.stackEnergyKcal = energy_kcal_100g
                        root.stackFat = fat_100g
                        root.stackSaturated = saturated_fat_100g
                        root.stackCarborn = carbohydrates_100g
                        root.stackSugars = sugars_100g
                        root.stackProtein = proteins_100g
                        forceMode()
                    }
                }
        } 
    }

    Component.onCompleted: {
    queryCategory = 0
    
    }
}