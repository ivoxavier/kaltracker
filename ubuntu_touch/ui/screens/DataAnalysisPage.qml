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
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import "../components"
import "../theme"

Page {
    id: data_analysis_page
    objectName: 'DataAnalysisPage'

    readonly property bool isAnyAgentActive: app_settings.is_agent_gemini_enabled ||
                                             app_settings.is_agent_chatgpt_enabled ||
                                             app_settings.is_agent_claude_enabled

    header: PageHeader {
        title: i18n.tr("Data Analysis")
    }

    BackgroundStyle {}

    Component {
        id: noAgentDialogComponent
        Dialog {
            id: noAgentDialog
            title: i18n.tr("Agent Not Configured")
            text: i18n.tr("Please activate and configure at least one AI Agent in the API settings before using this feature.")

            Button {
                text: i18n.tr("Open Online Sources")
                color: app_style.button.actionButton.buttonColor
                onClicked: {
                    PopupUtils.close(noAgentDialog);
                    page_stack.push(online_sources_page);
                }
            }

            Button {
                text: i18n.tr("Close")
                onClicked: PopupUtils.close(noAgentDialog)
            }
        }
    }

    Flickable {
        anchors {
            top: parent.header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentWidth: width
        contentHeight: main_column.height + units.gu(4)
        clip: true

        Column {
            id: main_column
            width: parent.width - units.gu(3)
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: units.gu(2)
            bottomPadding: units.gu(4)
            spacing: units.gu(1.2)


            Label {
                x: units.gu(1)
                text: i18n.tr("INGESTIONS")
                font.pixelSize: units.gu(1.3)
                font.weight: Font.DemiBold
                color: app_style.label.secondaryColor
            }

            LomiriShape {
                width: parent.width
                height: ingestions_col.height
                radius: "large"
                aspect: LomiriShape.DropShadow
                backgroundColor: app_style.shape.shapeColor

                Column {
                    id: ingestions_col
                    width: parent.width

                    ListItem {
                        width: parent.width
                        divider.visible: false
                        onClicked: page_stack.push(average_calories_page)

                        ListItemLayout {
                            title.text: i18n.tr("Average Calories Consumption")
                            title.font.weight: Font.DemiBold
                            title.color: app_style.label.labelColor
                            subtitle.text: i18n.tr("Monthly calorie intake overview")
                            subtitle.color: app_style.label.secondaryColor

                            Rectangle {
                                SlotsLayout.position: SlotsLayout.Leading
                                width: units.gu(4.2)
                                height: units.gu(4.2)
                                radius: units.gu(1)
                                color: app_style.shape.textInput.shapeColor

                                Image {
                                    anchors.centerIn: parent
                                    source: "../../assets/average_icon.svg"
                                    width: units.gu(2.8)
                                    height: units.gu(2.8)
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                }
                            }

                            ProgressionSlot {}
                        }
                    }

                    Rectangle {
                        width: parent.width - units.gu(4)
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: units.dp(1)
                        color: Qt.rgba(0.5, 0.5, 0.5, 0.12)
                    }

                    ListItem {
                        width: parent.width
                        divider.visible: false
                        onClicked: page_stack.push(graphs_page)

                        ListItemLayout {
                            title.text: i18n.tr("Charts")
                            title.font.weight: Font.DemiBold
                            title.color: app_style.label.labelColor
                            subtitle.text: i18n.tr("Weight progress and Nutri-Score distribution")
                            subtitle.color: app_style.label.secondaryColor

                            Rectangle {
                                SlotsLayout.position: SlotsLayout.Leading
                                width: units.gu(4.2)
                                height: units.gu(4.2)
                                radius: units.gu(1)
                                color: app_style.shape.textInput.shapeColor

                                Image {
                                    anchors.centerIn: parent
                                    source: "../../assets/graphs_icon.svg"
                                    width: units.gu(2.8)
                                    height: units.gu(2.8)
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                }
                            }

                            ProgressionSlot {}
                        }
                    }
                }
            }

            Item { width: 1; height: units.gu(1) }

            Label {
                x: units.gu(1)
                text: i18n.tr("BODY MEASUREMENTS")
                font.pixelSize: units.gu(1.3)
                font.weight: Font.DemiBold
                color: app_style.label.secondaryColor
            }

            LomiriShape {
                width: parent.width
                height: body_item.height
                radius: "large"
                aspect: LomiriShape.DropShadow
                backgroundColor: app_style.shape.shapeColor

                ListItem {
                    id: body_item
                    width: parent.width
                    divider.visible: false
                    onClicked: page_stack.push(body_measures_page)

                    ListItemLayout {
                        title.text: i18n.tr("Indexes")
                        title.font.weight: Font.DemiBold
                        title.color: app_style.label.labelColor
                        subtitle.text: i18n.tr("BMI, ideal weight and blood pressure")
                        subtitle.color: app_style.label.secondaryColor

                        Rectangle {
                            SlotsLayout.position: SlotsLayout.Leading
                            width: units.gu(4.2)
                            height: units.gu(4.2)
                            radius: units.gu(1)
                            color: app_style.shape.textInput.shapeColor

                            Image {
                                anchors.centerIn: parent
                                source: "../../assets/body_icon.svg"
                                width: units.gu(2.8)
                                height: units.gu(2.8)
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }
                        }

                        ProgressionSlot {}
                    }
                }
            }


            Item { width: 1; height: units.gu(1) }

            Label {
                x: units.gu(1)
                text: i18n.tr("AGENT ANALYSIS")
                font.pixelSize: units.gu(1.3)
                font.weight: Font.DemiBold
                color: app_style.label.secondaryColor
            }

            LomiriShape {
                width: parent.width
                height: agent_item.height
                radius: "large"
                aspect: LomiriShape.DropShadow
                backgroundColor: app_style.shape.shapeColor

                ListItem {
                    id: agent_item
                    width: parent.width
                    divider.visible: false
                    onClicked: {
                        if (data_analysis_page.isAnyAgentActive) {
                            page_stack.push(ai_agent);
                        } else {
                            PopupUtils.open(noAgentDialogComponent);
                        }
                    }

                    ListItemLayout {
                        title.text: i18n.tr("Ask Your Agent")
                        title.font.weight: Font.DemiBold
                        title.color: app_style.label.labelColor
                        subtitle.text: data_analysis_page.isAnyAgentActive
                                       ? i18n.tr("AI-powered nutrition insights")
                                       : i18n.tr("Not configured — tap to set up")
                        subtitle.color: data_analysis_page.isAnyAgentActive
                                        ? app_style.label.secondaryColor
                                        : app_style.nutrientsColors.fat

                        Rectangle {
                            SlotsLayout.position: SlotsLayout.Leading
                            width: units.gu(4.2)
                            height: units.gu(4.2)
                            radius: units.gu(1)
                            color: app_style.shape.textInput.shapeColor

                            Image {
                                anchors.centerIn: parent
                                source: "../../assets/ai-agent_icon.svg"
                                width: units.gu(2.8)
                                height: units.gu(2.8)
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }
                        }

                        ProgressionSlot {}
                    }
                }
            }
        }
    }
}
