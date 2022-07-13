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
import QtCharts 2.3
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import "components"
import "../js/GetData.js" as GetData
import "../js/ThemeColors.js" as ThemeColors



Page{
    id: average_calories_page
    objectName: 'AverageCaloriesPage'
    header: PageHeader {
                title : i18n.tr("Average Calories Consumption")

                StyleHints {
                    /*foregroundColor: Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 
                    backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
            }
        }

    Rectangle{
        anchors{
            top: parent.top
            left : parent.left
            right : parent.right
            bottom : parent.bottom
        }
        color : Suru.theme === 0 ? ThemeColors.utFoods_porcelain_theme_background : ThemeColors.utFoods_dark_theme_background 
    }

    Icon{
        name: "cancel"
        height : units.gu(5)
        anchors.centerIn: parent
        visible : average_calories_list.visible ? false : true
    }

    ListModel{
        id: avg_month_calories
        Component.onCompleted: GetData.getAverageCalories()
    }

    ListView{
        id: average_calories_list
        anchors{
            top: parent.header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        model: avg_month_calories
        clip: true
        removeDisplaced: Transition {
            NumberAnimation { 
                properties: "x,y"
                 duration: 1000 
                }
            }
        visible: model.count === 0 ? false : true
        delegate: ListItem{
            ListItemLayout{
                title.text: month === '01' ?
                i18n.tr("January") : month === '02' ?
                i18n.tr("February") : month === '03' ?
                i18n.tr("March") : month === '04' ?
                i18n.tr("April") : month === '05' ?
                i18n.tr("May") : month === '06' ?
                i18n.tr("June") : month === '07' ?
                i18n.tr("July") : month === '08' ?
                i18n.tr("August") : month === '09' ?
                i18n.tr("September") : month === '10' ?
                i18n.tr("October") : month === '11' ?
                i18n.tr("November") : i18n.tr("December")
                title.font.bold : true
                subtitle.text: i18n.tr("%1 cal").arg(Math.round(average * 10) /10) 
                ProgressionSlot{}
                }
            onClicked:{
                page_stack.push(list_foods_ingested_month_page,{requested_month: month})
            }
        }
    }
    
}