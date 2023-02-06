/*
 * 2022-2023 Ivo Xavier
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
import QtQuick.Window 2.0
import "components"


Page{
    id: menu_page
    objectName: 'MenuPage'
    header: PageHeader {
        title: i18n.tr("Menu")
        StyleHints {
            //foregroundColor: "white"
            //backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background 
        }
    }

    BackgroundStyle{}

    Flickable{
        id: flickable

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


            LomiriShape{
                Layout.alignment: Qt.AlignCenter
                radius: "large"
                Layout.preferredWidth: units.gu(12)
                Layout.preferredHeight: units.gu(12)
                aspect: LomiriShape.DropShadow
                source: Image{
                    source: "../assets/logo.svg"
                }
            }

            Label {
                Layout.alignment: Qt.AlignCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: i18n.tr("Version: ") + Qt.application.version
                color : Suru.theme === 0 ? root.kaltracker_light_theme.text_color : root.kaltracker_dark_theme.text_color
            }

            ListItem{
                width: root.width
                divider.visible: false
                ListItemLayout{
                    subtitle.text: i18n.tr("User")
                    subtitle.font.bold: true
                }
            }


            ListItem{
                width: root.width
                ListItemLayout{
                    title.text : i18n.tr("Your Profile")
                    title.font.bold : true
                    title.color : Suru.theme === 0 ? root.kaltracker_light_theme.text_color : root.kaltracker_dark_theme.text_color 
                    Icon{
                        SlotsLayout.position: SlotsLayout.Leading
                        name : "account"
                        height : units.gu(3.5)
                    }

                    ProgressionSlot{}
                }
                onClicked: page_stack.push(update_user_values_page)
            }

            ListItem{
                width: root.width
                ListItemLayout{
                    title.text : i18n.tr("Data Analysis")
                    title.font.bold : true
                    title.color : Suru.theme === 0 ? root.kaltracker_light_theme.text_color : root.kaltracker_dark_theme.text_color
                    Icon{
                        SlotsLayout.position: SlotsLayout.Leading
                        name : "x-office-presentation-symbolic"
                        height : units.gu(3.5)
                    }

                    ProgressionSlot{}
                }
                onClicked: page_stack.push(data_analysis_page)
            }

            ListItem{
                width: root.width
                divider.visible: false
                ListItemLayout{
                    subtitle.text: i18n.tr("Settings")
                    subtitle.font.bold: true
                }
            }

            ListItem{
                width: root.width
        
                ListItemLayout{
                    title.text : i18n.tr("App Settings")
                    title.font.bold : true
                    Icon{
                        SlotsLayout.position: SlotsLayout.Leading
                        name : "preferences-desktop-wallpaper-symbolic"
                        height : units.gu(3.5)
                    }

                    ProgressionSlot{}
                }
                onClicked: page_stack.push(app_layout_page)
            }

            ListItem{
                width: root.width
                ListItemLayout{
                    title.text : i18n.tr("Online Sources")
                    title.font.bold : true

                    Icon{
                        SlotsLayout.position: SlotsLayout.Leading
                        name : "stock_website"
                        height : units.gu(3.5)
                    }

                    ProgressionSlot{}
                }
                onClicked: page_stack.push(online_sources_page)
            }


            ListItem{
                width: root.width
                divider.visible: false
                ListItemLayout{
                    subtitle.text: i18n.tr("Storage")
                    subtitle.font.bold: true
                }
            }

            ListItem{
                width: root.width
                ListItemLayout{
                    title.text : i18n.tr("Manage Data")
                    title.font.bold : true
                    title.color : Suru.theme === 0 ? root.kaltracker_light_theme.text_color : root.kaltracker_dark_theme.text_color 
                    
                    Icon{
                        SlotsLayout.position: SlotsLayout.Leading
                        name : "drive-harddisk-symbolic"
                        height : units.gu(3.5)
                    }

                    ProgressionSlot{}
                }
                onClicked: page_stack.push(manage_data_page)
            }

            ListItem{
                width: root.width
                ListItemLayout{
                    title.text : i18n.tr("Backup & Restore Data")
                    title.font.bold : true
                    title.color : Suru.theme === 0 ? root.kaltracker_light_theme.text_color : root.kaltracker_dark_theme.text_color 
                    
                    Icon{
                        SlotsLayout.position: SlotsLayout.Leading
                        name : "document-save"
                        height : units.gu(3.5)
                    }

                   ProgressionSlot{}
                }
                onClicked: page_stack.push(backup_restore_page)
            }

            ListItem{
                width: root.width
                divider.visible: false
                ListItemLayout{
                    subtitle.text: i18n.tr("About")
                    subtitle.font.bold: true
                }
            }


            ListItem{
                width: root.width
                ListItemLayout{
                    title.text : i18n.tr("Third Party Software")
                    title.font.bold : true
                    title.color : Suru.theme === 0 ? root.kaltracker_light_theme.text_color : root.kaltracker_dark_theme.text_color
                    
                    Icon{
                        SlotsLayout.position: SlotsLayout.Leading
                        name : "text-css-symbolic"
                        height : units.gu(3.5)
                    }

                    ProgressionSlot{}
                }
                onClicked:  page_stack.push(third_party_software_page)
            }
        }
    }
}