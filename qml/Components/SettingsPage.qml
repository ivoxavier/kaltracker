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
import Ubuntu.Components.ListItems 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12
import io.thp.pyotherside 1.5
import Qt.labs.platform 1.0
import Ubuntu.Content 1.3
import "../js/DataBaseTools.js" as DataBase
import "UiAddOns"


Page{
    id: settingsPage
    objectName: 'Settings Page'
    property int deleteType
    header: PageHeader {
        title: i18n.tr("Settings")

        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }
    }

    Component{
        id: optionListFoodsDialog
        ChooseListPopoverDialog{}
        
    }

    Component{
        id: deleteDialog
        RemoveRecordsDialog{
            msg: deleteType === 0 ? "today" : "all"
        }
    }

    Column{
        anchors.top: settingsPage.header.bottom
        width: settingsPage.width

       ListItemHeader{
           title.text: i18n.tr("Storage")
       }

       ListItem {

            divider.visible: false

            ListItemLayout{
                title.text: i18n.tr("Ingestions")
                
               ProgressionSlot{}
               
            }
            onClicked:{
                mainStack.push(maintenancePage)
            }
        }

        ListItem {

            divider.visible: false

            ListItemLayout{
                title.text: i18n.tr("User list foods & drinks")

                ProgressionSlot{}

             }
            onClicked: mainStack.push(createUserListPage)
        }

        ListItemHeader{
           title.text: i18n.tr("App settings")
       }

        ListItem {

            divider.visible: false

            ListItemLayout{
                title.text: i18n.tr("Alerts")

                ProgressionSlot{}

             }
            onClicked: mainStack.push(alertsPage)
        }

        ListItem {
            
            divider.visible: false

            ListItemLayout{
                title.text: i18n.tr("Set default behavior for list pick")

                ProgressionSlot{}

             }
            onClicked: {
                PopupUtils.open(optionListFoodsDialog)
            }
        }

        
}
}
        