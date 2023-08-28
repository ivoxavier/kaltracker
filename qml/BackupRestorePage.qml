/*
 * 2022-2023  Ivo Xavier 
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
import Lomiri.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import Lomiri.Content 1.3
import io.thp.pyotherside 1.5
import "components"
import "style"
import "../js/UserTable.js" as UserTable



Page{
    id: backuprestore_page
    objectName: 'BackupRestorePage'
    header: PageHeader {
               //visible: app_settings.is_page_headers_enabled ? true : false
                title: i18n.tr("Backup & Restore Data")

                StyleHints {
                   /* foregroundColor: "white"
                    backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
                }
            }

    BackgroundStyle{}
    

    Python{
        id: py
        Component.onCompleted:{
            addImportPath(Qt.resolvedUrl('../py/'))
            importModule('backup_restore', function() {
                py.call('backup_restore.ExportData.moduleState', [] ,function(returnValue){
                    console.log(returnValue)
            })
         
            })

             /* handlers sent from pyotherside */

            setHandler('file_verification_success', function() {
                PopupUtils.open(backuprestore_notify_pop)
                py.call('backup_restore.ImportData.loadData', [] ,function(isDataLoaded){})
            });

            setHandler('file_verification_fail', function() {
                backuprestore_page.operationFinished()
                PopupUtils.open(files_not_valid)
            });

            setHandler('load_success', function() {
                backuprestore_page.operationFinished()
                PopupUtils.open(data_loaded_dialog)
            });

            setHandler('load_fail', function() {
                backuprestore_page.operationFinished()
                PopupUtils.open(data_not_loaded_dialog)
            });

            setHandler('files_export_success', function() {
                backuprestore_page.operationFinished()
                PopupUtils.open(data_exported_dialog)
            });

            setHandler('files_export_fail', function() {
                backuprestore_page.operationFinished()
                PopupUtils.open(error_dialog)
            });


        }
        onError: {
            console.log('Python error: ' + traceback);
        }

    }

    Component{
        id: error_dialog
        MessageDialog{msg:i18n.tr("Something went wrong, please verify Logs")}
    }

    Component{
        id: files_not_valid
        MessageDialog{msg:i18n.tr("Verify if files exists and if headers match accordingly")}
    }


    Component{
        id: data_not_loaded_dialog
        MessageDialog{msg:i18n.tr("Data not loaded, please check logs")}
    }

    Component{
        id: data_exported_dialog
        MessageDialog{msg:i18n.tr("Data exported!")}
    }

    Component{
        id: data_loaded_dialog
        MessageDialog{msg:i18n.tr("Data loaded! We recomend a reboot of the app.")}
    }

    Component{
        id: backuprestore_notify_pop
        BackupRestoreNotifyPop{}
    }
    
    //to allow the popup be closed
    signal operationFinished()

    Flickable {

        anchors{
            top:  parent.header.bottom 
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        contentWidth: parent.width
        contentHeight: main_column.height  
        
        //interactive : root.height > root.width ? false : true

        ColumnLayout{
            id: main_column
            width: root.width
            //spacing: units.gu(2)

            BlankSpace{height:units.gu(4.5)}

            SlotBackupRestore{
                Layout.alignment: Qt.AlignCenter
                icon_source: "../assets/export_icon.svg"
                slot_label: i18n.tr("Export Data")
                slot_path_label : "./local/share/kaltracker.ivoxavier/Export"
                 
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        PopupUtils.open(backuprestore_notify_pop)
                        py.call('backup_restore.ExportData.createFiles', [] ,function(returnValue){})    
                    }    
                }
            }

            BlankSpace{height:units.gu(6)}

            SlotBackupRestore{
                Layout.alignment: Qt.AlignCenter
                icon_source: "../assets/import_icon.svg"
                slot_label: i18n.tr("Import Data")
                slot_path_label : "./local/share/kaltracker.ivoxavier/Import"
                
                MouseArea{
                    anchors.fill: parent
                    onClicked:{
                        py.call('backup_restore.ImportData.filesExists', [] ,function(filesOK){
                            if (filesOK < 1){PopupUtils.open(files_not_valid);console.log("files not in folder OR wrong name")}
                        })              
                    }
                }
            }  
            
            BlankSpace{height:units.gu(4)}


            ListItemHeader{
                text_header.title.text: i18n.tr("Importing Requirements")
                divider.visible: false
            }


            Label{
                Layout.alignment: Qt.AlignCenter
                font.pixelSize: units.gu(1.5)
               // width: parent.width
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignLeft    
                color : Suru.theme === 0 ? root.kaltracker_light_theme.text_color : root.kaltracker_dark_theme.text_color
                text: i18n.tr("Place the files from ExportData in Import path.") 
            }
        }  
    }
}