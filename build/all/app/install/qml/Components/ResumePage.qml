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

import "../js/DataBaseTools.js" as DataBase
import "../js/UpdateDB.js" as UpdateDB
import "./ActionBar"

Page{
    id: resumePage
    objectName: 'ResumePage'
    
    property string dashboardDailyIngestion : DataBase.getUserKaloriesIngestedDuringDay()
    property string dashboardUserGoal : DataBase.getUserGoal()
    property string dashboardUserMetric : DataBase.getUserKaloriesIngestionMetric()
    

    header: PageHeader {
        title: DataBase.getUserName()
        trailingActionBar.actions: [
            Action{
                id: iconTest
                iconName: "help"
                onTriggered: {
    
                }
            }
        ]
        //AboutAction{}
    }

    Connections{
        target: root
        onInitDB:{
            console.log("initDB signal was catched")
            forceUpdate()
        }
    }

    function forceUpdate(){
        var update_DailyIngestion = DataBase.getUserKaloriesIngestedDuringDay()
        var update_logBook = DataBase.getUserDailyLogIngestionFoods()
        var update_userMetric = DataBase.getUserKaloriesIngestionMetric()
        dashboardDailyIngestion = update_DailyIngestion
        userDailyLogBook.text = update_logBook
        dashboardUserMetric = update_userMetric
    }

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
                    text: dashboardUserGoal
                }

                Label{
                    text: "-"
                }

                Label{
                    id: dashboardUserKaloriesIngestedDuringDay
                    text: dashboardDailyIngestion
                }

                Label{
                    text: "="
                }

                Label{
                    id: dashboardUserKaloriesIngestionMetric
                    text: dashboardUserMetric
                }

            }
        }
    }



    ScrollView{
        id: scrollView
        anchors{
            top: panel.bottom
            left: parent.left
            right: parent.right
            bottom: footer.top
        }
        
        Column{
            spacing : units.gu(2)
            topPadding: units.gu(2)

            TextEdit {
                id: userDailyLogBook
                text: DataBase.getUserDailyLogIngestionFoods()
                wrapMode: TextEdit.Wrap
                width: scrollView.width
                readOnly: true
                textFormat: TextEdit.PlainText
                color: theme.palette.normal.fieldText
                leftPadding: units.gu(1)
            } 
        }
    }

    Rectangle{
        id: footer
        anchors.bottom: resumePage.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: (resumePage.width / 2) / 2 - units.gu(6)
        height: (resumePage.header.height) - units.gu(1)
        radius: width / 2
        

        Icon{
            anchors.centerIn: parent
            name: "add"
            height: footer.height
            color: UbuntuColors.orange
            
        }
        
        MouseArea{
            anchors.fill: footer
            onClicked: {
                //mainStack.pop()
                mainStack.push(newIngestionPage)
            }
        }
    }

Component.onDestruction:{
    console.log("byebye")  
}
}