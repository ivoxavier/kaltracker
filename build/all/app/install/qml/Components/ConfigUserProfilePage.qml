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
import QtQuick.Controls 2.2 as QQC2
import "../js/DataBase.js" as DataBase



Page {
    id: configUserProfilePage
    objectName: 'ConfigUserProfilePage'
    header: PageHeader{
        title: i18n.tr("User Profile")
    }

    property string userName: "userName"
    property int kaloriesTarget
    property int userSex
    property int userAge
    property double userWeight
    property double userHeight
           
        Grid {
            anchors.fill: parent
            columns:1
            rows: 6
            spacing: units.gu(4)

            /* Grid anchors in the mainView.top, topPadding adjust with header height */
            topPadding: configUserProfilePage.header.height
            horizontalItemAlignment: Grid.AlignHCenter
            

            TextField {
                    id: userNameEntry
                    width: units.gu(18)
                    placeholderText: i18n.tr("Name (optional)")
                    horizontalAlignment: TextInput.AlignHCenter
                    focus: true
                }


            Row {

                spacing: units.gu(2)

                TextField {
                    id: userAge
                    width: units.gu(10)
                    placeholderText: i18n.tr("Age")
                    horizontalAlignment: TextInput.AlignHCenter
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator{}
                }
                    
                TextField {
                    id: weightEntry
                    width: units.gu(10)
                    placeholderText: i18n.tr("Weight")
                    horizontalAlignment: TextInput.AlignHCenter
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: DoubleValidator {}
                }

                TextField {
                    id: heightEntry
                    width: units.gu(10)
                    placeholderText: i18n.tr("Height")
                    horizontalAlignment: TextInput.AlignHCenter
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: DoubleValidator {}
                }
            }   


            OptionSelector {
                objectName: "optionselector_collapsed"
                text: i18n.tr("Sex")
                model: [i18n.tr("Men"),i18n.tr("Woman")]
                width: configUserProfilePage.width / 2
                selectedIndex: 0
                onSelectedIndexChanged: {
                    selectedIndex > 0 ? console.log("userSex: Woman") : console.log("userSex: Men")
                    userSex = selectedIndex
                }
            }

            Label {
                text: i18n.tr("Amount of kalories to ingest per day")
            }
    
            Picker {
                id: picker
                model: ListModel {}
                circular: false
                height: units.gu(9)
                width: configUserProfilePage.width / 2
                selectedIndex: 0
                delegate: PickerDelegate {

                Label {
                    text: modelData
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                Component.onCompleted: {
                    if (index === (picker.model.count - 1)){
                    picker.expandModel()
                    console.log(index)}
                }
                }
        
            function expandModel() {
                for (var i = 0; i < 50; i++) {
                picker.model.append({"blob": picker.model.count + " kal"});
            }
            }
            Component.onCompleted: {
                for (var i = 0; i < 100; i++)
                model.append({"blob": i + " kal"})
            }
            onSelectedIndexChanged: {
                kaloriesTarget = selectedIndex
                console.log(kaloriesTarget)
            }
            }
 
            Button {
                text: "Confirm"
                color: "green"
                width: configUserProfilePage.width
                onClicked: {
                    console.log(userNameEntry.text + " " + weightEntry.text)
                    mainStack.pop()
                    PopupUtils.open(createTablesDialog)
                    //mainStack.push(createTablesDialog)
                }
            }
        }  
}
