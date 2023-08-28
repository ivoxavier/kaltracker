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
import QtQuick.Layouts 1.3
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import Lomiri.Components.Pickers 1.3
//import QtCharts 2.3
import Lomiri.Components.ListItems 1.3
import QtQuick.LocalStorage 2.12
import QtQuick.Controls.Suru 2.2
import "components"
import "style"
import "logicalFields"
import "../js/Chart.js" as Charts
import "../js/QChartJsTypes.js" as ChartTypes
import "../js/GetData.js" as GetData



Page {
    id: graphs_page
    objectName: 'GraphsPage'

        header: PageHeader {
        title: i18n.tr("Graphs")
       // visible: app_settings.is_page_headers_enabled ? true : false

        StyleHints {
           /*foregroundColor: "white"
            backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
        }
     }
    

    Canvas{
        id: canvas
        width : parent.width
        height : parent.height
        //z:100
        onPaint:{ 
        var ctx = getContext("2d");
       // ctx.save();
        ctx.globalCompositeOperation = 'destination-over'
        // Now draw!
        ctx.fillStyle = app_style.chart.bar.nutriscore.backgroundColor
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        }
    }

    Flickable{

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
               text_header.title.text: i18n.tr("Weight Progress")
               divider.visible: false
            }

            Grid {
                id:chartLine
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(1)
                Layout.preferredHeight:  units.gu(37)
                visible: true
                columns:1
                columnSpacing: units.gu(1)

                QChartJs {
                    id: chart_line
                    width: parent.width
                    height: parent.height
                    chartType: ChartTypes.QChartJSTypes.LINE
                    chartData: GetData.getChartLineData(app_settings.using_app_date, logical_fields.application.date_utils.long_date)
                    animation: app_settings.is_graphs_animation_enabled
                    chartAnimationEasing: Easing.InOutElastic;
                    chartAnimationDuration: 2000;
                }

            }
            

            ListItemHeader{
               text_header.title.text: i18n.tr("Foods Distribution By Nutriscore")
               divider.visible: false
            }

            Grid {
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(1)
                Layout.preferredHeight:  units.gu(37)
                visible: true
                columns:1
                columnSpacing: units.gu(1)

                QChartJs {
                    id: chart_bar
                    width: parent.width
                    height: parent.height
                    chartType: ChartTypes.QChartJSTypes.BAR
                    chartData: GetData.getChartBarData()
                    animation: app_settings.is_graphs_animation_enabled
                    chartAnimationEasing: Easing.InOutElastic;
                    chartAnimationDuration: 2000;
                }

            }

            
        }

    }
   
}