/*
 * 2022-2023  Ivo Xavier
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
import Lomiri.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtCharts 2.3
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import "../components"
import "../style"
import "../../js/UserFoodsListTable.js" as UserFoodsListTable




Page{
    id: manage_user_foods_list_page
    objectName: 'ManageUserFoodsListPage'
    header: PageHeader {
                //visible: app_settings.is_page_headers_enabled ? true : false
                title : i18n.tr("Manage Your Foods")

                StyleHints {
                   /* foregroundColor: "white"
                    backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
            }
        }
    
    BackgroundStyle{}
    
   Item{
        visible: user_foods_list.visible ? false : true
        anchors.centerIn: parent
        height: parent.height / 2
        width: parent.width / 2

        Icon {
            id: empty_icon
            anchors.fill: parent
            name: "empty-symbolic"
            opacity: 0.75
        }

        Label{
            anchors.top: empty_icon.bottom
            anchors.horizontalCenter: empty_icon.horizontalCenter
            text: i18n.tr("Empty List, Please Register Ingestions First..")
            opacity: 0.75
        }
    }  

    ListView{
        id: user_foods_list
        anchors{
            top: parent.header.bottom 
            bottom: parent.bottom 
            left: parent.left
            right: parent.right
        }
        model: UserFoodsList{}
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
                title.font.bold : true
                subtitle.text : cal

            }
            leadingActions: ListItemActions{
                actions:[
                    Action{
                        iconName: "delete"
                        onTriggered:{
                            UserFoodsListTable.deleteFoods(id)
                            user_foods_list.model.remove(index)
                        }
                    }
                ]
            }
        }
    }
}