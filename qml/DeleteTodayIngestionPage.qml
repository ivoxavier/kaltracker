/*
 * 2022  Ivo Xavier
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
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import "components"
import "style"
import "../js/IngestionsTable.js" as IngestionsTable
import "../js/GetData.js" as GetData




Page{
    id: list_foods_ingested_month_page
    objectName: 'ListFoodsIngestedMonthPage'
    header: PageHeader {
               // visible: app_settings.is_page_headers_enabled ? true : false
                title : i18n.tr("Select Ingestion To Delete")
        }

    property string requested_month

    Item{
        visible: all_today_ingestions_list.visible ? false : true
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

    ListModel{
        id: all_today_ingestions
        Component.onCompleted: GetData.getTodayIngestions()
    }

    ListView{
        id: all_today_ingestions_list
        anchors{
            top: parent.header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        model: all_today_ingestions
        clip: true
        visible : model.count === 0 ? false : true
        delegate: ListItem{
            ListItemLayout{title.text : name;subtitle.text: cal}
            leadingActions: ListItemActions{
                actions:[
                    Action{
                        iconName: "delete"
                        onTriggered:{
                            IngestionsTable.deleteSpecificTodayIngestion(id)
                            all_today_ingestions_list.model.remove(index)
                            root.initDB()
                        }
                    }
                ]
            }    
        }
    }
   
}