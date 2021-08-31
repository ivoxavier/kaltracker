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
    id: maintenancePage
    objectName: 'Maintenance Page'
    property int deleteType
    header: PageHeader {
        title: i18n.tr("Ingestions Storage")

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

    Component{
        id: entry_month_pop
        DeleteMonthDBPop{}
    }

    Column{
        anchors.top: maintenancePage.header.bottom
        width: maintenancePage.width

     ListItemHeader{
           title.text: i18n.tr("Automatic delete options")
       }

     ListItem {
            id: autoCleaner
            divider.visible: false
            ListItemLayout{
                title.text: i18n.tr("Auto delete records")
                subtitle.text: i18n.tr("Previous year")
                
                Switch{
                    id  : auto_clean_switch
                    checked: appSettings.isAutoCleanChecked
                    onClicked:  appSettings.isAutoCleanChecked = !appSettings.isAutoCleanChecked
                    
                }
            }
            
        }

        ListItemHeader{
           title.text: i18n.tr("Manual delete options")
       }

        ListItem {
            divider.visible : false
            id: month_option
            ListItemLayout{
                title.text: i18n.tr("Delete from specific Month & Year")
                
                ProgressionSlot{}
            }
            onClicked: {
                PopupUtils.open(entry_month_pop)
            }
        }




        ListItem {
            divider.visible : false
            id: deleteTodayRecords
            ListItemLayout{
                title.text: i18n.tr("Delete today's records")
                
                Button{
                    text: i18n.tr("Delete")
                    color: UbuntuColors.red
                    onClicked:{
                        deleteType = 0
                        PopupUtils.open(deleteDialog)
                    }
                }
            }
        }

        ListItem {
            divider.visible : false
            id: deleteAllRecords
            ListItemLayout{
                title.text: i18n.tr("Delete all records")
                
                Button{
                    text:i18n.tr("Delete")
                    color:UbuntuColors.red
                    onClicked:{
                        deleteType = 1
                        PopupUtils.open(deleteDialog)
                    }
            }

        }
    }
}

}
        