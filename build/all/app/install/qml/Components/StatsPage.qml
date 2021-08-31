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
import QtCharts 2.3
import "../js/DataBaseTools.js" as DataBase
import "UiAddOns"

Page{
    id: statsPage
    objectName: 'Stats Page'

   

    header: PageHeader {

        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }

        title: i18n.tr("Stats")
    }

    Column{
        anchors.top: statsPage.header.bottom
        width: statsPage.width

        ListItemHeader{
           title.text: i18n.tr("Ingestions analysis")
       }

        ListItem {

            divider.visible: false

            ListItemLayout{
                title.text: i18n.tr("Average Calories per Month")
                
                ProgressionSlot{}
            }

        onClicked: mainStack.push(averageCaloriesMonth)
        }

        ListItemHeader{
           title.text: i18n.tr("User profile analysis")
       }

        ListItem {

            divider.visible: false
        
            ListItemLayout{
                title.text: i18n.tr("Consume Habits")
                
                ProgressionSlot{}
            }

        onClicked: mainStack.push(consumeHabitsPage)
        }


        ListItem {
            divider.visible: false
            ListItemLayout{
                title.text: i18n.tr("Indexes")
                
                ProgressionSlot{}
            }

        onClicked: mainStack.push(indexesCalcPage)
        }

        

    }
    
}