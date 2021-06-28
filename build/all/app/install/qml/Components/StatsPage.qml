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


    property int num1: 2
    property int num2: 2
    header: PageHeader {

        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }

        title: i18n.tr("Stats")
    }

    Rectangle{
        id: panel
        width: statsPage.width
        height: (((statsPage.header.height + statsPage.height) / 2) / 2) - statsPage.header.height
        anchors.top: statsPage.header.bottom

        Label{
            id: topPanelLabel
            text: i18n.tr("Dietary")
            font.bold: true 
            
            anchors.horizontalCenter: parent.horizontalCenter
            
        }

        Column{
            anchors.top: topPanelLabel.bottom
            anchors.right: statsPage.width
            width: statsPage.width
            topPadding: units.gu(2)
            spacing: units.gu(1)

            Row{
                spacing: units.gu(1.5)
                anchors.horizontalCenter: parent.horizontalCenter
                
                Label{
                    id: fatStat
                }

                Label{
                    id: saltStat
                }

                Label{
                    id:sugarsStat
                }
            }

            Row{
                spacing: units.gu(1.5)
                anchors.horizontalCenter: parent.horizontalCenter
                    
                Label{
                    id: proteinStat
                }

                Label{
                    id: carbornhydrates
                }

                Label{
                    id: saturatedStat
                }

                Label{
                    id: fiberStat
                }
            }

            ListItem.ThinDivider {}
        }
    }
   
ChartView {
    id: chart
    title: "Top-5 car brand shares in Finland"
     anchors.top: panel.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    legend.alignment: Qt.AlignBottom
    antialiasing: true

    PieSeries {
        id: pieSeries
        PieSlice { label: "Volkswagen"; value: 13.5 }
        PieSlice { label: "Toyota"; value: 10.9 }
        PieSlice { label: "Ford"; value: 8.6 }
        PieSlice { label: "Skoda"; value: 8.2 }
        PieSlice { label: "Volvo"; value: 6.8 }
    }
}


Component.onCompleted: DataBase.getDietary()        
}


        