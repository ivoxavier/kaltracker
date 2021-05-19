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
import QtQuick 2.12 as QTQ2
import "../js/DataBaseTools.js" as DataBase
import "./ActionBar"

Rectangle{
        id: panel
        width: resumePage.width
        height: (((resumePage.header.height + resumePage.height) / 2) / 2) - resumePage.header.height
        anchors.top: resumePage.header.bottom

        Label{
            id: topPanelLabel
            text: " Daily Ingestion"
            font.bold: true 
            anchors{
                top: parent.top
                left: parent.left
            }
        }

        Column{
            anchors.top: topPanelLabel.bottom
            topPadding: units.gu(2)
            leftPadding: (resumePage.width / 2) / 2

            Row{
                spacing: units.gu(2)
                
                Label{
                    id: dashboardUserGoal
                    Component.onCompleted: DataBase.getUserGoal() 
                }

                Label{
                    text: "-"
                }

                Label{
                    id: dashboardUserKaloriesIngestedDuringDay
                    Component.onCompleted: DataBase.getUserKaloriesIngestedDuringDay()
                }

                Label{
                    text: "="
                }

                Label{
                    id: dashboardUserKaloriesIngestionMetric
                    Component.onCompleted: DataBase.getUserKaloriesIngestionMetric()
                }

            }
        }
    }
