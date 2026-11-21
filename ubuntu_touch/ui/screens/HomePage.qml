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
import QtQuick.Layouts 1.3
import Lomiri.Components.Popups 1.3
import ChatSupport 0.1
import "../components"
import "../theme"
import "../logicalFields"

Page {
    id: home_page
    objectName: 'HomePage'
    header: PageHeader { visible: false }

    BackgroundStyle {}

    property int updateTrigger: 0

    // stores the amount of days user wants to get back to (re)ingest
    property int amount_of_days_back: 1

    ListModel { id: filtered_meal_model }

    function getGradeColor(grade) {
        var g = String(grade).toLowerCase();
        if (g === 'a' || g === '1') return "green";
        if (g === 'b' || g === '2') return "#09b227";
        if (g === 'c' || g === '3') return "#cba000";
        if (g === 'd' || g === '4') return "#e57a01";
        if (g === 'e') return LomiriColors.red;
        return "black";
    }

    function updateDashboardData() {
        var currentDate = logical_fields.application.date_utils.long_date;

        logical_fields.user_profile.plan.cal_consumed = ingestionRepository.getTotalCalConsumed(currentDate);
        logical_fields.user_profile.plan.cal_remaining = ingestionRepository.getTotalCalRemaining(currentDate);
        logical_fields.metrics.total_foods_consumed = ingestionRepository.getTotalFoodsConsumed(currentDate);
        logical_fields.metrics.total_cal_breakfast = ingestionRepository.getMealCalories(currentDate, 0);
        logical_fields.metrics.total_cal_lunch = ingestionRepository.getMealCalories(currentDate, 1);
        logical_fields.metrics.total_cal_dinner = ingestionRepository.getMealCalories(currentDate, 2);
        logical_fields.metrics.total_cal_snacks = ingestionRepository.getMealCalories(currentDate, 3);
        logical_fields.metrics.total_carbo_consumed = ingestionRepository.getMacroConsumed(currentDate, "carbo");
        logical_fields.metrics.total_fat_consumed = ingestionRepository.getMacroConsumed(currentDate, "fat");
        logical_fields.metrics.total_protein_consumed = ingestionRepository.getMacroConsumed(currentDate, "protein");
        logical_fields.metrics.total_water_cups = dataAnalysisRepository.getCups(currentDate);

        console.log("Dashboard atualizado -> Kcal:", logical_fields.user_profile.plan.cal_consumed,
                    "Foods:", logical_fields.metrics.total_foods_consumed,
                    "Water:", logical_fields.metrics.total_water_cups);
        home_page.updateTrigger += 1;
    }

    Connections {
        target: root
        onInitDB: updateDashboardData()
    }

    Component {
        id: date_popUP
        DateNavigation {}
    }

    Component {
        id: add_note_dialog
        AddNoteDialog {}
    }

    Component {
        id: operation_sucess
        MessageDialog {
            msg: i18n.tr("Ingestion Saved!")
        }
    }

    Component {
        id: notification_pop
        NotifyAutoCleanPop {}
    }

    ChatSupport {
        id: chat_auth
        Component.onCompleted: {
            if (app_settings.is_chat_support_enabled) {
                chat_auth.verifySession();
            }
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: width
        contentHeight: main_column.height + units.gu(8)
        clip: true

        Column {
            id: main_column
            width: parent.width - units.gu(4)
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: units.gu(1.5)
            spacing: units.gu(1.5)


            RowLayout {
                width: parent.width
                spacing: units.gu(1.5)

                Item { Layout.fillWidth: true }

                Icon {
                    id: chat_icon
                    visible: app_settings.is_chat_support_enabled
                    source: "../../assets/chat-support_icon.svg"
                    Layout.preferredHeight: units.gu(3.2)
                    Layout.preferredWidth: units.gu(3.2)

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -units.gu(0.5)
                        onClicked: {
                            if (chat_auth.isAdmin) {
                                page_stack.push(Qt.resolvedUrl("AdminChatsPage.qml"));
                            } else {
                                page_stack.push(Qt.resolvedUrl("ChatRoomPage.qml"), {
                                    "targetUserEmail": chat_auth.currentEmail,
                                    "targetUsername": i18n.tr("KalTracker Team"),
                                    "myEmail": chat_auth.currentEmail
                                });
                            }
                        }
                    }
                }

                Icon {
                    name: "navigation-menu"
                    Layout.preferredHeight: units.gu(3.2)
                    Layout.preferredWidth: units.gu(3.2)
                    color: app_style.label.labelColor

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -units.gu(0.5)
                        onClicked: page_stack.push(menu_page)
                    }
                }
            }

            LomiriShape {
                width: parent.width
                height: hero_col.height + units.gu(4)
                radius: "large"
                aspect: LomiriShape.DropShadow
                backgroundColor: app_style.shape.shapeColor

                Rectangle {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: units.gu(1.5)
                    width: units.gu(4)
                    height: units.gu(4)
                    radius: width / 2
                    color: app_style.shape.textInput.shapeColor
                    z: 2

                    Icon {
                        anchors.centerIn: parent
                        name: "attachment"
                        width: units.gu(2.2)
                        height: units.gu(2.2)
                        color: app_style.label.labelColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: PopupUtils.open(add_note_dialog)
                    }
                }

                Column {
                    id: hero_col
                    width: parent.width - units.gu(3)
                    anchors.centerIn: parent
                    spacing: units.gu(2)


                    CaloriesCircleChart {
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    RowLayout {
                        width: parent.width
                        spacing: units.gu(1.5)

                        SlotDashboardIndicators {
                            Layout.fillWidth: true
                            Layout.preferredHeight: units.gu(5)
                            slot_indicatior: logical_fields.metrics.total_foods_consumed
                            // TRANSLATORS Please Keep This Only One Word
                            slot_icon_label: i18n.tr("FOODS")
                        }

                        Rectangle {
                            Layout.preferredWidth: units.dp(1)
                            Layout.preferredHeight: units.gu(4)
                            color: Qt.rgba(0.5, 0.5, 0.5, 0.18)
                        }

                        SlotDashboardIndicators {
                            Layout.fillWidth: true
                            Layout.preferredHeight: units.gu(5)
                            slot_indicatior: logical_fields.user_profile.plan.cal_consumed
                            // TRANSLATORS Please Keep This Only One Word
                            slot_icon_label: i18n.tr("CONSUMED")
                        }
                    }


                    Rectangle {
                        width: parent.width
                        height: units.dp(1)
                        color: Qt.rgba(0.5, 0.5, 0.5, 0.15)
                    }

                    RowLayout {
                        width: parent.width
                        spacing: units.gu(1.5)

                        SlotNutrientProgress {
                            Layout.fillWidth: true
                            Layout.preferredHeight: units.gu(5)
                            // TRANSLATORS Please Keep This Only One Word
                            slot_icon_label: i18n.tr("FAT")
                            bar_color: app_style.progressBar.nutrientBar.fatProgress
                            nutrient_value: (logical_fields.metrics.total_fat_consumed / userRepository.getMacroFat(app_settings.plan_type) * 100.0) * 0.01
                        }

                        SlotNutrientProgress {
                            Layout.fillWidth: true
                            Layout.preferredHeight: units.gu(5)
                            // TRANSLATORS Please Keep This Only One Word
                            slot_icon_label: i18n.tr("CARBO")
                            bar_color: app_style.progressBar.nutrientBar.carbProgress
                            nutrient_value: (logical_fields.metrics.total_carbo_consumed / userRepository.getMacroCarbo(app_settings.plan_type) * 100.0) * 0.01
                        }

                        SlotNutrientProgress {
                            Layout.fillWidth: true
                            Layout.preferredHeight: units.gu(5)
                            // TRANSLATORS Please Keep This Only One Word
                            slot_icon_label: i18n.tr("PROTEIN")
                            bar_color: app_style.progressBar.nutrientBar.proteinProgress
                            nutrient_value: (logical_fields.metrics.total_protein_consumed / userRepository.getMacroProtein(app_settings.plan_type) * 100.0) * 0.01
                        }
                    }
                }
            }


            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: units.gu(1)

                Icon {
                    id: calendar_icon
                    Layout.alignment: Qt.AlignVCenter
                    name: "calendar-app-symbolic"
                    height: units.gu(3)
                    width: units.gu(3)
                    color: app_style.label.secondaryColor
                }

                Label {
                    id: dateLabel
                    Layout.alignment: Qt.AlignVCenter
                    text: logical_fields.application.date_utils.long_date
                    font.pixelSize: units.gu(1.9)
                    font.weight: Font.DemiBold
                    color: app_style.label.labelColor
                }

                Icon {
                    id: icon_down
                    Layout.alignment: Qt.AlignVCenter
                    property bool is_clicked: false
                    name: "go-up"
                    height: units.gu(3.2)
                    width: units.gu(3.2)
                    color: app_style.label.secondaryColor
                    rotation: icon_down.is_clicked ? 180 : 0
                    Behavior on rotation {
                        LomiriNumberAnimation {}
                    }
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -units.gu(0.5)
                        onClicked: {
                            icon_down.is_clicked = !icon_down.is_clicked;
                            PopupUtils.open(date_popUP, dateLabel);
                        }
                    }
                }
            }


            SlotAddMeal {
                width: parent.width
                height: units.gu(7.5)
                title.text: i18n.tr("Breakfast")
                meal_category: 0
                // TRANSLATORS %1 is a format parameter. When translating make sure you write %1
                subtitle.text: i18n.tr("%1 calories").arg((home_page.updateTrigger * 0) + logical_fields.metrics.total_cal_breakfast)
                img_path: "../../assets/breakfast-svgrepo-com.svg"
            }

            SlotAddMeal {
                width: parent.width
                height: units.gu(7.5)
                title.text: i18n.tr("Lunch")
                meal_category: 1
                // TRANSLATORS %1 is a format parameter. When translating make sure you write %1
                subtitle.text: i18n.tr("%1 calories").arg((home_page.updateTrigger * 0) + logical_fields.metrics.total_cal_lunch)
                img_path: "../../assets/fried-chicken-meal-svgrepo-com.svg"
            }

            SlotAddMeal {
                width: parent.width
                height: units.gu(7.5)
                title.text: i18n.tr("Dinner")
                meal_category: 2
                // TRANSLATORS %1 is a format parameter. When translating make sure you write %1
                subtitle.text: i18n.tr("%1 calories").arg((home_page.updateTrigger * 0) + logical_fields.metrics.total_cal_dinner)
                img_path: "../../assets/dinner-svgrepo-com.svg"
            }

            SlotAddMeal {
                width: parent.width
                height: units.gu(7.5)
                title.text: i18n.tr("Snacks")
                meal_category: 3
                // TRANSLATORS %1 is a format parameter. When translating make sure you write %1
                subtitle.text: i18n.tr("%1 calories").arg((home_page.updateTrigger * 0) + logical_fields.metrics.total_cal_snacks)
                img_path: "../../assets/snack-snacks-svgrepo-com.svg"
            }

            SlotWaterTracker {
                id: slot_water
                width: parent.width
                height: units.gu(7.5)
                img_path: "../../assets/glass-of-water-svgrepo-com.svg"
                water_cups_drinked: (home_page.updateTrigger * 0) + (logical_fields.metrics.total_water_cups * 0.1)
            }
        }
    }

    BottomEdge {
        id: bottom_edge
        parent: home_page

        property var yesterday_formated_date
        property int meal_filter

        onMeal_filterChanged: meal_filter == 0 ?
            dataAnalysisRepository.getYesterdayBreakfast() : meal_filter == 1 ?
            dataAnalysisRepository.getYesterdayLunch() : meal_filter == 2 ?
            dataAnalysisRepository.getYesterdayDinner() : meal_filter == 3 ?
            dataAnalysisRepository.getYesterdaySnacks() : {}

        Component {
            id: meal_filter_dialog
            MealFilterDialog {}
        }

        contentComponent: Page {
            id: bottom_edge_page
            height: bottom_edge.height

            Item {
                visible: !yesterday_foods_list.visible
                anchors.centerIn: parent
                height: parent.height / 2
                width: parent.width / 2
                z: 100

                Icon {
                    id: empty_icon
                    anchors.fill: parent
                    name: "empty-symbolic"
                    opacity: 0.75
                }

                Label {
                    anchors.top: empty_icon.bottom
                    anchors.horizontalCenter: empty_icon.horizontalCenter
                    text: i18n.tr("Empty List, Register Ingestions First Or Choose A Filter.")
                    opacity: 0.75
                    color: app_style.label.labelColor
                }
            }

            BackgroundStyle {}

            header: PageHeader {
                title: i18n.tr("Your Previous Ingestions")

                ActionBar {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    numberOfSlots: 1

                    actions: [
                        Action {
                            iconName: "filters"
                            onTriggered: PopupUtils.open(meal_filter_dialog)
                        }
                    ]
                }
            }

            ListView {
                id: yesterday_foods_list
                anchors {
                    top: parent.header.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                highlightRangeMode: ListView.ApplyRange
                highlightMoveDuration: LomiriAnimation.SnapDuration
                model: filtered_meal_model
                visible: filtered_meal_model.count > 0

                delegate: ListItem {
                    divider.visible: false
                    ListItemLayout {
                        title.text: name
                        subtitle.text: cal

                        LomiriShape {
                            SlotsLayout.position: SlotsLayout.Leading
                            height: units.gu(6)
                            width: height
                            color: getGradeColor(score_label.text)
                            radius: "large"
                            aspect: LomiriShape.Inset

                            Label {
                                id: score_label
                                anchors.centerIn: parent
                                text: nutriscore
                                textSize: Label.Large
                                font.capitalization: Font.AllUppercase
                                color: "white"
                            }
                        }
                    }

                    leadingActions: ListItemActions {
                        actions: [
                            Action {
                                iconName: "delete"
                                onTriggered: {
                                    ingestionRepository.deleteIngestion(id);
                                    filtered_meal_model.remove(index);
                                }
                            }
                        ]
                    }

                    onClicked: {
                        ingestionRepository.saveIngestion({
                            "name": String(name),
                            "nutriscore": String(nutriscore),
                            "calories": Number(cal),
                            "fat": Number(fat),
                            "carbs": Number(carbo),
                            "protein": Number(protein),
                            "mealType": Number(bottom_edge.meal_filter),
                            "date": logical_fields.application.date_utils.long_date
                        });
                        PopupUtils.open(operation_sucess);
                        root.initDB();
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        updateDashboardData();

        const installed_date = new Date(app_settings.using_app_date);
        const year_diff = logical_fields.application.date_utils.current_date.getYear() - installed_date.getYear();

        if (app_settings.is_auto_cleaning && year_diff >= 1) {
            PopupUtils.open(notification_pop);
            ingestionRepository.autoClean();
        }
    }

    onVisibleChanged: {
        if (visible) {
            updateDashboardData();
            if (app_settings.is_chat_support_enabled) {
                chat_auth.verifySession();
            }
        }
    }
}
