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
import "../js/DataBase.js" as DataBase
import "./ActionBar"

Page {
    id: resumePage
    objectName: 'ResumePage'
    header: PageHeader {
        title: i18n.tr("userName")
        trailingActionBar.actions: AboutAction{}
    }

    Grid {
        anchors.fill: parent
        topPadding: resumePage.header.height
        columns: 3
        rows:1
        spacing: 3
        
        Label {
            text: "450"
        }

    }
}