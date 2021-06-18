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
    id: exportData
    objectName: 'ExportDataPage'

    property string queryToPy

    header: PageHeader {
        title: i18n.tr("Export Data")
    }

    TextEdit {
        id: labelInfo
        text: i18n.tr("A file in csv is created in /home/phablet/Documents/kaltracker.ivoxavier/Databases")
        anchors.top: exportData.header.bottom
        wrapMode: TextEdit.Wrap
        width: parent.width
        readOnly: true
        textFormat: TextEdit.PlainText
        color: theme.palette.normal.fieldText
        leftPadding: units.gu(1)
    } 
    

    Python{
        id: py
        Component.onCompleted:{
            console.log('Python: ' + pythonVersion())
            console.log('PyOtherSide: ' + pluginVersion())
            addImportPath(Qt.resolvedUrl('../py/'))
            importModule('export_data', function() {
                py.call('export_data.moduleState', [] ,function(returnValue){
                console.log(returnValue)
            })
            })

        }
        onError: {
            console.log('Python error: ' + traceback);
        }

    }


    Button{
        id: exportButton
        text: i18n.tr("Export")
        anchors.centerIn: parent
        Component.onCompleted: DataBase.getAllIngestions("exportData")
        onClicked:{
            console.log("Export process started")
            py.call('export_data.saveCSV', [queryToPy] ,function(returnValue){
                debugLabel.text = returnValue
                console.log(returnValue)
            })
        }
    }
}