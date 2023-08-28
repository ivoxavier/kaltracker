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
import QtQuick.Controls 2.2 as QQC2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import "../components"
import "../style"
import "../../js/Token.js" as KaltrackerToken


Page{
    id: settings_page
    objectName: 'SettingsPage'
    header: PageHeader {
                title: i18n.tr("App Settings")
                StyleHints {
                  /*  foregroundColor: Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 
                    backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
                }
        }

    BackgroundStyle{}

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


            ListItemHeader{
                text_header.title.text: i18n.tr("Notifications")
                divider.visible: false
            }

            ListItem {
                divider.visible: false
                ListItemLayout{
                    title.text: i18n.tr("Streams:")
                    Switch{
                        checked: app_settings.is_streams_enabled
                        onClicked: {
                            if(app_settings.is_token_set){
                                app_settings.is_streams_enabled = !app_settings.is_streams_enabled
                            } else{
                                app_settings.token = KaltrackerToken.generateToken() 
                                app_settings.is_streams_enabled = !app_settings.is_streams_enabled
                            }
                        }
                    }
                }  
            }

            ListItem {
                divider.visible: true
                enabled: app_settings.is_streams_enabled
                ListItemLayout{
                    title.text: i18n.tr(" Calories Consumption")
                    CheckBox{
                        enabled: app_settings.is_streams_enabled
                        checked: app_settings.stream_kcal_consumption
                        onClicked: app_settings.stream_kcal_consumption = !app_settings.stream_kcal_consumption
                        onEnabledChanged: {
                            checked = false
                            app_settings.stream_kcal_consumption = false
                        }
                    }
                }  
            }

            ListItem {
                divider.visible: true
                enabled: app_settings.is_streams_enabled
                ListItemLayout{
                    title.text: i18n.tr(" Days Without Registing")
                    CheckBox{
                        enabled: app_settings.is_streams_enabled
                        checked: app_settings.stream_days_without_reg
                        onClicked: app_settings.stream_days_without_reg = !app_settings.stream_days_without_reg
                        onEnabledChanged: {
                            checked = false
                            app_settings.stream_days_without_reg = false
                        }
                    }
                }  
            }


            ListItemHeader{
                text_header.title.text: i18n.tr("Charts")
                divider.visible: false
            }

            ListItem {
                divider.visible: false
                ListItemLayout{
                    title.text: i18n.tr("Animation")
                    Switch{
                        checked: app_settings.is_graphs_animation_enabled
                        onClicked: app_settings.is_graphs_animation_enabled = !app_settings.is_graphs_animation_enabled
                    }
                }  
            }
        }  
    }
}