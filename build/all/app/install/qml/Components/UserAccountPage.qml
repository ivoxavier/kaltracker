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
import io.thp.pyotherside 1.5
import Qt.labs.platform 1.0
import Ubuntu.Content 1.3
import "../js/DataBaseTools.js" as DataBase


Page{
    id: userAccountPage
    objectName: 'User Account Page'

    header: PageHeader {
        title: i18n.tr("Account")

        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }
    }

    Column{
        anchors.top: userAccountPage.header.bottom
        width: userAccountPage.width
        spacing: units.gu(2)

        Label{
            text: i18n.tr("User Name: ") + userSettings.userConfigsUserName
        }

        Label{
            text: i18n.tr("User Sex: ") + userSettings.userConfigsSex
        }

        Label{
            text: i18n.tr("User Weight: ") + userSettings.userConfigsWeight + "KG"
        }

        Label{
            text: i18n.tr("User Height: ") + userSettings.userConfigsHeight + "cm"
        }

        Label{
            text: i18n.tr("User Goal: ") + userSettings.userConfigsGoal + "kcal"
        }
    }
}