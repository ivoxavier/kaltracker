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
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.0
import "../js/DataBase.js" as DataBase


Page {
    id: initDataWarehousePage
    objectName: 'InitDataWarehousePage'    
    header: PageHeader {
        title: i18n.tr("KalTracker")
    }

    Grid {

        anchors.fill: parent
        columns:1
        rows: 6
        topPadding: initDataWarehousePage.header.height
        horizontalItemAlignment: Grid.AlignHCenter

        Text{
            text:i18n.tr("\n\nThank's for installing KalTracker.")
        }

        Text{
            text:i18n.tr("\nIt was devolped on my spare time.")
        }

        Text{
            text:i18n.tr("\nI hope it will be usefull for you.")
        }

        Text{
            text:i18n.tr("\nClick in the following button to set your goals.")
        }

        Text{
            text:i18n.tr("\nAll the data generated is yours to keep.\n\n")
        }

        Button{
            id: createTablesButton
            width: initDataWarehousePage.width
            color:"green"
            text: i18n.tr("Click to Config")
            onClicked:{
                //appSettings.isCleanInstall = false
                console.log("isCleanInstall = false")
                mainStack.pop()
                mainStack.push(configUserProfilePage)
            }
        }
    }
}