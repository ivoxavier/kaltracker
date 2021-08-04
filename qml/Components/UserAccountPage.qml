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
import Ubuntu.Components.ListItems 1.3 //as ListItem
import Ubuntu.Components.Popups 1.3
import QtQuick.Layouts 1.3
import Ubuntu.Components.Pickers 1.3
import QtQuick.LocalStorage 2.12
import io.thp.pyotherside 1.5
import Qt.labs.platform 1.0
import Ubuntu.Content 1.3
import "../js/DataBaseTools.js" as DataBase
import "../js/Imc.js" as CalcIMC
import "../js/KaloriesCalculator.js" as KalCalculator


Page{
    id: userAccountPage
    objectName: 'User Account Page'

    property bool isActivated: false
    property bool editMode: false
   
    property string userSex: "Men"
    // TextField Component should assign it onEditingFinsihed, not working.
    property int userAge: userAgeEntry.text
    property double userWeight: userWeightEntry.text
    property double userHeight: userHeightEntry.text
    property int userKaloriesDayTarget
    property string userActivityLevel: "Very Light"
    property int activityLevelToEquation: 0
    property int userGoal
    property int totalUserKaloriesDayTargetUserGoal: userKaloriesDayTarget + userGoal
    property string goalHeader : i18n.tr("No Goal")

    property double currentWeight: userSettings.userConfigsWeight

    Component{
        id: editDialog
        EditUserProfileDialog{}
    }


    header: PageHeader {
        title: i18n.tr("Account")
    



        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }

        ActionBar {

            StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
            }
            
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            
            numberOfSlots: 1
            actions: [
                Action{
                    iconName: "edit"
                    onTriggered: {
                        isActivated = !isActivated
                        editMode = !editMode
                  }
                }
            ]
        }
    }

    ScrollView{
        id: scrollView
        width: parent.width
        height : parent.height
        clip : true                 
 

        Column{  
            id: userDetailsColumn
            topPadding:  userAccountPage.header.height
            width: userAccountPage.width

            Row{
                Rectangle{
                    id: leftFrame
                    height: userAccountPage.header.height * 2
                    width: userAccountPage.width / 2
                    color: "transparent"

                    Column{
                        width: leftFrame.width

                        ListItem {
                            id: userSex_items
                            ListItemLayout{
                                title.text: userSettings.userConfigsUserName
                                subtitle.text: i18n.tr("IMC: ") + CalcIMC.getImc()

                            }
                        }
                    }
                }

                Rectangle{
                    id: rightFrame
                    height: userAccountPage.header.height * 2
                    width: userAccountPage.width / 2
                    color: "transparent"

                    Label{
                        id: userWeight_label
                        text: userSettings.userConfigsWeight + " KG"
                        
                        anchors.centerIn: parent
                        font.bold: true    
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("large")
                    }
                    Label{
                        id: userHeight_label
                        text: userSettings.userConfigsHeight + 'cm'
                        
                        anchors.top: userWeight_label.bottom
                        
                        anchors.horizontalCenter: parent.horizontalCenter
                        
  
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("medium")
                    }

                    Label{
                        id: userAge_label
                        text: i18n.tr("Age: ") + userSettings.userConfigsAge
                        
                        anchors.top: userHeight_label.bottom
                        
                        anchors.horizontalCenter: parent.horizontalCenter
                        
  
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("medium")
                    }
                    Label{
                        text: i18n.tr("Sex: ") + (userSettings.userConfigsSex === "Men" ? i18n.tr("M") : i18n.tr("W"))
                        
                        anchors.top: userAge_label.bottom
                        
                        anchors.horizontalCenter: parent.horizontalCenter
                        
  
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("medium")
                    }
                    
                }
            }


            
            ListItem{
                ListItemLayout{
                    title.text: i18n.tr("Activity Level")
                    subtitle.text: userSettings.userActivityLevel_text
                }
            }

            ListItem{
                ListItemLayout{
                    title.text: i18n.tr("Plan")
                    subtitle.text: userSettings.userConfigGoal_text
                }
            }

            Label{
                id: editLabelNotification
                text: i18n.tr("Edit Mode Enable")
                color: UbuntuColors.green
                visible: editMode
                textSize: Label.XSmall
            }

            Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: units.gu(2)
            topPadding: units.gu(2)

            TextField {
                id: userAgeEntry
                width: units.gu(10)
                placeholderText: i18n.tr("Age")
                horizontalAlignment: TextInput.AlignHCenter
                inputMethodHints: Qt.ImhDigitsOnly
                enabled: isActivated
                validator: IntValidator{}
            }
                    
            TextField {
                id: userWeightEntry
                width: units.gu(10)
                placeholderText: i18n.tr("Weight")
                horizontalAlignment: TextInput.AlignHCenter
                inputMethodHints: Qt.ImhDigitsOnly
                enabled: isActivated
                validator: IntValidator {}
            }

            TextField {
                id: userHeightEntry
                width: units.gu(10)
                placeholderText: i18n.tr("Height")
                horizontalAlignment: TextInput.AlignHCenter
                inputMethodHints: Qt.ImhDigitsOnly
                enabled: isActivated
                validator: IntValidator {}
            }
        }   



            Row{
                topPadding: units.gu(3)
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: units.gu(2)

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: i18n.tr("Activity Level")
                }

                Picker {
                    id: userActivityLevelEntry
                    anchors.verticalCenter: parent.verticalCenter
                    width: units.gu(10)
                    height: units.gu(5)
                    circular: false
                    enabled: isActivated
                    selectedIndex:0
                    model:
                        [
                        i18n.tr("Very Light"),
                        i18n.tr("Light"),
                        i18n.tr("Moderate"),
                        i18n.tr("Heavy")
                        ] 
                    delegate: PickerDelegate { 
                                Label {
                                    text: modelData
                                    y:units.gu(1)
                                    x:units.gu(1)
                                }
                    }
                    onSelectedIndexChanged: {
                        switch (selectedIndex) {
                            case 0:
                                console.log("Very Light")
                                activityLevelToEquation = userActivityLevelEntry.selectedIndex
                                userActivityLevel = "Very Light"
                                break;
                            case 1:
                                console.log("Light")
                                activityLevelToEquation = userActivityLevelEntry.selectedIndex
                                userActivityLevel = "Light"
                                break;
                            case 2:
                                console.log("Moderate")
                                activityLevelToEquation = userActivityLevelEntry.selectedIndex
                                userActivityLevel = "Moderate"
                                break;
                            case 3:
                                console.log("Heavy")
                                activityLevelToEquation = userActivityLevelEntry.selectedIndex
                                userActivityLevel = "Heavy"
                                break;
                                default:
                                console.log("Activity Level OptionSelector: out of index")
                                break;
                        }
                    }
                } 
            }

            Button{
                id: goalButton
                anchors.horizontalCenter: parent.horizontalCenter
                iconName: "unpinned"
                iconPosition: "right"
                text: i18n.tr("Goal")
                width: units.gu(10)
                enabled: isActivated
                color: root.defaultForegroundColor
                onClicked:{
                    PopupUtils.open(goalSelection,goalButton)
                }
            }

            Component {
                id: goalSelection

                ActionSelectionPopover{

                    actions: ActionList{
                        Action{
                            text: i18n.tr("Loose Weight")
                            onTriggered: {
                                userGoal = (-450)
                                goalHeader = "Loose Weight"
                            }
                        }
                        Action{
                            text: i18n.tr("Maintain Weight")
                            onTriggered: {
                                userGoal = 0
                                goalHeader = "Normal Weight"
                            }
                            }

                        Action{
                            text: i18n.tr("Gain Weight")
                            onTriggered: {
                                userGoal = 450
                                goalHeader = "Gain Weight"
                            }
                        }
                    }
                }
            }

            Row {
                topPadding: units.gu(6)
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: units.gu(2)

                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Normal:\n\n" +  userKaloriesDayTarget + " kcal"
                }
                Label{
                    id: calculationResult
                    anchors.verticalCenter: parent.verticalCenter
                    text: goalHeader + "\n\n" + (userKaloriesDayTarget + userGoal) + " kcal"

                }

                Button{
                    id: testButton
                    text: i18n.tr("Calculate")
                    enabled: isActivated
                    color: UbuntuColors.blue
                    onClicked: {
                        userKaloriesDayTarget = KalCalculator.mifflinStJeorEquation(userAge,userWeight,userHeight,userSex,activityLevelToEquation)
                        nextButton.enabled = true
                    }
                }
            }

            Button {
                id: nextButton
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Save modifications")
                color: "green"
                enabled: false
                onClicked: {
                        DataBase.updateWeight(userWeight)
                        DataBase.updateGoal( totalUserKaloriesDayTargetUserGoal)
                        DataBase.saveNewWeight(currentWeight,userWeight)
                        userSettings.userConfigsGoal = totalUserKaloriesDayTargetUserGoal
                        userSettings.userConfigsHeight = userHeight
                        userSettings.userConfigsWeight = userWeight
                        userSettings.userConfigsAge = userAge
                        userSettings.userConfigGoal_text = goalHeader
                        userSettings.userActivityLevel_text = userActivityLevel
                        editMode =!editMode
                }
            }
        }
    }
}