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
import QtCharts 2.3
import "../js/DataBaseTools.js" as DataBase


Page{
    id: averageCaloriesPage
    objectName: 'Average Calories per Month Page'

    

    header: PageHeader {

        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }

        title: i18n.tr("Average Calories per Month")
    }

    Image{ 
            anchors.centerIn: parent           
            z: 100
            width: averageCaloriesPage.width - units.gu(23)
            height:  averageCaloriesPage.height - units.gu(66)
            source : '../img/emptyList.svg'
            visible: monthsList.visible === true ? false : true
        }

    Connections{
        target: root
        onInitDB:{
            console.log("Refreshing average calories month")
            DataBase.getAverageCaloriesMonth()
        }
    }

   ListModel {
        id: avgCaloriesMonth
        Component.onCompleted: DataBase.getAverageCaloriesMonth()
    }


    ScrollView{
        id: scrollView
        
        anchors.top: averageCaloriesPage.header.bottom
        anchors.bottom: averageCaloriesPage.bottom
        anchors.right: averageCaloriesPage.right
        anchors.left: averageCaloriesPage.left

            ListView {
                id: monthsList
                model: avgCaloriesMonth

                visible: model.count === 0 ? false : true

                delegate: ListItem.Subtitled{
                    
                    text: month === '01' ?
                    i18n.tr("January") : month === '02' ?
                    i18n.tr("February") : month === '03' ?
                    i18n.tr("March") : month === '04' ?
                    i18n.tr("April") : month === '05' ?
                    i18n.tr("May") : month === '06' ?
                    i18n.tr("June") : month === '07' ?
                    i18n.tr("July") : month === '08' ?
                    i18n.tr("August") : month === '09' ?
                    i18n.tr("September") : month === '10' ?
                    i18n.tr("October") : month === '11' ?
                    i18n.tr("November") : i18n.tr("December")
                    
                    subText: average + " kcal"
                    showDivider: false
                    progression: true
                    
                    onTriggered: {
                        root.stackMonthIngestions = month
                        mainStack.push(monthIngestionsPage)
                        }
            }
        }
    
    }
}