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
import Ubuntu.Components.Pickers 1.0
import Ubuntu.Components.ListItems 1.3 as ListItem
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.LocalStorage 2.0
import "../js/DataBase.js" as DataBase
import "../js/Quotes.js" as Quotes
//import "./Components"


    
Page {
    id: entryPage
    objectName: "SaveIngestion"
    header: PageHeader {
        id: header
        title: i18n.tr('KalTracker')
        ActionBar {
            anchors.right: parent.right
            numberOfSlots: 0
            actions: [
                Action{
                    id: aboutPop
                    iconName: "info"
                    text: i18n.tr("About")
                    onTriggered:PopupUtils.open(aboutDialog)
                },
                Action{
                    id: historicPage
                    iconName: "history"
                    text: i18n.tr("History")
                    onTriggered: pageStack.push(recordsView)
                },
                Action{
                    id: infoApp
                    iconName: "info"
                    text: i18n.tr("About")
                    onTriggered: PopupUtils.open(aboutDialog)
                },
                Action{
                    id: deletePage
                    iconName: "delete"
                    text: i18n.tr("Delete")
                    onTriggered: PopupUtils.open(dataBaseEraser)
                }
            ]
        }
            }  

    Column {
        id: mainPageColumn
        anchors.top: header.bottom
        anchors.left: mainPage.left
        anchors.right: mainPage.right
        spacing: units.gu(3)

        Label {
            id: dateLabel
            property var locale: Qt.locale()
            property date currentDate: new Date()
            property var stringDate: currentDate.toLocaleDateString(locale, 'dd MMMM yyyy')
            text: stringDate
            horizontalAlignment: Label.AlignHCenter
            Component.onCompleted: console.log(stringDate)
        }

                   
                        Dialer {
                            size: units.gu(20)
                            handSpace: units.gu(4)

                            DialerHand {
                                id: selector
                                hand.visible: false
                                value: 0
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: height
                                        height: units.gu(3)
                                        radius: width / 2
                                        color: theme.palette.normal.background
                                        antialiasing: true
                                        Label {
                                            text: Math.round(selector.value)
                                            anchors.centerIn: parent
                                        }
                                    }
                             }       

                        centerContent: [
                            Label {
                                id: handText
                                anchors.centerIn: parent
                            }
                        ]

                        onHandUpdated: handText.text = Math.round(hand.value);
                        }
    
                    /*Label {
                        id: quoteLabel
                        property string georgeousQuote: Quotes.randomQuote()
                        anchors.top: dateLabel.bottom
                        anchors.horizontalCenter: mainPage.horizontalCenter
                        font.bold: true
                        text:'\n' + georgeousQuote
                        Component.onCompleted: console.log(georgeousQuote)
                    }*/
             
                    Row {
                        id: rowComponents
                        //anchors.centerIn: mainPageColumn
                        spacing: 4

                        Picker {
                            id: foodPicker
                            width: units.gu(7)
                            height: units.gu(4)
                            circular: false
                            //moving: true
                            model: [i18n.tr('Food'), i18n.tr('Drink')] 
                            delegate: PickerDelegate { 
                                        Label {
                                            text: modelData
                                            y:units.gu(1)
                                            x:units.gu(1)
                                        }
                                    }
                            selectedIndex:0
                            onSelectedIndexChanged: {
                                if (selectedIndex == 1){
                                    console.log('Picker modified to: ' + selectedIndex)
                                }else {
                                    console.log('Picker modified to: ' + selectedIndex)
                                }
                            return selectedIndex
                            }
                        }   
                        TextArea {
                            id: messageArea 
                            property bool canPaste: true
                            height: units.gu(4)
                            width: units.gu(25)
                            placeholderText: i18n.tr("What type of food or drink?")
                            cursorVisible: false
                        TextEdit {
                            id: edit
                            horizontalAlignment: TextArea.AlignHCenter
                        }
                            ScrollView {
                                id: scrollArea
                                anchors.fill: parent
                            }
                        }
                        Button {
                            id: saveButton
                            color: UbuntuColors.orange
                            width: units.gu(7)
                            text: i18n.tr("Save")
                            onClicked: {
                                try{
                                    DataBase.insertIngestion(foodPicker.selectedIndex, messageArea.text);
                                    PopupUtils.open(ingestionStoredDialog);
                                } catch (err) {console.log('Error: ' + err)}       
                            }
                        }  
                    }
            }
        }
    

