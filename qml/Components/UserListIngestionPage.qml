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
    id: userListIngestionPage
    objectName: "userListIngestionPage"

    property int queryCategory



    signal new_ingestion_details(string product_name,
    string nutriscore_grade,
    string type,
    double energy_kcal_100g,
    double fat_100g,
    double saturated_fat_100g,
    double carbohydrates_100g,
    double sugars_100g,
    double proteins_100g)

    header: PageHeader {
        id: header
        title: i18n.tr("%1's list").arg(root.userName)

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
                id: msgEmptyList
                anchors.centerIn: parent
                text: i18n.tr("Create your list under app settings")
                visible: foodsList.visible === true ? false : true
                enabled: msgEmptyList.visible
                font.bold: true
                fontSizeMode: Text.Fit 
                font.pixelSize: FontUtils.sizeToPixels("medium")
            }

        

    Label{
        id: categoryLabel
        anchors.top: userListIngestionPage.header.bottom
        font.bold: true
        visible: msgEmptyList.visible
        text: queryCategory !=0 ? i18n.tr("Drink") : i18n.tr("Food")
    }
    ScrollView{
        
        anchors{
            top: categoryLabel.bottom
            right: userListIngestionPage.right
            left: userListIngestionPage.left
            bottom: userListIngestionPage.bottom 
        }
        
           

        ListView {
            id: foodsList
            model: UserFoodsDrinks{}

            visible: model.count === 0 ? false : true
     
            delegate: ListItem.Standard{
                    text: product_name
                    onClicked:{
                        mainStack.push(foodsTemplate)
                        root.stackProductName = product_name
                        root.nutriscore_grade = score_grade
                        root.stackType = type
                        root.stackEnergyKcal = kcal
                        root.stackFat = fat
                        root.stackSaturated = saturated
                        root.stackCarborn = carbo
                        root.stackSugars = sugars
                        root.stackProtein = proteins
                    }
                }
        } 
    }

    Component.onCompleted: {
    queryCategory = 0
    
    }
}