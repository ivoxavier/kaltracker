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
import "../components"
import "../theme"

Page {
    id: menu_page
    objectName: 'MenuPage'

    header: PageHeader {
        title: i18n.tr("Menu")
    }

    BackgroundStyle {}

    Flickable {
        id: flickable
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
            topPadding: units.gu(2.5)
            bottomPadding: units.gu(4)
            spacing: units.gu(1.2)


            Column {
                width: parent.width
                spacing: units.gu(1)
                bottomPadding: units.gu(1.5)

                LomiriShape {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: units.gu(8.5)
                    height: units.gu(8.5)
                    radius: "large"
                    aspect: LomiriShape.DropShadow
                    source: Image {
                        source: "../../assets/logo.svg"
                        smooth: true
                    }
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "KalTracker"
                    font.pixelSize: units.gu(2.2)
                    font.weight: Font.DemiBold
                    color: app_style.label.labelColor
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: units.gu(2.8)
                    width: version_label.implicitWidth + units.gu(2.2)
                    radius: height / 2
                    color: app_style.shape.textInput.shapeColor

                    Label {
                        id: version_label
                        anchors.centerIn: parent
                        text: i18n.tr("Version %1").arg(Qt.application.version)
                        font.pixelSize: units.gu(1.3)
                        font.weight: Font.DemiBold
                        color: app_style.label.secondaryColor
                    }
                }
            }


            Label {
                x: units.gu(1)
                text: i18n.tr("USER")
                font.pixelSize: units.gu(1.3)
                font.weight: Font.DemiBold
                color: app_style.label.secondaryColor
            }

            LomiriShape {
                width: parent.width
                height: user_col.height
                radius: "large"
                aspect: LomiriShape.DropShadow
                backgroundColor: app_style.shape.shapeColor

                Column {
                    id: user_col
                    width: parent.width

                    ListItem {
                        width: parent.width
                        divider.visible: false
                        onClicked: page_stack.push(user_profile_config_page, { "isUpdateMode": true })

                        ListItemLayout {
                            title.text: i18n.tr("Your Profile")
                            title.font.weight: Font.DemiBold
                            title.color: app_style.label.labelColor
                            subtitle.text: i18n.tr("Personal data and nutrition goals")
                            subtitle.color: app_style.label.secondaryColor

                            Rectangle {
                                SlotsLayout.position: SlotsLayout.Leading
                                width: units.gu(4)
                                height: units.gu(4)
                                radius: units.gu(1)
                                color: app_style.shape.textInput.shapeColor

                                Icon {
                                    anchors.centerIn: parent
                                    name: "account"
                                    width: units.gu(2.3)
                                    height: units.gu(2.3)
                                    color: app_style.button.confirmButton.buttonColor
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
                        onClicked: page_stack.push(data_analysis_page)

                        ListItemLayout {
                            title.text: i18n.tr("Data Analysis")
                            title.font.weight: Font.DemiBold
                            title.color: app_style.label.labelColor
                            subtitle.text: i18n.tr("Graphs, BMI and body measures")
                            subtitle.color: app_style.label.secondaryColor

                            Rectangle {
                                SlotsLayout.position: SlotsLayout.Leading
                                width: units.gu(4)
                                height: units.gu(4)
                                radius: units.gu(1)
                                color: app_style.shape.textInput.shapeColor

                                Icon {
                                    anchors.centerIn: parent
                                    name: "x-office-presentation-symbolic"
                                    width: units.gu(2.3)
                                    height: units.gu(2.3)
                                    color: app_style.button.confirmButton.buttonColor
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
                text: i18n.tr("SETTINGS")
                font.pixelSize: units.gu(1.3)
                font.weight: Font.DemiBold
                color: app_style.label.secondaryColor
            }

            LomiriShape {
                width: parent.width
                height: settings_col.height
                radius: "large"
                aspect: LomiriShape.DropShadow
                backgroundColor: app_style.shape.shapeColor

                Column {
                    id: settings_col
                    width: parent.width

                    ListItem {
                        width: parent.width
                        divider.visible: false
                        onClicked: page_stack.push(settings_page)

                        ListItemLayout {
                            title.text: i18n.tr("App Settings")
                            title.font.weight: Font.DemiBold
                            title.color: app_style.label.labelColor
                            subtitle.text: i18n.tr("Preferences, animations and features")
                            subtitle.color: app_style.label.secondaryColor

                            Rectangle {
                                SlotsLayout.position: SlotsLayout.Leading
                                width: units.gu(4)
                                height: units.gu(4)
                                radius: units.gu(1)
                                color: app_style.shape.textInput.shapeColor

                                Icon {
                                    anchors.centerIn: parent
                                    name: "settings"
                                    width: units.gu(2.3)
                                    height: units.gu(2.3)
                                    color: app_style.button.actionButton.buttonColor
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
                        onClicked: page_stack.push(online_sources_page)

                        ListItemLayout {
                            title.text: i18n.tr("Online Sources")
                            title.font.weight: Font.DemiBold
                            title.color: app_style.label.labelColor
                            subtitle.text: i18n.tr("Open Food Facts and external APIs")
                            subtitle.color: app_style.label.secondaryColor

                            Rectangle {
                                SlotsLayout.position: SlotsLayout.Leading
                                width: units.gu(4)
                                height: units.gu(4)
                                radius: units.gu(1)
                                color: app_style.shape.textInput.shapeColor

                                Icon {
                                    anchors.centerIn: parent
                                    name: "stock_website"
                                    width: units.gu(2.3)
                                    height: units.gu(2.3)
                                    color: app_style.button.actionButton.buttonColor
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
                text: i18n.tr("STORAGE")
                font.pixelSize: units.gu(1.3)
                font.weight: Font.DemiBold
                color: app_style.label.secondaryColor
            }

            LomiriShape {
                width: parent.width
                height: storage_col.height
                radius: "large"
                aspect: LomiriShape.DropShadow
                backgroundColor: app_style.shape.shapeColor

                Column {
                    id: storage_col
                    width: parent.width

                    ListItem {
                        width: parent.width
                        divider.visible: false
                        onClicked: page_stack.push(manage_data_page)

                        ListItemLayout {
                            title.text: i18n.tr("Manage Data")
                            title.font.weight: Font.DemiBold
                            title.color: app_style.label.labelColor
                            subtitle.text: i18n.tr("Clean old records and manage database")
                            subtitle.color: app_style.label.secondaryColor

                            Rectangle {
                                SlotsLayout.position: SlotsLayout.Leading
                                width: units.gu(4)
                                height: units.gu(4)
                                radius: units.gu(1)
                                color: app_style.shape.textInput.shapeColor

                                Icon {
                                    anchors.centerIn: parent
                                    name: "drive-harddisk-symbolic"
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
                        onClicked: page_stack.push(backup_restore_page)

                        ListItemLayout {
                            title.text: i18n.tr("Backup & Restore Data")
                            title.font.weight: Font.DemiBold
                            title.color: app_style.label.labelColor
                            subtitle.text: i18n.tr("Export or restore your local data")
                            subtitle.color: app_style.label.secondaryColor

                            Rectangle {
                                SlotsLayout.position: SlotsLayout.Leading
                                width: units.gu(4)
                                height: units.gu(4)
                                radius: units.gu(1)
                                color: app_style.shape.textInput.shapeColor

                                Icon {
                                    anchors.centerIn: parent
                                    name: "document-save"
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
                text: i18n.tr("ABOUT")
                font.pixelSize: units.gu(1.3)
                font.weight: Font.DemiBold
                color: app_style.label.secondaryColor
            }

            LomiriShape {
                width: parent.width
                height: about_item.height
                radius: "large"
                aspect: LomiriShape.DropShadow
                backgroundColor: app_style.shape.shapeColor

                ListItem {
                    id: about_item
                    width: parent.width
                    divider.visible: false
                    onClicked: page_stack.push(third_party_software_page)

                    ListItemLayout {
                        title.text: i18n.tr("Third Party Software")
                        title.font.weight: Font.DemiBold
                        title.color: app_style.label.labelColor
                        subtitle.text: i18n.tr("Open-source licenses and credits")
                        subtitle.color: app_style.label.secondaryColor

                        Rectangle {
                            SlotsLayout.position: SlotsLayout.Leading
                            width: units.gu(4)
                            height: units.gu(4)
                            radius: units.gu(1)
                            color: app_style.shape.textInput.shapeColor

                            Icon {
                                anchors.centerIn: parent
                                name: "text-css-symbolic"
                                width: units.gu(2.3)
                                height: units.gu(2.3)
                                color: app_style.label.secondaryColor
                            }
                        }

                        ProgressionSlot {}
                    }
                }
            }
        }
    }
}
