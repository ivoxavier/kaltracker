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
import "./ActionBar"

Page{
    id: resumePage
    objectName: 'ResumePage'
    
    property int dashboardDailyIngestion : DataBase.getUserKaloriesIngestedDuringDay()
    property int dashboardUserMetric : DataBase.getUserKaloriesIngestionMetric()
    property string name
    property string ingestionDate
    property string ingestionTime
    property int kcal

    header: PageHeader {
        title: userSettings.userConfigsUserName + i18n.tr("'s Panel");
        trailingActionBar.actions: AboutAction{}

        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }

    }
    
    
    Component{
        id: aboutAppDiaLog
        AboutDialog{}
    }


    Connections{
        target: root
        onInitDB:{
            console.log("refreshing dashboard")
            forceUpdate()
        }
        onRefreshListModel:{
            console.log("cleaning dailyIngestion listModel")
            dailyIngestions.clear()
            DataBase.getUserDailyLogIngestionFoods()
        }
    }

    function forceUpdate(){
        var update_DailyIngestion = DataBase.getUserKaloriesIngestedDuringDay()
        var update_userMetric = DataBase.getUserKaloriesIngestionMetric()
        
        dashboardDailyIngestion = update_DailyIngestion
        dashboardUserMetric = update_userMetric
    }

    Rectangle{
        id: panel
        width: resumePage.width
        height: (((resumePage.header.height + resumePage.height) / 2) / 2) - resumePage.header.height
        anchors.top: resumePage.header.bottom
        color: root.defaultForegroundColor

        Label{
            id: topPanelLabel
            text: i18n.tr("Daily Ingestion")
            font.bold: true 
            
            anchors.horizontalCenter: parent.horizontalCenter
            
        }

        Column{
            anchors.top: topPanelLabel.bottom
            anchors.right: resumePage.width
            width: resumePage.width
            topPadding: units.gu(2)

            Row{
                spacing: units.gu(2)
                anchors.horizontalCenter: parent.horizontalCenter
                Label{
                    id: dashboardUserGoal
                    text: userSettings.userConfigsGoal + "\n" + i18n.tr("Goal");
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
                    font.bold: true
                    
                }
            }

            //ListItem.ThinDivider {}
        }
    }

    
    ListModel {
        id: dailyIngestions
        Component.onCompleted: DataBase.getUserDailyLogIngestionFoods()
    }
    
    Label{
        anchors.bottom: scrollView.top
        anchors.horizontalCenter: parent.horizontalCenter        
        text: i18n.tr("Today meals")
        font.bold: true
    }

    ScrollView{
        id: scrollView
        anchors{
            top: panel.bottom
            left: parent.left
            right: parent.right
            bottom: footer.top
        }

        
        ListView {
            id: foodsList
            model: dailyIngestions
            removeDisplaced: Transition {
                                NumberAnimation { 
                                    properties: "x,y"
                                    duration: 1000 
                                    }
                            }

            delegate: ListItem.Subtitled{
                    text: name

                    subText: (ingestionTime >= "00:00" && ingestionTime <= "10:59") ? 
                    i18n.tr("Breakfast") : (ingestionTime >= "11:00" && ingestionTime <= "15:59") ?
                    i18n.tr("Lunch") : (ingestionTime >= "16:00" && ingestionTime <= "19:59") ?
                    i18n.tr("Snack") : i18n.tr("Dinner")

                    showDivider: false
                    removable: true
                    confirmRemoval: true
                    backgroundIndicator: Rectangle{
                        anchors.fill: parent
                        color: "transparent"
                        MouseArea{
                            anchors.fill: parent
                            onClicked:{
                                 DataBase.deleteIngestion(idIngestion)
                                 root.initDB()
                                 root.refreshListModel()
                            }
                        }  
                    }
                    /*onTriggered:{
                        console.log("clicked")
                    }*/
                    
                }
        } 
    }

    Item {
    
        Component{
            id: popTest
            
            ActionSelectionPopover {
                
               /* style: StyledItem {
                             StyleHints {
                                foregroundColor: root.defaultForegroundColor
                                backgroundColor: root.defaultBackgroundColor
                            }
                    }*/
                    actions: ActionList {

                      /*  Action {
                            text: i18n.tr("Add Breakfast")
                            onTriggered: console.log("ahsdkjashd")
                        }
                        Action {
                            text: i18n.tr("Add Lunch")
                            onTriggered: console.log("ahsdkjashd")
                        }
                        Action {
                            text: i18n.tr("Add Snack")
                            onTriggered: console.log("ahsdkjashd")
                        }*/
                        Action {
                            text: i18n.tr("Schedule an ingestion")
                            onTriggered: mainStack.push(scheduleIngestionPage)
                        }
                        Action {
                            text: i18n.tr("New ingestion")
                            onTriggered: {
                                mainStack.push(newIngestionPage)
                            }
                        }
                    }
                }
        }
    }



    Rectangle{
        id: footer
        anchors.bottom: resumePage.bottom
        anchors.left: resumePage.left
        anchors.right: resumePage.right
        width: resumePage.width
        height: (resumePage.header.height) - units.gu(1)
        color: root.defaultForegroundColor
        
        Row{
            spacing: units.gu(2.5)
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Icon{
                name: "account"
                height: footer.height - units.gu(1)
                
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mainStack.push(userAccountPage)
                    }
                }
            }

            Icon{
                name: "settings"
                height: footer.height - units.gu(1)

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mainStack.push(settingsPage)
                    }
                }
            }

            Icon{
                id: addButton
                name: "add"
                height: footer.height - units.gu(1)

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        PopupUtils.open(popTest,addButton)
                        
                    }
                }
            }

             Icon{
                name: "view-list-symbolic"
                height: footer.height - units.gu(1)

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mainStack.push(statsPage)
                    }
                }
            }


            Icon{
                name: "save-to"
                height: footer.height - units.gu(1)

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mainStack.push(exportDataPage)
                    }
                }
            }
           
        }
    }

 Component.onDestruction:{
    console.log("byebye")  
 } 

}