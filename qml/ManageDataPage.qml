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
//import QtQuick.Controls 2.2 as QQC2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import io.thp.pyotherside 1.5
import "components"
import "style"


Page{
    id: manage_data_page
    objectName: 'ManageDataPage'
    header: PageHeader {
              //  visible: app_settings.is_page_headers_enabled ? true : false
                title: i18n.tr("Manage Data")
                StyleHints {
                    /*foregroundColor: "white"
                    backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
                }
            }

    BackgroundStyle{}

    //to differentiate from deletion type
    property int delete_type

    Component{
        id: delete_dialog
        RemoveRecordsDialog{msg: delete_type == 0 ? "today" : "all"}
    }

    Component{
        id: delete_month_year_dialog
        DeleteByMonthPop{}
    }

    Component{
        id: delete_all_water
        DeleteAllWaterDialog{}
    }

    Component{
        id: delete_all_weight_tracker
        DeleteAllWeightTrackerDialog{}
    }


    Component{
        id: delete_all_notes_dialog
        DeleteAllNotesDialog{}
    }

    Component{
        id: operation_result_popover
        OperationResultPopOver{}
    }

    Python{
        id: py
        Component.onCompleted:{
            addImportPath(Qt.resolvedUrl('../py/'))
        }
        onError: {
            console.log('Python error: ' + traceback);
        }

    }

    Flickable {

        anchors{
            top: parent.header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        contentWidth: parent.width
        contentHeight: main_column.height  
        
        ColumnLayout{
            id: main_column
            width: root.width


            ListItem {
                divider.visible: false
                ListItemLayout{
                    subtitle.text: i18n.tr("Ingestions")
                    subtitle.font.bold : true
                }  
            }       

         
            ListItem {
                divider.visible: false
                ListItemLayout{
                    title.text: i18n.tr("Auto Delete Ingestions")
                    title.font.bold : true
                    subtitle.text: i18n.tr("Deletes All Previous Year Ingestions")

                    Icon{
                        SlotsLayout.position: SlotsLayout.Leading
                        name : "smartwatch-symbolic" 
                        height : units.gu(3.5)
                    }

                    Switch{
                        checked: app_settings.is_auto_cleaning
                        onClicked:  app_settings.is_auto_cleaning = !app_settings.is_auto_cleaning
                    }
                }  
            }

            ListItem {
                divider.visible : false
                ListItemLayout{
                    title.text: i18n.tr("From a Month & To Year")
                    title.font.bold : true
                    Icon{
                        SlotsLayout.position: SlotsLayout.Leading
                        name : "calendar-app-symbolic"
                        height : units.gu(3.5)
                    }
                    ProgressionSlot{}
                }
                onClicked: {
                    PopupUtils.open(delete_month_year_dialog)
                }
            }

            ListItem {
                divider.visible : false
                ListItemLayout{
                    title.text: i18n.tr("Specific Today's Ingestion")
                    title.font.bold : true

                    Icon{
                        SlotsLayout.position: SlotsLayout.Leading
                        name : "view-list-symbolic"
                        height : units.gu(3.5)
                    }

                    ProgressionSlot{}
                }
                onClicked: {
                    page_stack.push(delete_today_ingestion_page)
                  
                }
            }

            ListItem {
                divider.visible : false
                ListItemLayout{
                    title.text: i18n.tr("Only Today's Ingestions")
                    title.font.bold : true
                
                    Button{
                        text: i18n.tr("Delete")
                        color: LomiriColors.red
                        onClicked:{
                            delete_type = 0
                            PopupUtils.open(delete_dialog)
                        }
                    }   
                }
            }

            ListItem {
                divider.visible : false
                ListItemLayout{
                    title.text: i18n.tr("All Ingestions")
                    title.font.bold : true

                    Button{
                        text:i18n.tr("Delete")
                        color:LomiriColors.red
                        onClicked:{
                            delete_type = 1
                            PopupUtils.open(delete_dialog)
                        }   
                    }
                }
            }

            ListItem {
                divider.visible: false
                ListItemLayout{
                    subtitle.text: i18n.tr("User Foods List")
                    subtitle.font.bold : true
                }  
            } 

            ListItem{
                divider.visible: false
                ListItemLayout{
                        title.text : i18n.tr("User Created Foods List")
                        title.font.bold : true
                        Icon{
                            SlotsLayout.position: SlotsLayout.Leading
                            name : "x-office-document-symbolic"
                            height : units.gu(3.5)
                        }
                        ProgressionSlot{}
                }

                onClicked: page_stack.push(manager_user_foods_list_page)
            }

            ListItem {
                divider.visible: false
                ListItemLayout{
                    subtitle.text: i18n.tr("Water")
                    subtitle.font.bold : true
                }  
            } 

            
            ListItem {
                divider.visible : false
                ListItemLayout{
                    title.text: i18n.tr("All Water Records")
                    title.font.bold : true

                    Button{
                        text:i18n.tr("Delete")
                        color:LomiriColors.red
                        onClicked:{
                            PopupUtils.open(delete_all_water)
                        }   
                    }
                }
            }


            ListItem {
                divider.visible: false
                ListItemLayout{
                    subtitle.text: i18n.tr("Notes")
                    subtitle.font.bold : true
                }  
            } 

            ListItem {
                divider.visible : false
                ListItemLayout{
                    title.text: i18n.tr("Delete All Notes")
                    title.font.bold : true

                    Button{
                        text:i18n.tr("Delete")
                        color:LomiriColors.red
                        onClicked:{
                            PopupUtils.open(delete_all_notes_dialog)
                        }   
                    }
                }
            }


            ListItem {
                divider.visible: false
                ListItemLayout{
                    subtitle.text: i18n.tr("Weight Tracker")
                    subtitle.font.bold : true
                }  
            } 

            ListItem {
                divider.visible : false
                ListItemLayout{
                    title.text: i18n.tr("All Records")
                    title.font.bold : true

                    Button{
                        text:i18n.tr("Delete")
                        color:LomiriColors.red
                        onClicked:{
                            PopupUtils.open(delete_all_weight_tracker)
                        }   
                    }
                }
            }
        }  
    }  
}