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
import "../js/KaloriesCalculator.js" as KalCalculator
import "UiAddOns"

Page{
    id: userAccountPage
    objectName: 'User Account Page'

    property bool isActivated: false
    property bool editMode: false
   
    property string userSex: "Men"
    // TextField Component should assign it onEditingFinsihed, not working.
    property int newUserAge
    property double newUserWeight
    property double newUserHeight
    property int userKaloriesDayTarget
    property string userActivityLevel: "Very Light"
    property int activityLevelToEquation: 0
    property int userGoal
    property int totalUserKaloriesDayTargetUserGoal: userKaloriesDayTarget + userGoal
    property string goalHeader : i18n.tr("No Goal")

    property double currentWeight: root.userWeight

    Component{
        id:updatingDialog
        UpdateUserDetailsDialog{}
    }

    header: PageHeader {
        title: i18n.tr("User Account")
    



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

                        ListItemHeader{
                             title.text: i18n.tr("Profile details")
                        }
                        ListItem {
                            id: userSex_items
                            divider.visible: false
                            ListItemLayout{
                                title.text: root.userName
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
                        text: root.userWeight + " KG"
                        
                        anchors.centerIn: parent
                        font.bold: true    
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("large")
                    }
                    Label{
                        id: userHeight_label
                        text:  root.userHeight + 'cm'
                        
                        anchors.top: userWeight_label.bottom
                        
                        anchors.horizontalCenter: parent.horizontalCenter
                        
  
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("medium")
                    }

                    Label{
                        id: userAge_label
                        text: i18n.tr("Age: ") + root.userAge

                        
                        anchors.top: userHeight_label.bottom
                        
                        anchors.horizontalCenter: parent.horizontalCenter
                        
  
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("medium")
                    }
                    Label{
                        text: i18n.tr("Sex: ") + (root.userSex === "Men" ? i18n.tr("M") : i18n.tr("W"))
                        
                        anchors.top: userAge_label.bottom
                        
                        anchors.horizontalCenter: parent.horizontalCenter
                        
  
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("medium")
                    }
                    
                }
            }


            
            ListItem{

                divider.visible: false

                ListItemLayout{
                    title.text: i18n.tr("Activity Level")
                    subtitle.text: root.userActivityLevel

                }
            }

            ListItem{

                divider.visible: false

                ListItemLayout{
                    title.text: i18n.tr("Plan")
                    subtitle.text: root.userGoalCategory
                }
            }

            ListItemHeader{
                id: editLabelNotification
                title.text: i18n.tr("Enter new values")
                visible: editMode
            }

            ListItem{
               divider.visible: false
               visible: editMode
                ListItemLayout{
                    title.text: i18n.tr("Age")
                     height: childrenRect.height
                    Slider{
                            id: ageSlide
                            objectName: "slider_live"
                            width: parent.width / 2
                            height: units.gu(12)
                            value: 0
                            minimumValue: 0
                            maximumValue: 100
                            live: true
                            onValueChanged: {
                            newUserAge = (Math.round(ageSlide.value))
                            ageSlideValue.text = newUserAge }
                        }

                    Label{id: ageSlideValue; text: "0"} 
                }
            }

            

            ListItem{
               divider.visible: false
               visible: editMode
                ListItemLayout{
                    title.text: i18n.tr("Weight")
                     height: childrenRect.height
                    Slider{
                            id: weightSlide
                            objectName: "slider_live"
                            width: parent.width / 2
                            height: units.gu(12)
                            value: 0
                            minimumValue: 0
                            maximumValue: 200
                            live: true
                            onValueChanged: {
                            newUserWeight = (Math.round(weightSlide.value))
                            weightSlideValue.text = newUserWeight + " KG" }
                        }
                    Label{id: weightSlideValue; text: "0" + " KG"} 
                }
            }

            ListItem{
               divider.visible: false
               visible: editMode
                ListItemLayout{
                    title.text: i18n.tr("Height")
                     height: childrenRect.height
                    Slider{
                            id: heightSlide
                            objectName: "slider_live"
                            width: parent.width / 2
                            height: units.gu(12)
                            value: 100
                            minimumValue: 100
                            maximumValue: 200
                            live: true
                            onValueChanged: {
                            newUserHeight = (Math.round(heightSlide.value))
                            heightSlideValue.text = newUserHeight + " cm"}
                        } 

                    Label{id: heightSlideValue; text: "0" + " cm"} 
                }
            }

            ListItemHeader{
                title.text: i18n.tr("Target")
                visible: editMode
            }

            ListItem{
               divider.visible: false
               visible: editMode
                ListItemLayout{
                    title.text: i18n.tr("Activity Level")
                     height: childrenRect.height 
                     Picker {
                        id: userActivityLevelEntry
                        anchors.verticalCenter: parent.verticalCenter
                        width: units.gu(10)
                        height: units.gu(6)
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
            }

            ListItem{
               divider.visible: false
               visible: editMode
                ListItemLayout{
                    title.text: i18n.tr("Plan")
                     height: childrenRect.height + units.gu(3)
                     Button{
                        id: goalButton
                        
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
                    
                }
            }
            
            ListItemHeader{
                title.text: i18n.tr("Total amount of calories")
                visible: editMode
            }


            ListItem{
               divider.visible: false
               visible: editMode
                ListItemLayout{
                    title.text: i18n.tr("Normal")
                    subtitle.text: userKaloriesDayTarget + " kcal"
                }
            }

            ListItem{
               divider.visible: false
               visible: editMode
                ListItemLayout{
                    title.text: goalHeader
                    subtitle.text: (userKaloriesDayTarget + userGoal) + " kcal"
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

                Button{
                    id: testButton
                    text: i18n.tr("Calculate")
                    enabled: isActivated
                    visible: editMode
                    color: UbuntuColors.blue
                    onClicked: {
                        userKaloriesDayTarget = KalCalculator.mifflinStJeorEquation(newUserAge,
                        newUserWeight,
                        newUserHeight,
                        userSex,
                        activityLevelToEquation)
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
                visible: editMode
                onClicked: {
                        DataBase.updateWeight(newUserWeight)
                        DataBase.updateAge(newUserAge)
                        DataBase.updateGoal(totalUserKaloriesDayTargetUserGoal)
                        DataBase.updateGoalCategory(goalHeader)
                        DataBase.updateHeight(newUserHeight)
                        DataBase.saveNewWeight(currentWeight,newUserWeight)
                        editMode =!editMode
                        isActivated = !isActivated
                        PopupUtils.open(updatingDialog)
                }
            }
        }
    }
}