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
import Ubuntu.Components.ListItems 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.LocalStorage 2.0
import QtQuick.XmlListModel 2.7
import "./ListModel"
import "../js/UserFoodsListDB.js" as UserFoodsListDataBase


    
Page {
    id: userFoodsListEditPages
    objectName: "userFoodsListEditPagess"


    header: PageHeader {
        id: header
        title: i18n.tr('Remove')

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

        
    ScrollView{
        
        anchors{
            top: userFoodsListEditPages.header.bottom
            right: userFoodsListEditPages.right
            left: userFoodsListEditPages.left
            bottom: userFoodsListEditPages.bottom 
        }
        
           

        ListView {
            id: foodsList

            
            model: UserFoodsDrinks{}
            clip: true
            removeDisplaced: Transition {
                                NumberAnimation { 
                                    properties: "x,y"
                                    duration: 1000 
                                }
                            }

            visible: model.count === 0 ? false : true
            

            
            delegate: ListItem{
                      
                        ListItemLayout{

                            title.text: product_name 
                        }
                     
                        leadingActions: ListItemActions {
                         
                            actions: [
                                Action {
                                    iconName: "delete"
                                    onTriggered:{
                                            UserFoodsListDataBase.deleteEntry(idFoods)
                                            foodsList.model.remove(index)
                                            UserFoodsListDataBase.getListFoods()
                                    }}]
                        }
                }
        } 
    }
}