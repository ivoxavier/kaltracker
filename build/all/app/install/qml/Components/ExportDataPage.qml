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
import Ubuntu.Components.ListItems 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12
import io.thp.pyotherside 1.5
import Qt.labs.platform 1.0
import Ubuntu.Content 1.3
import "../js/DataBaseTools.js" as DataBase


Page{
    id: exportDataPage
    objectName: 'ExportDataPage'

    property string ingestions_query
    property string user_query
    property string weight_query

    header: PageHeader {
        title: i18n.tr("Export Data")

        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }

    }

    Column{
        anchors.top: exportDataPage.header.bottom
        anchors.bottom: exportDataPage.bottom
        anchors.left: exportDataPage.left
        anchors.right: exportDataPage.right
        width: exportDataPage.width
        spacing: units.gu(6)

        ListItem {
                divider.visible: false
                ListItemLayout{
                    title.text: i18n.tr("Files are stored in csv formart")
                    subtitle.text: i18n.tr("Path: Documents/kaltracker_exports/")
                    title.font.bold: true
                }
            }
            
            Timer{
                id: timer
                repeat: false
            }

            Icon{
                anchors.horizontalCenter: parent.horizontalCenter
                name: loadingCircle.running ? "mail-mark-important" : "thumb-up"
                width: (exportDataPage.width / 3.33)
                height:  (exportDataPage.header.height * 2)
            }

            ActivityIndicator {
                id: loadingCircle
                anchors.horizontalCenter: parent.horizontalCenter
                running: false
                onRunningChanged: {
                

                    function animationState(delayMiliseconds, cb) {
                        timer.interval = delayMiliseconds;
                        timer.triggered.connect(cb);
                        timer.start();
                    }  
                
                animationState(9000, function () {
                    exportButton.enabled = true
                    stateMsg.text = i18n.tr("You may now start the export. It may take a while.")
                    loadingCircle.running = false
                    exportButton.color = UbuntuColors.blue
                })
    
            }
        }

        TextEdit {
            id: stateMsg
            text: i18n.tr("Preparing data for processing. Please, wait a few seconds")
            wrapMode: TextEdit.Wrap
            width: parent.width
            readOnly: true
            textFormat: TextEdit.PlainText
            color: theme.palette.normal.fieldText
            leftPadding: units.gu(1)
        }

        
        Button{
            id: exportButton
            anchors.horizontalCenter: parent.horizontalCenter
            text: i18n.tr("Export")
            enabled: false
         
        //fetch data from DB before click to extract
        Component.onCompleted: {
            DataBase.getUserProfile()
            DataBase.getWeightTracker()
            DataBase.getAllIngestions("exportData")
        }
        
        onClicked:{

            py.call('export_data.createPath', [] ,function(returnValue){
                console.log(returnValue)
                })


            py.call('export_data.deleteFile', [] ,function(returnValue){
                console.log(returnValue)
            })

            py.call('export_data.createFile', [] ,function(returnValue){
                console.log(returnValue)
            })
            

            py.call('export_data.saveIngestions', [ingestions_query] ,function(returnValue){
                if (returnValue === 'file_saved'){
                    backupStatus.text = i18n.tr("...Done :)")
                } else {
                    backupStatus.text = i18n.tr("Oops. Check the logs")
                }
            })

            py.call('export_data.saveUser', [user_query] ,function(returnValue){
                if (returnValue === 'file_saved'){
                    backupStatus.text = i18n.tr("...Done :)")
                } else {
                    backupStatus.text = i18n.tr("Oops. Check the logs")
                }
            })


            py.call('export_data.saveWeight', [weight_query] ,function(returnValue){
                if (returnValue === 'file_saved'){
                    backupStatus.text = i18n.tr("...Done :)")
                } else {
                    backupStatus.text = i18n.tr("Oops. Check the logs")
                }
            })

        }
    }
            Label{
                anchors.right: parent.right
                id:backupStatus
                font.bold: true
            }
    }
    

    Python{
        id: py
        Component.onCompleted:{
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


     Component.onCompleted: {
       loadingCircle.running = true
    }
    
}