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
import QtQuick 2.12 as RefreshResumePage
import "../js/DataBaseTools.js" as DataBase
import "../js/Quotes.js" as Quotes


    
Page {
    id: newIngestionPage
    objectName: "NewIngestionPage"

    property int queryCategory

    header: PageHeader {
        id: header
        title: i18n.tr('New Ingestion')

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
            
            numberOfSlots: 2
            actions: [
                Action{
                    iconName: "add"
                    text: i18n.tr("Manual Entry")
                    onTriggered: {
                        PopupUtils.open(manualIngestionEntryDialog)
                  }
                },
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
      
    

    Component{
        id: manualIngestionEntryDialog
        ManualIngestionEntry{}
    }
   
    Component {
        id: ingestionStoredDialog
        SaveDataDialog{

            msg:i18n.tr("Ingestion Stored")
            
            labelColor:UbuntuColors.green
            }
    }

    XmlListModel {
            id: xmlScheme
            source: "../xml/foods.xml"
            query: queryCategory === 0 ? "/foods/item/Food" : "/foods/item/Drink"

            XmlRole { name: "product_name"; query: "product_name/string()" }
            XmlRole { name: "type"; query: "type/string()" }
            XmlRole { name: "energy_kcal_100g"; query: "energy_kcal_100g/string()" }
            XmlRole { name: "fat_100g"; query: "fat_100g/string()" }
            XmlRole { name: "saturated_fat_100g"; query: "saturated_fat_100g/string()" }
            XmlRole { name: "carbohydrates_100g"; query: "carbohydrates_100g/string()" }
            XmlRole { name: "sugars_100g"; query: "sugars_100g/string()" }
            XmlRole { name: "fiber_100g"; query: "fiber_100g/string()" }
            XmlRole { name: "proteins_100g"; query: "proteins_100g/string()" }
            XmlRole { name: "salt_100g"; query: "salt_100g/string()" }
    }
    
    ScrollView{
        
        anchors{
            top: newIngestionPage.header.bottom
            right: newIngestionPage.right
            left: newIngestionPage.left
            bottom: newIngestionPage.bottom 
        }

        ListView {
            id: foodsList
            model: xmlScheme

          
     
            delegate: ListItem.Standard{
                    text: product_name
                    onClicked:{
                        console.log("newIngestion: " + product_name)
                        DataBase.saveNewIngestion(product_name,type,energy_kcal_100g,fat_100g,saturated_fat_100g,carbohydrates_100g,sugars_100g,fiber_100g,proteins_100g,salt_100g)
                        PopupUtils.open(ingestionStoredDialog)
                        root.initDB()
                        root.refreshListModel()
                    }
                    onPressAndHold:{
                        mainStack.push(foodsTemplate)
                        stackValues.stackProductName = product_name
                        stackValues.stackEnergyKcal = energy_kcal_100g
                        stackValues.stackFat = fat_100g
                        stackValues.stackSaturated = saturated_fat_100g
                        stackValues.stackCarborn = carbohydrates_100g
                        stackValues.stackSugars = sugars_100g
                        stackValues.stackFiber = fiber_100g
                        stackValues.stackProtein = proteins_100g
                        stackValues.stackSalt = salt_100g
                    }
                }
        } 
    }

    Component.onCompleted: queryCategory = 0
}