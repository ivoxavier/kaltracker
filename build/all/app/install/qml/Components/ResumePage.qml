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
import "../js/DataBaseTools.js" as DataBase
import "./ActionBar"



Page{
    id: resumePage
    objectName: 'ResumePage'
    
    
    
    property string name
    property string ingestionDate
    property string ingestionTime
    property int kcal
    
    property int id_ingestion_update_time
    property int dashboardUserMetric : DataBase.getUserKaloriesIngestionMetric()


    header: PageHeader {

        title: i18n.tr("%1's Panel").arg(root.userName);

        trailingActionBar.actions: AboutAction{}

        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }

    }
    
    Component{
        id: updateTimePop
        UpdateIngestionTimePop{}
    }

    Component{
        id: aboutAppDiaLog
        AboutDialog{}
    }

        UbuntuShape{
            anchors.centerIn: parent 
            radius: "large"
            aspect: UbuntuShape.Inset
            width: (resumePage.width / 3.33)
            height:  (resumePage.header.height * 2)
            visible: foodsList.visible === true ? false : true
            z:100
            Icon{ 
                id: pacMan                         
                anchors.fill: parent

                name: "non-starred"
                visible: foodsList.visible === true ? false : true
            }

        }


    Connections{
        target: root
        onInitDB:{
            console.log("refreshing dashboard")
            updateDash()
        }
        onRefreshListModel: {
            console.log("cleaning dailyIngestion listModel")
            dailyIngestions.clear()
            DataBase.getUserDailyLogIngestionFoods()
        }
    }

    function updateDash(){
        root.dashboardDailyIngestion = Math.round(DataBase.getUserKaloriesIngestedDuringDay())
        root.dashboardUserMetric = DataBase.getUserKaloriesIngestionMetric()
    }

    Rectangle{
        id: panel
        width: resumePage.width
        height: (((resumePage.header.height + resumePage.height) / 2) / 2) - resumePage.header.height
        anchors.top: resumePage.header.bottom
        color: root.defaultForegroundColor

        Label{
            id: topPanelLabel
            text: i18n.tr("Daily Calories")
            font.bold: true 
            fontSizeMode:Text.Fit 
            font.pixelSize: units.gu(2)
            anchors.horizontalCenter: parent.horizontalCenter
            
        }

        Column{
            anchors.top: topPanelLabel.bottom
            width: resumePage.width
            topPadding: units.gu(2)

            Row{
                spacing: units.gu(2)
                anchors.horizontalCenter: parent.horizontalCenter
                Label{
                    id: dashboardUserGoal
                    text: root.userGoal
                    fontSizeMode: Text.Fit 
                    font.pixelSize: FontUtils.sizeToPixels("large")
                }

                Label{
                    text: "-"
                    fontSizeMode: Text.Fit 
                    font.pixelSize: FontUtils.sizeToPixels("large")
                }

                Label{
                    id: dashboardUserKaloriesIngestedDuringDay
                    text: root.dashboardDailyIngestion
                    fontSizeMode: Text.Fit 
                    font.pixelSize: FontUtils.sizeToPixels("large")
                }

                Label{
                    text: "="
                    fontSizeMode: Text.Fit 
                    font.pixelSize: FontUtils.sizeToPixels("large")
                }

                Label{
                    id: dashboardUserKaloriesIngestionMetric
                    text: root.dashboardUserMetric
                    color: root.metric > 0 ?
                    UbuntuColors.green : root.metric < 0 ?
                    UbuntuColors.red : UbuntuColors.green
                    font.bold: true
                    fontSizeMode: Text.Fit 
                    font.pixelSize: FontUtils.sizeToPixels("large")
                }
            }
            
            Row{
                spacing: units.gu(4.5)
                anchors.horizontalCenter: parent.horizontalCenter

                Label{
                    text: i18n.tr("Goal")
                    fontSizeMode: Text.Fit 
                    font.pixelSize: FontUtils.sizeToPixels("medium")
                }

                Label{
                    text: i18n.tr("Foods")
                    fontSizeMode: Text.Fit 
                    font.pixelSize: FontUtils.sizeToPixels("medium")
                }

                Label{
                    text: root.metric > 0 ?
                    i18n.tr("Remaining") : root.metric < 0 ?
                    i18n.tr("Exceed") : i18n.tr("To ingest")
                    fontSizeMode: Text.Fit 
                    font.pixelSize: FontUtils.sizeToPixels("medium")
                }

            }


        }
    }

    
    ListModel {
        id: dailyIngestions
        Component.onCompleted: DataBase.getUserDailyLogIngestionFoods()
    }
    
    Label{
        anchors.bottom: scrollView.top
        anchors.horizontalCenter: parent.horizontalCenter        
        text: foodsList.model.count === 0 ? ' ' : i18n.tr("Today meals")
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
            clip: true
            removeDisplaced: Transition {
                                NumberAnimation { 
                                    properties: "x,y"
                                    duration: 1000 
                                }
                            }

            visible: model.count === 0 ? false : true
            

            
            delegate: ListItem{
                      
                        ListItemLayout{

                            title.text: name
                            subtitle.text: (ingestionTime >= "00:00" && ingestionTime <= "10:59") ? 
                            i18n.tr("Breakfast") : (ingestionTime >= "11:00" && ingestionTime <= "15:59") ?
                            i18n.tr("Lunch") : (ingestionTime >= "16:00" && ingestionTime <= "19:59") ?
                            i18n.tr("Snack") : i18n.tr("Dinner")
            
                            
                        }
                     
                        leadingActions: ListItemActions {
                         
                            actions: [
                                Action {
                                    iconName: "delete"
                                    onTriggered:{
                                        DataBase.deleteIngestion(idIngestion)
                                        root.initDB()
                                        root.refreshListModel()
                                    }
                                }]
                        }

                        trailingActions: ListItemActions{
                            actions: [
                                Action{
                                    iconName: "edit"
                                    onTriggered:{
                                        root.id_ingestion_update_time = idIngestion
                                        PopupUtils.open(updateTimePop)
                                    }
                                }
                            ]
                        }  
                }
        } 
        
    }
    
    Item {
    
        Component{
            id: popOverList
            ActionSelectionPopover {
                
                    actions: ActionList {
                        
                        Action {
                            text: i18n.tr("Your foods list")
                            enabled: appSettings.isUserListCreated
                            onTriggered: mainStack.push(userListIngestionPage)
                        }
                        
                        Action {
                            text: i18n.tr("OpenFoodsFacts List")
                            onTriggered: {
                                mainStack.push(openFoodsFactsListPage)
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

                        if(appSettings.isOpenFactsFoodsListChecked){
                            mainStack.push(openFoodsFactsListPage)
                        } else if (appSettings.isUserListFoodsChecked){
                            mainStack.push(userListIngestionPage)
                        } else{
                            PopupUtils.open(popOverList,addButton)
                        }
                       
                        
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
    console.log("App Closed")  
 } 


}