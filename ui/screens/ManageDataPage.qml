/*
 * 2022-2026  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 */

import QtQuick 2.9
import Lomiri.Components 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3
import Lomiri.Components.Popups 1.3
import "../components"
import "../theme"

Page {
    id: manage_data_page
    objectName: 'ManageDataPage'

    header: PageHeader {
        title: i18n.tr("Manage Data")
    }

    BackgroundStyle {}

    // to differentiate from deletion type
    property int delete_type

    Component {
        id: delete_dialog
        RemoveRecordsDialog { msg: delete_type == 0 ? "today" : "all" }
    }

    Component {
        id: delete_month_year_dialog
        DeleteByMonthPop {}
    }

    Component {
        id: confirm_delete_dialog
        ConfirmDeleteDialog {}
    }

    Component {
        id: operation_result_popover
        OperationResultPopOver {}
    }

    function openDeleteDialog(dialogTitle, deleteAction) {
        PopupUtils.open(confirm_delete_dialog, null, {
            "title": dialogTitle,
            "onConfirm": function() {
                deleteAction()
                root.initDB()
                PopupUtils.open(operation_result_popover)
            }
        })
    }

    Flickable {
        anchors {
            top: parent.header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentWidth: parent.width
        contentHeight: main_column.height + units.gu(4)
        clip: true

        Column {
            id: main_column
            width: parent.width

            ListItemHeader {
                text_header.title.text: i18n.tr("Ingestions")
                divider.visible: false
            }

            ListItem {
                divider.visible: false
                ListItemLayout {
                    title.text: i18n.tr("Auto Delete Ingestions")
                    subtitle.text: i18n.tr("Deletes All Previous Year Ingestions")

                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading
                        name: "smartwatch-symbolic"
                        height: units.gu(3.5)
                    }

                    Switch {
                        checked: app_settings.is_auto_cleaning
                        onClicked: app_settings.is_auto_cleaning = !app_settings.is_auto_cleaning
                    }
                }
            }

            ListItem {
                divider.visible: false
                ListItemLayout {
                    title.text: i18n.tr("From a Month & To Year")
                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading
                        name: "calendar-app-symbolic"
                        height: units.gu(3.5)
                    }
                    ProgressionSlot {}
                }
                onClicked: PopupUtils.open(delete_month_year_dialog)
            }

            ListItem {
                divider.visible: false
                ListItemLayout {
                    title.text: i18n.tr("Specific Today's Ingestion")

                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading
                        name: "view-list-symbolic"
                        height: units.gu(3.5)
                    }

                    ProgressionSlot {}
                }
                onClicked: page_stack.push(delete_today_ingestion_page)
            }

            ListItem {
                divider.visible: false
                ListItemLayout {
                    title.text: i18n.tr("Only Today's Ingestions")

                    Button {
                        text: i18n.tr("Delete")
                        color: LomiriColors.red
                        onClicked: {
                            delete_type = 0
                            PopupUtils.open(delete_dialog)
                        }
                    }
                }
            }

            ListItem {
                divider.visible: false
                ListItemLayout {
                    title.text: i18n.tr("All Ingestions")

                    Button {
                        text: i18n.tr("Delete")
                        color: LomiriColors.red
                        onClicked: {
                            delete_type = 1
                            PopupUtils.open(delete_dialog)
                        }
                    }
                }
            }

            ListItemHeader {
                text_header.title.text: i18n.tr("User Foods List")
                divider.visible: false
            }

            ListItem {
                divider.visible: false
                ListItemLayout {
                    title.text: i18n.tr("User Created Foods List")
                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading
                        name: "x-office-document-symbolic"
                        height: units.gu(3.5)
                    }
                    ProgressionSlot {}
                }
                onClicked: page_stack.push(manager_user_foods_list_page)
            }

            ListItemHeader {
                text_header.title.text: i18n.tr("Water")
                divider.visible: false
            }

            ListItem {
                divider.visible: false
                ListItemLayout {
                    title.text: i18n.tr("All Water Records")

                    Button {
                        text: i18n.tr("Delete")
                        color: LomiriColors.red
                        onClicked: openDeleteDialog(
                            i18n.tr("Delete Water Records"),
                            function() { dataAnalysisRepository.deleteAllWaterTracker() }
                        )
                    }
                }
            }

            ListItemHeader {
                text_header.title.text: i18n.tr("Notes")
                divider.visible: false
            }

            ListItem {
                divider.visible: false
                ListItemLayout {
                    title.text: i18n.tr("Delete All Notes")

                    Button {
                        text: i18n.tr("Delete")
                        color: LomiriColors.red
                        onClicked: openDeleteDialog(
                            i18n.tr("Delete Notes"),
                            function() { notesRepository.deleteAllNotes() }
                        )
                    }
                }
            }

            ListItemHeader {
                text_header.title.text: i18n.tr("Weight Tracker")
                divider.visible: false
            }

            ListItem {
                divider.visible: false
                ListItemLayout {
                    title.text: i18n.tr("All Records")

                    Button {
                        text: i18n.tr("Delete")
                        color: LomiriColors.red
                        onClicked: openDeleteDialog(
                            i18n.tr("Delete Weight Tracker Records"),
                            function() {
                                dataAnalysisRepository.deleteAllWeightTracker()
                                app_settings.is_weight_tracker_chart_enabled = false
                            }
                        )
                    }
                }
            }
        }
    }
}
