/*
 * 2022-2026  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 */

import QtQuick 2.9
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import Lomiri.Content 1.3
import "../components"
import "../style"
import "../../js/UserTable.js" as UserTable

Page {
    id: data_analysis_page
    objectName: 'DataAnalysisPage'
    
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
                text: i18n.tr("Close")
                color: theme.palette.normal.focus
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

        contentWidth: parent.width
        contentHeight: main_column.height  

        interactive: root.height > root.width ? false : true
        
        ColumnLayout {
            id: main_column
            width: root.width
            
            ListItemHeader {
                text_header.title.text: i18n.tr("Ingestions")
                divider.visible: false
            }

            ListItem {
                ListItemLayout {
                    title.text: i18n.tr("Average Calories Consumption")
                    subtitle.text: i18n.tr("By Month")
                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading
                        source: "../../assets/average_icon.svg"
                        height: units.gu(3.8)
                    }
                    ProgressionSlot {}
                }
                onClicked: page_stack.push(average_calories_page)
            }

            ListItem {
                ListItemLayout {
                    title.text: i18n.tr("Charts")
                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading
                        source: "../../assets/graphs_icon.svg"
                        height: units.gu(3.8)
                    }
                    ProgressionSlot {}
                }
                onClicked: page_stack.push(graphs_page)
            }

            ListItemHeader {
                text_header.title.text: i18n.tr("Body Measurements")
                divider.visible: false
            }

            ListItem {
                ListItemLayout {
                    title.text: i18n.tr("Indexes")
                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading
                        source: "../../assets/body_icon.svg"
                        height: units.gu(3.8)
                    }
                    ProgressionSlot {}
                }
                onClicked: page_stack.push(body_measures_page)
            }

        
            ListItemHeader {
                text_header.title.text: i18n.tr("Agent Analysis")
                divider.visible: false
            }

            ListItem {
                ListItemLayout {
                    title.text: i18n.tr("Ask Your Agent")
                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading
                        source: "../../assets/ai-agent_icon.svg"
                        height: units.gu(3.8)
                    }
                    ProgressionSlot {}
                }
                onClicked: {
                    
                    var isAnyAgentActive = app_settings.is_agent_gemini_enabled || 
                                           app_settings.is_agent_chatgpt_enabled || 
                                           app_settings.is_agent_claude_enabled;
                    
                    if (isAnyAgentActive) {
                        page_stack.push(ai_agent);
                    } else {
                    
                        PopupUtils.open(noAgentDialogComponent);
                    }
                }
            }
        }
    }   
}