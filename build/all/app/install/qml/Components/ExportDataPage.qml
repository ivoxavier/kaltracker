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

        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }

    }

    Column{
        anchors.top: exportData.header.bottom
        anchors.bottom: exportData.bottom
        anchors.left: exportData.left
        anchors.right: exportData.right
        width: exportData.width
        spacing: units.gu(10)

        TextEdit {
            id: labelInfo
            text: i18n.tr("A file will be created in Documents/kaltracker.ivoxavier/")
            wrapMode: TextEdit.Wrap
            width: parent.width
            readOnly: true
            textFormat: TextEdit.PlainText
            color: theme.palette.normal.fieldText
            leftPadding: units.gu(1)
        } 

        Row{
            spacing: units.gu(1)
            Label{
                id: backupStatus
                text: " "
            }
        }
        Button{
            id: exportButton
            anchors.horizontalCenter: parent.horizontalCenter
            text: i18n.tr("Export")
        
        //fetch data from DB before click to extract
        Component.onCompleted: DataBase.getAllIngestions("exportData")
        
        onClicked:{
            console.log("Export process started")

            py.call('export_data.createPath', [] ,function(returnValue){console.log(returnValue)})

            py.call('export_data.createFile', [] ,function(returnValue){
                console.log(returnValue)
            })
            py.call('export_data.deleteCSV', [] ,function(returnValue){
                console.log(returnValue)
            })

            py.call('export_data.saveCSV', [queryToPy] ,function(returnValue){
                if (returnValue === 'file_saved'){
                    backupStatus.text = i18n.tr("Backup created")
                } else {
                    backupStatus.text = i18n.tr("Oops. Check the logs")
                }
            })
        }
    }
    
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


    
    
}