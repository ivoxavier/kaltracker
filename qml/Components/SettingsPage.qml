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
        id: deleteDialog
        RemoveRecordsDialog{
            msg: deleteType === 0 ? "today" : "all"
        }
    }

    Column{
        anchors.top: settingsPage.header.bottom
        width: settingsPage.width

       ListItem {
            id: alertExceed
            ListItemLayout{
                title.text: i18n.tr("DataBase Maintenance")
                
               ProgressionSlot{}
               
            }
            onClicked:{
                mainStack.push(maintenancePage)
            }
        }

        ListItem {
            id: deleteTodayRecords
            ListItemLayout{
                title.text: i18n.tr("Application alerts")

                ProgressionSlot{}

             }
            onClicked: mainStack.push(alertsPage)
        }
}
}
        