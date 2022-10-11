/*
 * 2022  Ivo Xavier
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
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Ubuntu.Components.ListItems 1.3 
import Ubuntu.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import Ubuntu.Content 1.3
import "components"
import "../js/UserTable.js" as UserTable




Page{
    id: data_analysis_page
    objectName: 'DataAnalysisPage'
    header: PageHeader {
              //  visible: app_settings.is_page_headers_enabled ? true : false
                title: i18n.tr("Data Analysis")
                StyleHints {
                   /* foregroundColor: Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 
                    backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
                }
        }

    Rectangle{
        anchors{
            top: parent.header.bottom
            left : parent.left
            right : parent.right
            bottom : parent.bottom
        }
        color : Suru.theme === 0 ? root.kaltracker_light_theme.background : root.kaltracker_dark_theme.background
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

        interactive : root.height > root.width ? false : true
        
        ColumnLayout{
            id: main_column
            width: root.width

            ListItem{
                divider.visible : false
                ListItemLayout{
                    subtitle.text: i18n.tr("Ingestions")
                    subtitle.font.bold : true
                }
            }
           

            ListItem{
                ListItemLayout{
                    title.text: i18n.tr("Average Calories Consumption")
                    title.font.bold : true
                    subtitle.text: i18n.tr("By Month")
                    Icon{
                        SlotsLayout.position: SlotsLayout.Leading
                        source : "../assets/average_icon.svg"
                        height : units.gu(3.8)
                    }
                    ProgressionSlot{}
                }
                onClicked : page_stack.push(average_calories_page)
            }

            ListItem{
                ListItemLayout{
                    title.text: i18n.tr("Charts")
                    title.font.bold : true
                    Icon{
                        SlotsLayout.position: SlotsLayout.Leading
                        source : "../assets/graphs_icon.svg"
                        height : units.gu(3.8)
                    }
                    ProgressionSlot{}
                }
                onClicked : page_stack.push(graphs_page)
            }

            ListItem{
                divider.visible : false
                ListItemLayout{
                    subtitle.text: i18n.tr("Body Measurements")
                    subtitle.font.bold: true
                }
            }

            ListItem{
                ListItemLayout{
                    title.text: i18n.tr("Indexes")
                    title.font.bold : true
                    Icon{
                        SlotsLayout.position: SlotsLayout.Leading
                        source : "../assets/body_icon.svg"
                        height : units.gu(3.8)
                    }
                    ProgressionSlot{}
                }
                onClicked : page_stack.push(body_measures_page)
            }
        }
    }  
   
}
