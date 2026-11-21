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
                deleteAction();
                root.initDB();
                PopupUtils.open(operation_result_popover);
            }
        });
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
                        onClicked: app_settings.is_auto_cleaning = !app_settings.is_auto_cleaning

                        ListItemLayout {
                            title.text: i18n.tr("Auto Delete Ingestions")
                            title.font.weight: Font.DemiBold
                            title.color: app_style.label.labelColor
                            subtitle.text: i18n.tr("Deletes all previous year ingestions")
                            subtitle.color: app_style.label.secondaryColor

                            Rectangle {
                                SlotsLayout.position: SlotsLayout.Leading
                                width: units.gu(4)
                                height: units.gu(4)
                                radius: units.gu(1)
                                color: app_style.shape.textInput.shapeColor

                                Icon {
                                    anchors.centerIn: parent
                                    name: "smartwatch-symbolic"
                                    width: units.gu(2.3)
                                    height: units.gu(2.3)
                                    color: app_style.button.actionButton.buttonColor
                                }
                            }

                            Switch {
                                SlotsLayout.position: SlotsLayout.Trailing
                                checked: app_settings.is_auto_cleaning
                                onClicked: app_settings.is_auto_cleaning = !app_settings.is_auto_cleaning
                            }
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
                        onClicked: PopupUtils.open(delete_month_year_dialog)

                        ListItemLayout {
                            title.text: i18n.tr("From a Month & To Year")
                            title.font.weight: Font.DemiBold
                            title.color: app_style.label.labelColor
                            subtitle.text: i18n.tr("Remove ingestions by date range")
                            subtitle.color: app_style.label.secondaryColor

                            Rectangle {
                                SlotsLayout.position: SlotsLayout.Leading
                                width: units.gu(4)
                                height: units.gu(4)
                                radius: units.gu(1)
                                color: app_style.shape.textInput.shapeColor

                                Icon {
                                    anchors.centerIn: parent
                                    name: "calendar-app-symbolic"
                                    width: units.gu(2.3)
                                    height: units.gu(2.3)
                                    color: app_style.nutrientsColors.fat
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
                        onClicked: page_stack.push(delete_today_ingestion_page)

                        ListItemLayout {
                            title.text: i18n.tr("Specific Today's Ingestion")
                            title.font.weight: Font.DemiBold
                            title.color: app_style.label.labelColor
                            subtitle.text: i18n.tr("Pick individual items to remove")
                            subtitle.color: app_style.label.secondaryColor

                            Rectangle {
                                SlotsLayout.position: SlotsLayout.Leading
                                width: units.gu(4)
                                height: units.gu(4)
                                radius: units.gu(1)
                                color: app_style.shape.textInput.shapeColor

                                Icon {
                                    anchors.centerIn: parent
                                    name: "view-list-symbolic"
                                    width: units.gu(2.3)
                                    height: units.gu(2.3)
                                    color: app_style.nutrientsColors.fat
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
                text: i18n.tr("USER FOODS LIST")
                font.pixelSize: units.gu(1.3)
                font.weight: Font.DemiBold
                color: app_style.label.secondaryColor
            }

            LomiriShape {
                width: parent.width
                height: foods_item.height
                radius: "large"
                aspect: LomiriShape.DropShadow
                backgroundColor: app_style.shape.shapeColor

                ListItem {
                    id: foods_item
                    width: parent.width
                    divider.visible: false
                    onClicked: page_stack.push(manager_user_foods_list_page)

                    ListItemLayout {
                        title.text: i18n.tr("User Created Foods List")
                        title.font.weight: Font.DemiBold
                        title.color: app_style.label.labelColor
                        subtitle.text: i18n.tr("Edit or delete your custom foods")
                        subtitle.color: app_style.label.secondaryColor

                        Rectangle {
                            SlotsLayout.position: SlotsLayout.Leading
                            width: units.gu(4)
                            height: units.gu(4)
                            radius: units.gu(1)
                            color: app_style.shape.textInput.shapeColor

                            Icon {
                                anchors.centerIn: parent
                                name: "x-office-document-symbolic"
                                width: units.gu(2.3)
                                height: units.gu(2.3)
                                color: app_style.button.confirmButton.buttonColor
                            }
                        }

                        ProgressionSlot {}
                    }
                }
            }
            Item { width: 1; height: units.gu(1) }

            Label {
                x: units.gu(1)
                text: i18n.tr("CLEAR RECORDS")
                font.pixelSize: units.gu(1.3)
                font.weight: Font.DemiBold
                color: app_style.button.deleteButton.buttonColor
            }

            LomiriShape {
                width: parent.width
                height: danger_col.height
                radius: "large"
                aspect: LomiriShape.DropShadow
                backgroundColor: app_style.shape.shapeColor

                Column {
                    id: danger_col
                    width: parent.width

                    ListItem {
                        width: parent.width
                        divider.visible: false

                        ListItemLayout {
                            title.text: i18n.tr("Today's Ingestions")
                            title.font.weight: Font.DemiBold
                            title.color: app_style.label.labelColor
                            subtitle.text: i18n.tr("Clear all meals logged today")
                            subtitle.color: app_style.label.secondaryColor

                            Button {
                                SlotsLayout.position: SlotsLayout.Trailing
                                width: units.gu(10)
                                text: i18n.tr("Delete")
                                color: app_style.button.deleteButton.buttonColor
                                onClicked: {
                                    delete_type = 0;
                                    PopupUtils.open(delete_dialog);
                                }
                            }
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

                        ListItemLayout {
                            title.text: i18n.tr("All Ingestions")
                            title.font.weight: Font.DemiBold
                            title.color: app_style.label.labelColor
                            subtitle.text: i18n.tr("Permanently remove entire history")
                            subtitle.color: app_style.label.secondaryColor

                            Button {
                                SlotsLayout.position: SlotsLayout.Trailing
                                width: units.gu(10)
                                text: i18n.tr("Delete")
                                color: app_style.button.deleteButton.buttonColor
                                onClicked: {
                                    delete_type = 1;
                                    PopupUtils.open(delete_dialog);
                                }
                            }
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

                        ListItemLayout {
                            title.text: i18n.tr("Water Records")
                            title.font.weight: Font.DemiBold
                            title.color: app_style.label.labelColor
                            subtitle.text: i18n.tr("Clear all hydration history")
                            subtitle.color: app_style.label.secondaryColor

                            Button {
                                SlotsLayout.position: SlotsLayout.Trailing
                                width: units.gu(10)
                                text: i18n.tr("Delete")
                                color: app_style.button.deleteButton.buttonColor
                                onClicked: openDeleteDialog(
                                    i18n.tr("Delete Water Records"),
                                    function() { dataAnalysisRepository.deleteAllWaterTracker(); }
                                )
                            }
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

                        ListItemLayout {
                            title.text: i18n.tr("Notes")
                            title.font.weight: Font.DemiBold
                            title.color: app_style.label.labelColor
                            subtitle.text: i18n.tr("Delete all saved notes")
                            subtitle.color: app_style.label.secondaryColor

                            Button {
                                SlotsLayout.position: SlotsLayout.Trailing
                                width: units.gu(10)
                                text: i18n.tr("Delete")
                                color: app_style.button.deleteButton.buttonColor
                                onClicked: openDeleteDialog(
                                    i18n.tr("Delete Notes"),
                                    function() { notesRepository.deleteAllNotes(); }
                                )
                            }
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

                        ListItemLayout {
                            title.text: i18n.tr("Weight Tracker")
                            title.font.weight: Font.DemiBold
                            title.color: app_style.label.labelColor
                            subtitle.text: i18n.tr("Delete all weight records")
                            subtitle.color: app_style.label.secondaryColor

                            Button {
                                SlotsLayout.position: SlotsLayout.Trailing
                                width: units.gu(10)
                                text: i18n.tr("Delete")
                                color: app_style.button.deleteButton.buttonColor
                                onClicked: openDeleteDialog(
                                    i18n.tr("Delete Weight Tracker Records"),
                                    function() {
                                        dataAnalysisRepository.deleteAllWeightTracker();
                                        app_settings.is_weight_tracker_chart_enabled = false;
                                    }
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}
