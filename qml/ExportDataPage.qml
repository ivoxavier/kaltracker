/*
 * 2022  Ivo Fernandes <pg27165@alunos.uminho.pt>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * utFoods is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import Ubuntu.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Ubuntu.Components.ListItems 1.3 
import Ubuntu.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import Ubuntu.Content 1.3
import io.thp.pyotherside 1.5
import "components"
import "../js/UserTable.js" as UserTable
import "../js/ThemeColors.js" as ThemeColors



Page{
    id: export_data
    objectName: 'ExportData'
    header: PageHeader {
                visible: app_settings.is_page_headers_enabled ? true : false
                title: i18n.tr("Export Data")

                StyleHints {
                    foregroundColor: "white"
                    backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background 
                }
            }
    
    Rectangle{
        anchors{
            top: app_settings.is_page_headers_enabled ? parent.header.bottom : parent.top
            left : parent.left
            right : parent.right
            bottom : parent.bottom
        }
        color : Suru.theme === 0 ? ThemeColors.utFoods_porcelain_theme_background : ThemeColors.utFoods_dark_theme_background 
    }

    Python{
        id: py
        Component.onCompleted:{
            addImportPath(Qt.resolvedUrl('../py/'))
            importModule('export_data', function() {
                py.call('export_data.ExportData.moduleState', [] ,function(returnValue){
                    console.log(returnValue)
            })

                py.call('export_data.ExportData.createPath', [] ,function(returnValue){
                    console.log(returnValue)
            })
            
            })

            /* handlers sent from pyotherside */

            setHandler('user_table_exporting', function() {
                loading_circle.running = true 
        });
            setHandler('user_table_exported', function() {
                user_table_exported_icon.exported = true 
                loading_circle.running = false
        });

            setHandler('user_ingestions_exporting', function() {
                loading_circle.running = true 
        });
            setHandler('user_ingestions_exported', function() {
                user_ingestions_exported_icon.exported = true 
                loading_circle.running = false
        });

            setHandler('user_water_exporting', function() {
                loading_circle.running = true 
        });
            setHandler('user_water_exported', function() {
                user_water_exported_icon.exported = true 
                loading_circle.running = false
        });

            setHandler('user_weight_exporting', function() {
                loading_circle.running = true 
        });
            setHandler('user_weight_exported', function() {
                user_weight_exported_icon.exported = true 
                loading_circle.running = false
        });

            setHandler('user_sport_exporting', function() {
                loading_circle.running = true
        });

            setHandler('user_sports_exported', function() {
                user_sport_exported_icon.exported = true 
                loading_circle.running = false
        });

        }
        onError: {
            console.log('Python error: ' + traceback);
        }

    }
    
    Flickable {

        anchors{
            top:  app_settings.is_page_headers_enabled ? parent.header.bottom : parent.top
            left: parent.left
            right: parent.right
            bottom: app_settings.is_page_headers_enabled ? parent.bottom : navigation_shape.top
        }

        contentWidth: parent.width
        contentHeight: main_column.height  
        
        interactive : root.height > root.width ? false : true

        ColumnLayout{
            id: main_column
            width: root.width
            spacing: units.gu(2)


            ListItem {
                divider.visible: false
                ListItemLayout{
                    subtitle.text: i18n.tr("Store Path: ~/Documents/utFoods_exports/")
                    subtitle.font.bold : true
                }
            }

            BlankSpace{}

            RowLayout{
                Layout.alignment: Qt.AlignCenter

                spacing: units.gu(1)
                
                Label{text: i18n.tr("User Table"); font.bold: true}
                Icon{
                    id: user_table_exported_icon
                    property bool exported : false
                    height : units.gu(3)
                    name : user_table_exported_icon.exported ? "select" : "select-none"
                }
            }
        
            RowLayout{
                spacing: units.gu(1)
                Layout.alignment: Qt.AlignCenter
                Label{text: i18n.tr("Ingestions Table");font.bold: true }
                Icon{
                    id: user_ingestions_exported_icon
                    property bool exported: false
                    height : units.gu(3)
                    name : user_ingestions_exported_icon.exported ? "select" : "select-none"
                }
            }

            RowLayout{
                spacing: units.gu(1)
                Layout.alignment: Qt.AlignCenter
                Label{text: i18n.tr("Water Table"); font.bold: true}
                Icon{
                    id: user_water_exported_icon
                    property bool exported : false
                    height : units.gu(3)
                    name : user_water_exported_icon.exported ? "select" : "select-none"
                }
            }

            RowLayout{
                spacing: units.gu(1)
                Layout.alignment: Qt.AlignCenter
                Label{text: i18n.tr("Weight Table"); font.bold: true}
                Icon{
                    id: user_weight_exported_icon
                    property bool exported : false
                    height : units.gu(3)
                    name :  user_weight_exported_icon.exported ? "select" : "select-none"
                }
            }

            RowLayout{
                spacing: units.gu(1)
                Layout.alignment: Qt.AlignCenter
                Label{text: i18n.tr("Sports Table"); font.bold: true}
                Icon{
                    id: user_sport_exported_icon
                    property bool exported : false
                    height : units.gu(3)
                    name :  user_sport_exported_icon.exported ? "select" : "select-none"
                }
            }

             BlankSpace{}
                
            ActivityIndicator {
                id: loading_circle
                Layout.alignment: Qt.AlignCenter
                running: false
            }


            Label {
                id: state_msg
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width
                visible: false
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: i18n.tr("Please Wait A Few Seconds...")
                font.bold: true
            }

            Button{
                id:export_button
                Layout.alignment: Qt.AlignCenter
                text: i18n.tr("Start Export Process")
                color: UbuntuColors.green
                onClicked:{
                    state_msg.visible = true
                    py.call('export_data.ExportData.createCSVFile', [] ,function(returnValue){
                    console.log(returnValue)
                    })

                    py.call('export_data.ExportData.userTable', [] ,function(returnValue){
                    console.log(returnValue)
                    })

                    py.call('export_data.ExportData.ingestionsTable', [] ,function(returnValue){
                    console.log(returnValue)
                    })

                    py.call('export_data.ExportData.waterTable', [] ,function(returnValue){
                    console.log(returnValue)
                    })

                    py.call('export_data.ExportData.weightTable', [] ,function(returnValue){
                    console.log(returnValue)
                    })

                    py.call('export_data.ExportData.sportsTable', [] ,function(returnValue){
                    console.log(returnValue)
                    })
                }
            }
        }  
    }
  
    NavigationBar{id: navigation_shape}   
}