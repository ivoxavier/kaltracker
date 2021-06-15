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
        ActionBar {
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
      
    Component{
        id: foodsTemplate
        FoodsTemplate{}
    }

   

    XmlListModel {
            id: xmlScheme
            source: "../xml/foods.xml"
            query: queryCategory === 0 ? "/foods/item/food" : "/foods/item/drink"
            XmlRole { name: "name"; query: "name/string()" }
            XmlRole { name: "kcal"; query: "kcal/string()" }
            XmlRole { name: "desc"; query: "desc/string()" }
            XmlRole { name: "type"; query: "desc/string()" }
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
            width: parent
            height: parent
            model: xmlScheme

            signal foodsDetailsSender (string nameToTemplate, string descToTemplate, int kcalToTemplate)

            delegate: ListItem.Standard{
                    text: name
                    onClicked:{
                        console.log("newIngestion: " + name)
                        DataBase.saveNewIngestion(name,type,kcal)
                        root.initDB()
                        root.refreshListModel()
                    }
                    onPressAndHold:{
                        PopupUtils.open(foodsTemplate)
                        foodsList.foodsDetailsSender(name,desc,kcal)
                    }
                }
        } 
    }

    Component.onCompleted: queryCategory = 0
}