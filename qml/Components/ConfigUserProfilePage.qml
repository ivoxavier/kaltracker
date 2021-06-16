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
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Qt.labs.settings 1.0
import QtQuick.LocalStorage 2.12
import "./ActionBar"
import "../js/DataBaseTools.js" as DataBase
import "../js/KaloriesCalculator.js" as KalCalculator
import "../js/ValidationTools.js" as ValidateInput


Page {
    id: configUserProfilePage
    objectName: 'ConfigUserProfilePage'
    header: PageHeader{
        title: i18n.tr("User Profile")
        ActionBar {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            numberOfSlots: 1
            actions:HelpUserConfigAction{}
        }
    }

    property string userName: userNameEntry.text
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
    
           
    Grid {
        anchors.fill: parent
        columns: 1
        rows: 7
        spacing: units.gu(4)

        /* Grid anchors in the mainView.top, topPadding adjust with header height */
        topPadding: configUserProfilePage.header.height
        horizontalItemAlignment: Grid.AlignHCenter
            
        Label {
            text: i18n.tr(" based on Mifflin-St Jeor equation")
        }
        
        TextField {
            id: userNameEntry
            width: units.gu(18)
            placeholderText: i18n.tr("Name")
            horizontalAlignment: TextInput.AlignHCenter
        }

        Row {

            spacing: units.gu(2)

            TextField {
                id: userAgeEntry
                width: units.gu(10)
                placeholderText: i18n.tr("Age")
                horizontalAlignment: TextInput.AlignHCenter
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator{}
             }
                    
            TextField {
                id: userWeightEntry
                width: units.gu(10)
                placeholderText: i18n.tr("Weight")
                horizontalAlignment: TextInput.AlignHCenter
                inputMethodHints: Qt.ImhDigitsOnly
                validator: DoubleValidator {}
            }

            TextField {
                id: userHeightEntry
                width: units.gu(10)
                placeholderText: i18n.tr("Height")
                horizontalAlignment: TextInput.AlignHCenter
                inputMethodHints: Qt.ImhDigitsOnly
                validator: DoubleValidator {}
            }
        }   


        OptionSelector {
            id: userSexEntry
            objectName: "optionselector_collapsed"
            text: i18n.tr("Sex")
            model: [i18n.tr("Men"),i18n.tr("Woman")]
            width: configUserProfilePage.width / 2
            selectedIndex: 0
            onSelectedIndexChanged: {
                selectedIndex > 0 ? userSex = "Woman" : userSex = "Men"
            }
        }

        Row{
            spacing: units.gu(2)

            Label {
                anchors.verticalCenter: parent.verticalCenter
                text: "Activity Level"
            }

            Picker {
                id: userActivityLevelEntry
                anchors.verticalCenter: parent.verticalCenter
                width: units.gu(10)
                height: units.gu(5)
                circular: false
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

            Button{
                anchors.verticalCenter: parent.verticalCenter
                iconName: "unpinned"
                iconPosition: "right"
                text: "Goal"
                width: units.gu(10)
                onClicked:{
                    PopupUtils.open(goalSelection)
                }
            }


        }

        Component {
       id: goalSelection

       ActionSelectionPopover{

           actions: ActionList{
               Action{
                   text: i18n.tr("Loose Weight")
                   onTriggered: {
                    console.log("Loose Weight")
                    userGoal = (-450)
                    goalHeader = "Loose Weight"
                   }
               }
               Action{
                   text: i18n.tr("Maintain Weight")
                   onTriggered: {
                    console.log("Maintain Weight")
                    userGoal = 0
                    goalHeader = "Normal Weight"
                   }
                }

               Action{
                   text: i18n.tr("Gain Weight")
                   onTriggered: {
                    console.log("Gain Weight")
                    userGoal = 450
                    goalHeader = "Gain Weight"
                   }
               }
           }
       }
   }


        Row {
            spacing: units.gu(2)

            Label{
                anchors.verticalCenter: parent.verticalCenter
                text: "Normal:\n\n" +  userKaloriesDayTarget + " kal"
            }
            Label{
                id: calculationResult
                anchors.verticalCenter: parent.verticalCenter
                text: goalHeader + "\n\n" + (userKaloriesDayTarget + userGoal) + " kal"

            }

            Button{
                id: testButton
                text: i18n.tr("Calculate")
                enabled: true
                onClicked: {
                    userKaloriesDayTarget = KalCalculator.mifflinStJeorEquation(userAge,userWeight,userHeight,userSex,activityLevelToEquation)
                    nextButton.enabled = true
                }
            }
        }
            
        Button {
            id: nextButton
            text: "Next"
            color: "green"
            width: configUserProfilePage.width
            enabled: false
            onClicked: {
                    appSettings.isCleanInstall = false
                    DataBase.createSQLContainer()
                    DataBase.dropTables()
                    DataBase.createTables()
                    DataBase.createUserProfile(userName,userAge,userSex,userWeight,userHeight,userActivityLevel,totalUserKaloriesDayTargetUserGoal)
                    userSettings.userConfigsGoal = totalUserKaloriesDayTargetUserGoal
                    userSettings.userConfigsUserName = userName
                    userSettings.userConfigsHeight = userHeight
                    userSettings.userConfigsWeight = userWeight
                    userSettings.userConfigsAge = userAge
                    userSettings.userConfigsSex = userSex
                    mainStack.pop()
                    PopupUtils.open(createTablesDialog)
                    
            }
        }
    } 

    Component.onCompleted: {
        PopupUtils.open(helpUserConfigDialog)
    }
}