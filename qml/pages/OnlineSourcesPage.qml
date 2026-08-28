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
import "../components"
import "../style"

Page {
    id: api_page
    objectName: 'ApiPage'
    
    header: PageHeader {        
        title: i18n.tr("Aplication Programming Interface")
    }

    BackgroundStyle {}

    Component {
        id: agentsDialogComponent
        
        Dialog {
            id: agentsDialog
            title: i18n.tr("Manage AI Agents")

            Flickable {
                width: parent.width
                height: Math.min(dialogContent.height, units.gu(40))
                contentWidth: parent.width
                contentHeight: dialogContent.height
                clip: true

                Column {
                    id: dialogContent
                    width: parent.width
                    spacing: units.gu(3)

                    Repeater {
                        id: agentsRepeater
                        model: ["Gemini"] // add other models once backend is develop
                        
                        delegate: Column {
                            width: parent.width
                            spacing: units.gu(1)

                            
                            property alias agentSwitch: toggleSwitch
                            property alias modelField: modelInput
                            property alias keyField: keyInput

                            RowLayout {
                                width: parent.width
                                
                                Label {
                                    text: modelData
                                    Layout.fillWidth: true
                                    color: app_style.label.labelColor
                                }
                                
                                Switch {
                                    id: toggleSwitch
                                    
                                    checked: app_settings["is_agent_" + modelData.toLowerCase() + "_enabled"]
                                }
                            }
                            
                            TextField {
                                id: modelInput
                                width: parent.width
                                placeholderText: i18n.tr("Model version (e.g. gemini-1.5-flash)")
                        
                                text: app_settings["agent_" + modelData.toLowerCase() + "_model"] || ""
                            }

                            TextField {
                                id: keyInput
                                width: parent.width
                                placeholderText: i18n.tr("Enter %1 API Key").arg(modelData)
                                echoMode: TextInput.Password 
                            
                                text: app_settings["agent_" + modelData.toLowerCase() + "_key"] || ""
                            }
                        }
                    }
                }
            }

            Button {
                text: i18n.tr("Save")
                color: theme.palette.normal.focus
                onClicked: {
                    for (var i = 0; i < agentsRepeater.count; i++) {
                        var delegateItem = agentsRepeater.itemAt(i);
                        var agentName = agentsRepeater.model[i].toLowerCase();

                        app_settings["is_agent_" + agentName + "_enabled"] = delegateItem.agentSwitch.checked;
                        app_settings["agent_" + agentName + "_model"] = delegateItem.modelField.text;
                        app_settings["agent_" + agentName + "_key"] = delegateItem.keyField.text;
                    }
                    PopupUtils.close(agentsDialog)
                }
            }
            
            Button {
                text: i18n.tr("Cancel")
                onClicked: {
                    PopupUtils.close(agentsDialog)
                }
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
                text_header.title.text: i18n.tr("Application Programming Interface")
                divider.visible: false
            }

            ListItem {
                divider.visible: false
                ListItemLayout {
                    title.text: i18n.tr("OpenFoodsFacts")
                    title.color: app_style.label.labelColor
                    subtitle.text: i18n.tr("Search For Barcode In %1").arg("openfoodsfacts")
                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading
                        source: "../../assets/mangifying_glass_barcodes.svg"
                        height: units.gu(3.5)
                    }

                    Switch {
                        checked: app_settings.is_api_openfoodsfacts_enabled
                        onClicked: app_settings.is_api_openfoodsfacts_enabled = !app_settings.is_api_openfoodsfacts_enabled
                    }
                }  
            }

            ListItemHeader {
                text_header.title.text: i18n.tr("AI Agents")
                divider.visible: false
            }

            ListItem {
                divider.visible: false
                ListItemLayout {
                    title.text: i18n.tr("Agents Keys")
                    title.color: app_style.label.labelColor
                    subtitle.text: i18n.tr("Manage Your Agents Keys")
                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading
                        source: "../../assets/ai-agent_icon.svg"
                        height: units.gu(3.5)
                    }

                    ProgressionSlot {}
                }  
                onClicked: {
                    PopupUtils.open(agentsDialogComponent)
                }
            }
        }  
    }
}