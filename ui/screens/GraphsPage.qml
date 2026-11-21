/*
 * 2022-2026  Ivo Xavier
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
import "../components"
import "../theme"
import "../logicalFields"
import "../../js/Chart.js" as Charts
import "../../js/QChartJsTypes.js" as ChartTypes

Page {
    id: graphs_page
    objectName: 'GraphsPage'

    property var lineData: null
    property var barData: null

    function hasChartData(data) {
        return data !== undefined && data !== null && data.labels && data.labels.length > 0;
    }

    function reloadCharts() {
        lineData = dataAnalysisRepository.getChartLineData(
            app_settings.using_app_date,
            logical_fields.application.date_utils.long_date
        );
        barData = dataAnalysisRepository.getChartBarData();

        if (hasChartData(lineData)) {
            chart_line.chartData = lineData;
            chart_line.requestPaint();
        }
        if (hasChartData(barData)) {
            chart_bar.chartData = barData;
            chart_bar.requestPaint();
        }
    }

    header: PageHeader {
        title: i18n.tr("Graphs")
    }

    BackgroundStyle {}

    Flickable {
        anchors {
            top: parent.header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentWidth: width
        contentHeight: main_col.height + units.gu(4)
        clip: true

        Column {
            id: main_col
            width: parent.width - units.gu(3)
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: units.gu(2)
            bottomPadding: units.gu(4)
            spacing: units.gu(2.5)


            LomiriShape {
                width: parent.width
                height: weight_card_col.height + units.gu(3)
                radius: "large"
                aspect: LomiriShape.DropShadow
                backgroundColor: app_style.shape.shapeColor

                Column {
                    id: weight_card_col
                    width: parent.width - units.gu(3)
                    anchors.centerIn: parent
                    spacing: units.gu(1.5)

                    RowLayout {
                        width: parent.width

                        Label {
                            text: i18n.tr("Weight Progress")
                            font.pixelSize: units.gu(1.9)
                            font.weight: Font.DemiBold
                            color: app_style.label.labelColor
                            Layout.fillWidth: true
                        }

                        Label {
                            text: app_settings.using_app_date + " → " + logical_fields.application.date_utils.long_date
                            font.pixelSize: units.gu(1.2)
                            color: LomiriColors.ash
                            visible: graphs_page.hasChartData(graphs_page.lineData)
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: units.dp(1)
                        color: Qt.rgba(0.5, 0.5, 0.5, 0.15)
                    }

                    Item {
                        width: parent.width
                        height: units.gu(32)

                        QChartJs {
                            id: chart_line
                            anchors.fill: parent
                            visible: graphs_page.hasChartData(graphs_page.lineData)
                            chartType: ChartTypes.QChartJSTypes.LINE
                            chartData: graphs_page.lineData
                            animation: app_settings.is_graphs_animation_enabled
                            chartAnimationEasing: Easing.OutCubic
                            chartAnimationDuration: 800
                        }

                        // Estado vazio
                        Column {
                            anchors.centerIn: parent
                            spacing: units.gu(1)
                            visible: !graphs_page.hasChartData(graphs_page.lineData)

                            Icon {
                                anchors.horizontalCenter: parent.horizontalCenter
                                name: "empty-symbolic"
                                width: units.gu(5)
                                height: units.gu(5)
                                opacity: 0.5
                            }

                            Label {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: i18n.tr("No weight records yet.")
                                font.pixelSize: units.gu(1.6)
                                color: LomiriColors.ash
                            }
                        }
                    }
                }
            }


            LomiriShape {
                width: parent.width
                height: nutriscore_card_col.height + units.gu(3)
                radius: "large"
                aspect: LomiriShape.DropShadow
                backgroundColor: app_style.shape.shapeColor

                Column {
                    id: nutriscore_card_col
                    width: parent.width - units.gu(3)
                    anchors.centerIn: parent
                    spacing: units.gu(1.5)

                    Label {
                        text: i18n.tr("Foods Distribution By Nutriscore")
                        font.pixelSize: units.gu(1.9)
                        font.weight: Font.DemiBold
                        color: app_style.label.labelColor
                    }

                    Rectangle {
                        width: parent.width
                        height: units.dp(1)
                        color: Qt.rgba(0.5, 0.5, 0.5, 0.15)
                    }

                    Item {
                        width: parent.width
                        height: units.gu(32)

                        QChartJs {
                            id: chart_bar
                            anchors.fill: parent
                            visible: graphs_page.hasChartData(graphs_page.barData)
                            chartType: ChartTypes.QChartJSTypes.BAR
                            chartData: graphs_page.barData
                            animation: app_settings.is_graphs_animation_enabled
                            chartAnimationEasing: Easing.OutCubic
                            chartAnimationDuration: 800
                        }


                        Column {
                            anchors.centerIn: parent
                            spacing: units.gu(1)
                            visible: !graphs_page.hasChartData(graphs_page.barData)

                            Icon {
                                anchors.horizontalCenter: parent.horizontalCenter
                                name: "empty-symbolic"
                                width: units.gu(5)
                                height: units.gu(5)
                                opacity: 0.5
                            }

                            Label {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: i18n.tr("No food records yet.")
                                font.pixelSize: units.gu(1.6)
                                color: LomiriColors.ash
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: reloadCharts()
    onVisibleChanged: {
        if (visible) {
            reloadCharts();
        }
    }
}
