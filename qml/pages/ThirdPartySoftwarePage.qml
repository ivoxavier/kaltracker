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
import QtCharts 2.3
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import "../components"
import "../style"



Page{
    id: third_party_software_page
    objectName: 'ThirdPartySoftwarePage'
    header: PageHeader {
                //visible: app_settings.is_page_headers_enabled ? true : false
                title: i18n.tr("Third Party Software")
                StyleHints {
                   /* foregroundColor: "white"
                    backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
                }
            }

    BackgroundStyle{}

    Flickable {

        anchors{
            top:  parent.header.bottom 
            left: parent.left
            right: parent.right
            bottom:  parent.bottom 
        }

        contentWidth: parent.width
        contentHeight: main_column.height  
        

        ColumnLayout{
            id: main_column
            width: root.width


            ListItemHeader{
                text_header.title.text: i18n.tr("QML Modules")
                divider.visible: false
            }

            ListItem{
                id: chart_list_item
                divider.visible: false
                property string github_url : "https://github.com/shuirna/QMLChartJs"
                onClicked : Qt.openUrlExternally(github_url)
                ListItemLayout{
                    title.text: "QChartsJs"
                    subtitle.text: chart_list_item.github_url
                }
            }

            ListItem{
                id: json_list_model_list
                divider.visible: false
                property string github_url : "https://github.com/kromain/qml-utils"
                onClicked : Qt.openUrlExternally(github_url)
                ListItemLayout{
                    title.text: i18n.tr("%1. Licensed under the MIT licence").arg("JSONListModel")
                    subtitle.text: json_list_model_list.github_url
                }
            }


            ListItemHeader{
                text_header.title.text: i18n.tr("JavaScript Libs")
                divider.visible: false
            }

            ListItem{
                id: json_path_list
                divider.visible: false
                property string url : "https://goessner.net/2007/09/jsonpath-xpath-for-json.html"
                onClicked : Qt.openUrlExternally(url)
                ListItemLayout{
                    title.text: i18n.tr("%1. Licensed under the MIT licence").arg("jsonpath")
                    subtitle.text: json_path_list.url
                }
            }

            ListItemHeader{
                text_header.title.text: i18n.tr("C++ Modules")
                divider.visible: false
            }

            ListItem{
                id: qzxing_list
                divider.visible: false
                property string github_url : "https://github.com/ftylitak/qzxing"
                onClicked : Qt.openUrlExternally(github_url)
                ListItemLayout{
                    title.text: i18n.tr("%1. Licensed under the Apache License 2.0").arg("qzxing")
                    subtitle.text: qzxing_list.github_url
                }
            } 

            ListItemHeader{
                text_header.title.text: i18n.tr("Icons")
                divider.visible: false
            }

            ListItem{
                id: cycling_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/104554/cycling"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "cycling-svgrepo-com"
                    subtitle.text: cycling_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: swimming_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/51280/swimming"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "swimming-svgrepo-com"
                    subtitle.text : swimming_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: running_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/352414/running"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "running-svgrepo-com"
                    subtitle.text : running_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: walking_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/352679/walking"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "walking-svgrepo-com"
                    subtitle.text : walking_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: gym_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/73588/gym"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "gym-svgrepo-com"
                    subtitle.text : gym_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: people_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/335242/people"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "people-svgrepo-com"
                    subtitle.text : people_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: apple_fruit_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/162563/apple-fruit"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "apple-fruit-svg-repo-com"
                    subtitle.text: apple_fruit_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: olive_oil
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/285053/olive-oil"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "olive-oil-fruit-svgrepo-com"
                    subtitle.text : olive_oil.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: breakfast_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/235691/breakfast"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "breakfast-svgrepo-com"
                    subtitle.text : breakfast_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: bread_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/56092/bread"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "bread-svgrepo-com"
                    subtitle.text: bread_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: cheese_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/75606/cheese"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "cheese-svgrepo-com"
                    subtitle.text: cheese_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: meal_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/161399/meal"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "meal-svgrepo-com"
                    subtitle.text : meal_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: dinner_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/98954/dinner"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "dinner-svgrepo-com"
                    subtitle.text : dinner_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: cycling_color_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/5082/cycling"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "cycling-color-svgrepo-com"
                    subtitle.text : cycling_color_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: dumbbel_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/184605/dumbbell-gym"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "dumbbell-gym-svgrepo-com"
                    subtitle.text : dumbbel_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: female_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/257877/female-gender"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "female-gender-svgrepo-com"
                    subtitle.text: female_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: fried_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/282198/fried-chicken-meal"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "fried-chicken-meal-svgrepo-com"
                    subtitle.text : fried_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: glass_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/227392/glass-of-water"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "glass-water-svgrepo-com"
                    subtitle.text: glass_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: goal_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/227086/goal"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "goal-svgrepo-com"
                    subtitle.text: goal_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: kilograms_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/282312/kilograms-justice"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "kilograms-justice-svgrepo-com"
                    subtitle.text : kilograms_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: male_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/144365/male"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "male-svgrepo-com"
                    subtitle.text : male_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: snack_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/219539/shoe"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "snack-snacks-svgrepo-com"
                    subtitle.text : snack_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: soccer_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/168852/soccer"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "soccer-svgrepo-com"
                    subtitle.text : snack_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

            ListItem{
                id: walking__dog_list
                divider.visible: false
                property string svgrepo_url : "https://www.svgrepo.com/svg/79753/walking-the-dog"
                onClicked : Qt.openUrlExternally(svgrepo_url)
                ListItemLayout{
                    title.text: "walking-the-dog-svgrepo-com"
                    subtitle.text: walking__dog_list.svgrepo_url
                    ProgressionSlot{}
                }
            }

        }      
    }
     
}