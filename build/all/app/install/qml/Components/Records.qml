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
import QtQuick.LocalStorage 2.0
import "../js/DataBaseTools.js" as DataBase


Page {
    id: recordsPage    
    header: PageHeader {
        title: i18n.tr("History")
        leadingActionBar.actions: Action {
            text: i18n.tr("Back")
            iconName: "back"
            onTriggered: pageStack.pop()
        }
        sections {
            model: {[i18n.tr("Logs"), i18n.tr("Stats")]} //logs - index 0 // Stats - index 1
            selectedIndex: 0
            onSelectedIndexChanged: {
                if(sections.selectedIndex === 1){
                    recordsPageColumn.visible = false;
                    statsPageColumn.visible = true;
                 
                } else {
                    recordsPageColumn.visible = true;
                    statsPageColumn.visible = false;
                }
            }
        }  
    }

    Column{
        id: recordsPageColumn
        anchors {
            top: header.bottom
            left: recordsPage.left
            right: recordsPage.right
            bottom: recordsPage.bottom
        }
            ScrollView {
                id: scrollView
                anchors {
                    top: recordsPageColumn.top
                    topMargin: units.gu(1)
                    left: recordsPageColumn.left
                    right: recordsPageColumn.right
                    bottom: recordsPageColumn.bottom
                }

                //flickableItem.onMovementStarted: {}

            TextEdit {
                id: historyText
                text: DataBase.getAllIngestions()
                wrapMode: TextEdit.Wrap
                width: scrollView.width
                readOnly: true
                font.family: "Ubuntu Mono"
                textFormat: TextEdit.PlainText
                color: theme.palette.normal.fieldText
                Component.onCompleted: {
                HelloWorld.sayHello()
                Sucesso.sayHello()
                }
            }        
        }
    }

    Column{
        id: statsPageColumn
        anchors {
            top: header.bottom
            left: recordsPage.left
            right: recordsPage.right
            bottom: recordsPage.bottom
        }
        visible: false;
        Label{
         text: "Coming Soon..."   
        }
    }
}