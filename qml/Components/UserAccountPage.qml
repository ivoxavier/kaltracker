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
import QtQuick.LocalStorage 2.12
import io.thp.pyotherside 1.5
import Qt.labs.platform 1.0
import Ubuntu.Content 1.3
import "../js/DataBaseTools.js" as DataBase


Page{
    id: userAccountPage
    objectName: 'User Account Page'


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
                    text: i18n.tr("Manual Entry")
                    onTriggered: {
                        PopupUtils.open(editDialog)
                  }
                }
            ]
        }
    }

    Column{
        anchors.top: userAccountPage.header.bottom
        width: userAccountPage.width

         ListItem {
            ListItemLayout{
                title.text: i18n.tr("Name")
                subtitle.text: userSettings.userConfigsUserName
        }
    }

    ListItem {
            ListItemLayout{
                title.text: i18n.tr("Age")
                subtitle.text: userSettings.userConfigsAge
        }
    }

        ListItem {
            ListItemLayout{
                title.text: i18n.tr("Sex")
                subtitle.text: userSettings.userConfigsSex
        }
    }

    ListItem {
            ListItemLayout{
                title.text: i18n.tr("Weight")
                subtitle.text: userSettings.userConfigsWeight + "KG"
        }
    }

    ListItem {
            ListItemLayout{
                title.text: i18n.tr("Height")
                subtitle.text: userSettings.userConfigsHeight + "cm"
        }
    }

    ListItem {
            ListItemLayout{
                title.text: i18n.tr("Goal")
                subtitle.text: userSettings.userConfigsGoal + "kcal"
        }
    }
}
}