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
import Ubuntu.Components.ListItems 1.3 as ListItem
import Ubuntu.Components.Popups 1.3
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12
import io.thp.pyotherside 1.5
import Qt.labs.platform 1.0
import Ubuntu.Content 1.3
import "../js/DataBaseTools.js" as DataBase


Page{
    id: statsPage
    objectName: 'Stats Page'

    property string type
    property int total

    header: PageHeader {
        title: i18n.tr("Stats")
    }

    ListModel {
        id: foodsCategory
        Component.onCompleted: DataBase.getFoodsType()
    }

    Label{
        id: topPanelLabel
        text: i18n.tr(" Total foods ingested by type")
        font.bold: true 

        anchors.top: statsPage.header.bottom
        anchors.horizontalCenter: statsPage.horizontalCenter   
    }

        GridView {
            width: statsPage.width
            anchors.horizontalCenter: statsPage.horizontalCenter 
            anchors.top: topPanelLabel.bottom
            cellWidth: units.gu(10)
            model: foodsCategory
    
            delegate: Column{ 
                anchors.right: statsPage.width
                topPadding: units.gu(2)
                spacing: units.gu(2)

                Row{
                     anchors.horizontalCenter: parent.horizontalCenter
                    Label { text: type + '\n' + total}
                }
            }      
        }    
}


        