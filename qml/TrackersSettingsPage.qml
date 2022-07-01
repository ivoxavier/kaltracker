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
import "components"
import "../js/ThemeColors.js" as ThemeColors

Page{
    id: trackers_settings_page
    objectName: 'TrackersSettingsPage'
    header: PageHeader {
                visible: app_settings.is_page_headers_enabled ? true : false
                title: i18n.tr("Trackers Settings")
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

    Flickable {

        anchors{
            top: app_settings.is_page_headers_enabled ? parent.header.bottom : parent.top
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

            ListItem{
                divider.visible: false
                ListItemLayout{
                    subtitle.text : i18n.tr("Sports Tracker")
                    subtitle.font.bold : true
                }
            }

            Text{
                Layout.alignment: Qt.AlignCenter
                text: i18n.tr("%1 min").arg(Math.round(slider.value))
                font.pixelSize: units.gu(3)
                font.bold: true  
                color : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text
            }

            UbuntuShape{  
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(13)
                Layout.preferredHeight: units.gu(3.5)
                backgroundColor : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_slot_background : ThemeColors.utFoods_dark_theme_slot_background 
                Slider{
                    id: slider
                    width: parent.width
                    height: parent.height
                    live: true
                    value : 1
                    minimumValue:1
                    maximumValue:400
                    onValueChanged: app_settings.target_time = Math.round(value)
                }
            }

        }  
    }
    NavigationBar{
        id: navigation_shape
        backgroundColor : Suru.theme === 0 ? ThemeColors.utFoods_porcelain_theme_background : ThemeColors.utFoods_dark_theme_background 
    } 
}