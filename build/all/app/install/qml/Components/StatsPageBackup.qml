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
    id: statsPage
    objectName: 'Stats Page'

    property double fatStat
    property double saturatedStat
    property double carbornhydrates
    property double sugarsStat
    property double proteinStat
    property double fiberStat
    property double saltStat

    header: PageHeader {

        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }

        title: i18n.tr("Stats")
    }

    Connections{
        target: root
        onInitDB:{
            console.log("refreshing dashboard")
            DataBase.getAvareCaloriesMonth()
        }
    }


    ListModel {
        id: avgCaloriesMonth
        Component.onCompleted: DataBase.getAvareCaloriesMonth()
    }


    ScrollView{
        id: scrollView
        anchors{
            top: statsPage.header.bottom
            left: parent.left
            right: parent.right
            bottom: chartPie.top
        }

            ListView {
                model: avgCaloriesMonth
                header: Label{
                    text: i18n.tr("Average calories per month")
                    font.bold: true
                }
                delegate: ListItem.Subtitled{
                    text: month === '01' ? i18n.tr("January") : month === '02' ? i18n.tr("February") : month === '03' ? i18n.tr("March") : month === '04' ? i18n.tr("April") : month === '05' ? i18n.tr("May") : month === '06' ? i18n.tr("June") : month === '07' ? i18n.tr("July") : month === '08' ? i18n.tr("August") : month === '09' ? i18n.tr("September") : month === '10' ? i18n.tr("October") : month === '11' ? i18n.tr("November") : i18n.tr("December")
                    subText: average + " kcal"
                    showDivider: false
                
            }
        }
}
            ChartView {


                id: chartPie
                title: i18n.tr("Nutrients ingested during day")
                anchors.top: statsPage.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                legend.alignment: Qt.AlignRight
                antialiasing: true

                PieSeries {
                    id: pieSeries
                    PieSlice { label: "Fat"; value: fatStat }
                    PieSlice { label: "Saturated"; value: saturatedStat }
                    PieSlice { label: "C.hydrates"; value: carbornhydrates }
                    PieSlice { label: "Sugar"; value: sugarsStat }
                    PieSlice { label: "Protein"; value: proteinStat }
                    PieSlice { label: "Fiber"; value: fiberStat }
                    PieSlice { label: "Salt"; value: saltStat }
                }
}
  Component.onCompleted: DataBase.getNutrientsChartPie()  
}