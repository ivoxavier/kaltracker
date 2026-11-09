/*
 * 2022-2026 Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 */

import QtQuick 2.9
import Lomiri.Components 1.3
import QtQuick.Controls 2.2 as QQC2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import Lomiri.Components.Pickers 1.3
import QtQuick.Controls.Suru 2.2
import "../components"
import "../theme"
import "../logicalFields"

Page {
    id: user_profile_page
    objectName: 'UserProfilePage'

    property bool isUpdateMode: false

    header: PageHeader {
        title: {
            if (swipe_view.currentIndex === 0) return i18n.tr("Goal & Activity");
            if (swipe_view.currentIndex === 1) return i18n.tr("Body Metrics");
            return i18n.tr("Health Tracker");
        }
    }

    BackgroundStyle {}

    property bool isPlanSet: logical_fields.user_profile.type_goal !== ""
    property bool isActivitySet: logical_fields.user_profile.user_activity_level >= 0
    property bool isBodySet: logical_fields.user_profile.user_weight > 0 && logical_fields.user_profile.user_height > 0
    property bool isFormComplete: isPlanSet && isActivitySet && isBodySet

    Component { id: loose_weight_definition_dialog; GoalDefinitionDialog { type_of_goal: i18n.tr("loose") } }
    Component { id: gain_weight_definition_dialog; GoalDefinitionDialog { type_of_goal: i18n.tr("gain") } }
    Component { id: calculate_recommended_calories_dialog; RecommendedCaloriesDialog {} }
    Component { id: state_updating_blood_pressure_dialog; UpdateUserBloodPressureDialog {} }
    Component {
        id: help_dialog
        MessageDialog {
            msg: i18n.tr("Very Light: Driving, Typing, Cooking.\nLight: Walking 5 km, Golf.\nModerate: Walking 6 km, Dancing, Cycling.\nHeavy: Running, Soccer, Basketball.")
        }
    }

    Component.onCompleted: {
        if (isUpdateMode) {
            var userData = userRepository.getUser();
            if (userData && userData.sex_at_birth !== undefined) {
                logical_fields.user_profile.user_sex_at_birth = userData.sex_at_birth;
            }
        }
    }


    QQC2.SwipeView {
        id: swipe_view
        anchors {
            top: parent.header.bottom
            left: parent.left
            right: parent.right
            bottom: fab_container.top
        }
        clip: true

        Flickable {
            contentHeight: plan_column.implicitHeight + units.gu(4)
            contentWidth: width
            clip: true
            
            ColumnLayout {
                id: plan_column
                anchors.top: parent.top
                anchors.topMargin: units.gu(2)
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - units.gu(4)
                spacing: units.gu(3)
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: goal_layout.implicitHeight + units.gu(4)
                    color: Suru.theme === 0 ? "#ffffff" : "#1e1e1e"
                    radius: units.gu(2)
                    
                    ColumnLayout {
                        id: goal_layout
                        anchors.fill: parent
                        anchors.margins: units.gu(2)
                        spacing: units.gu(1.5)

                        Label { text: i18n.tr("Main Goal"); font.bold: true; color: app_style.label.labelColor }

                        SlotPlans {
                            Layout.fillWidth: true; Layout.preferredHeight: units.gu(7)
                            text: i18n.tr("LOOSE WEIGHT"); img_path: "../../assets/shoe-svgrepo-com.svg"
                            text_color: logical_fields.user_profile.type_goal === "loose" ? LomiriColors.green : app_style.label.labelColor
                            MouseArea { anchors.fill: parent; onClicked: { logical_fields.user_profile.type_goal = "loose"; PopupUtils.open(loose_weight_definition_dialog); } }
                        }
                        SlotPlans {
                            Layout.fillWidth: true; Layout.preferredHeight: units.gu(7)
                            text: i18n.tr("MAINTAIN WEIGHT"); img_path: "../../assets/kilograms-justice-svgrepo-com.svg" 
                            text_color: logical_fields.user_profile.type_goal === "maintain" ? LomiriColors.green : app_style.label.labelColor
                            MouseArea { anchors.fill: parent; onClicked: logical_fields.user_profile.type_goal = "maintain" }
                        }
                        SlotPlans {
                            Layout.fillWidth: true; Layout.preferredHeight: units.gu(7)
                            text: i18n.tr("GAIN WEIGHT"); img_path: "../../assets/dumbbell-gym-svgrepo-com.svg"  
                            text_color: logical_fields.user_profile.type_goal === "gain" ? LomiriColors.green : app_style.label.labelColor
                            MouseArea { anchors.fill: parent; onClicked: { logical_fields.user_profile.type_goal = "gain"; PopupUtils.open(gain_weight_definition_dialog); } }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: activity_layout.implicitHeight + units.gu(4)
                    color: Suru.theme === 0 ? "#ffffff" : "#1e1e1e"
                    radius: units.gu(2)
                    
                    ColumnLayout {
                        id: activity_layout
                        anchors.fill: parent
                        anchors.margins: units.gu(2)
                        spacing: units.gu(1.5)

                        RowLayout {
                            Layout.fillWidth: true
                            Label { text: i18n.tr("Daily Activity"); font.bold: true; color: app_style.label.labelColor; Layout.fillWidth: true }
                            Icon { name: "info"; height: units.gu(2.5); width: height; MouseArea { anchors.fill: parent; onClicked: PopupUtils.open(help_dialog) } }
                        }

                        SlotActivity {
                            Layout.fillWidth: true; Layout.preferredHeight: units.gu(7)
                            text: i18n.tr("VERY LIGHT"); img_path: "../../assets/cooking-stew-svgrepo-com.svg"
                            text_color: logical_fields.user_profile.user_activity_level === 0 ? LomiriColors.green : app_style.label.labelColor
                            MouseArea { anchors.fill: parent; onClicked: logical_fields.user_profile.user_activity_level = 0 }
                        }
                        SlotActivity {
                            Layout.fillWidth: true; Layout.preferredHeight: units.gu(7)
                            text: i18n.tr("LIGHT"); img_path: "../../assets/walking-the-dog-svgrepo-com.svg"
                            text_color: logical_fields.user_profile.user_activity_level === 1 ? LomiriColors.green : app_style.label.labelColor
                            MouseArea { anchors.fill: parent; onClicked: logical_fields.user_profile.user_activity_level = 1 }
                        }
                        SlotActivity {
                            Layout.fillWidth: true; Layout.preferredHeight: units.gu(7)
                            text: i18n.tr("MODERATE"); img_path: "../../assets/cycling-color-svgrepo-com.svg"
                            text_color: logical_fields.user_profile.user_activity_level === 2 ? LomiriColors.green : app_style.label.labelColor
                            MouseArea { anchors.fill: parent; onClicked: logical_fields.user_profile.user_activity_level = 2 }
                        }
                        SlotActivity {
                            Layout.fillWidth: true; Layout.preferredHeight: units.gu(7)
                            text: i18n.tr("HEAVY"); img_path: "../../assets/soccer-svgrepo-com.svg"
                            text_color: logical_fields.user_profile.user_activity_level === 3 ? LomiriColors.green : app_style.label.labelColor
                            MouseArea { anchors.fill: parent; onClicked: logical_fields.user_profile.user_activity_level = 3 }
                        }
                    }
                }
            }
        }

        Flickable {
            contentHeight: body_column.implicitHeight + units.gu(4)
            contentWidth: width
            clip: true
            
            ColumnLayout {
                id: body_column
                anchors.top: parent.top
                anchors.topMargin: units.gu(2)
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - units.gu(4)
                spacing: units.gu(3)

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: identity_layout.implicitHeight + units.gu(4)
                    color: Suru.theme === 0 ? "#ffffff" : "#1e1e1e"
                    radius: units.gu(2)
                    
                    ColumnLayout {
                        id: identity_layout
                        anchors.fill: parent
                        anchors.margins: units.gu(2)
                        spacing: units.gu(2)

                        Label { text: i18n.tr("Sex at Birth"); font.bold: true; color: app_style.label.labelColor }
                        
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: units.gu(2)
                            SlotBirthSex {
                                Layout.fillWidth: true; Layout.preferredHeight: units.gu(12)
                                text: i18n.tr("MALE"); img_path: "../../assets/male-svgrepo-com.svg" 
                                text_color: logical_fields.user_profile.user_sex_at_birth === 0 ? LomiriColors.green : app_style.label.labelColor
                                MouseArea { anchors.fill: parent; onClicked: logical_fields.user_profile.user_sex_at_birth = 0 }
                            }
                            SlotBirthSex {
                                Layout.fillWidth: true; Layout.preferredHeight: units.gu(12)
                                text: i18n.tr("FEMALE"); img_path: "../../assets/female-gender-svgrepo-com.svg"
                                text_color: logical_fields.user_profile.user_sex_at_birth === 1 ? LomiriColors.green : app_style.label.labelColor
                                MouseArea { anchors.fill: parent; onClicked: logical_fields.user_profile.user_sex_at_birth = 1 }
                            }
                        }

                        BlankSpace { height: units.gu(1) }
                        Label { text: i18n.tr("Age"); font.bold: true; color: app_style.label.labelColor }
                        
                        Picker {
                            Layout.fillWidth: true; Layout.preferredHeight: units.gu(9)
                            circular: false
                            model: Array.from(Array(101).keys())
                            
                            Component.onCompleted: {
                                selectedIndex = logical_fields.user_profile.user_age > 0 ? logical_fields.user_profile.user_age : 25
                            }
                            
                            delegate: PickerDelegate {
                                Label { text: modelData + i18n.tr(" years"); anchors.fill: parent; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter }
                            }
                            onSelectedIndexChanged: logical_fields.user_profile.user_age = selectedIndex
                        }
                    }
                }

            
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: metrics_layout.implicitHeight + units.gu(4)
                    color: Suru.theme === 0 ? "#ffffff" : "#1e1e1e"
                    radius: units.gu(2)

                    GridLayout {
                        id: metrics_layout
                        anchors.fill: parent
                        anchors.margins: units.gu(2)
                        columns: 2
                        columnSpacing: units.gu(3)
                        
                        Label { text: i18n.tr("Height"); font.bold: true; color: app_style.label.labelColor; Layout.alignment: Qt.AlignHCenter }
                        Label { text: i18n.tr("Weight"); font.bold: true; color: app_style.label.labelColor; Layout.alignment: Qt.AlignHCenter }

                
                        ColumnLayout {
                            Layout.alignment: Qt.AlignCenter
                            QQC2.Slider {
                                id: height_slider
                                Layout.alignment: Qt.AlignCenter; Layout.preferredHeight: units.gu(18)
                                orientation: Qt.Vertical; live: true; from: 100; to: 250
                                
                                Component.onCompleted: {
                                    value = logical_fields.user_profile.user_height > 100 ? logical_fields.user_profile.user_height : 170
                                }
                                
                                onValueChanged: logical_fields.user_profile.user_height = Math.round(value)
                            }
                            Label { Layout.alignment: Qt.AlignCenter; font.bold: true; color: app_style.label.labelColor; text: Math.round(height_slider.value) + " cm" }
                        }

                    
                        LomiriShape {
                            Layout.alignment: Qt.AlignCenter
                            Layout.preferredWidth: units.gu(15)
                            Layout.preferredHeight: units.gu(18)
                            aspect: LomiriShape.Flat
                            radius: "large"
                            backgroundColor: app_style.shape.shapeColor

                            property int currentWeight: logical_fields.user_profile.user_weight > 0 ? logical_fields.user_profile.user_weight : 70

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: units.gu(1)
                                Label { Layout.alignment: Qt.AlignCenter; font.pixelSize: units.gu(5); font.bold: true; text: parent.parent.currentWeight }
                                Label { Layout.alignment: Qt.AlignCenter; font.bold: true; text: i18n.tr("KG") }
                                
                                RowLayout {
                                    spacing: units.gu(2)
                                    Rectangle {
                                        width: units.gu(4.5); height: width; radius: width/2; color: "transparent"; border.color: app_style.label.labelColor
                                        Label { anchors.centerIn: parent; font.pixelSize: units.gu(4); text: "-" }
                                        MouseArea { anchors.fill: parent; onClicked: { parent.parent.parent.parent.currentWeight--; logical_fields.user_profile.user_weight = parent.parent.parent.parent.currentWeight } }
                                    }
                                    Rectangle {
                                        width: units.gu(4.5); height: width; radius: width/2; color: "transparent"; border.color: app_style.label.labelColor
                                        Label { anchors.centerIn: parent; font.pixelSize: units.gu(3); text: "+" }
                                        MouseArea { anchors.fill: parent; onClicked: { parent.parent.parent.parent.currentWeight++; logical_fields.user_profile.user_weight = parent.parent.parent.parent.currentWeight } }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

    
        Flickable {
            contentHeight: bp_column.implicitHeight + units.gu(4)
            contentWidth: width
            clip: true
            
            ColumnLayout {
                id: bp_column
                anchors.top: parent.top
                anchors.topMargin: units.gu(2)
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - units.gu(4)
                spacing: units.gu(3)
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: bp_inner_layout.implicitHeight + units.gu(4)
                    color: Suru.theme === 0 ? "#ffffff" : "#1e1e1e"
                    radius: units.gu(2)

                    ColumnLayout {
                        id: bp_inner_layout
                        anchors.fill: parent
                        anchors.margins: units.gu(2)
                        spacing: units.gu(3)
                        
                        Label { text: i18n.tr("Systolic Pressure (High)"); font.bold: true; color: app_style.label.labelColor }
                        
                        LomiriShape {
                            Layout.fillWidth: true
                            Layout.preferredHeight: units.gu(15)
                            aspect: LomiriShape.Flat; radius: "large"; backgroundColor: app_style.shape.shapeColor
                            property int systolic_value: logical_fields.user_profile.ap_hi > 0 ? logical_fields.user_profile.ap_hi : 120
                            ColumnLayout {
                                anchors.centerIn: parent
                                Label { Layout.alignment: Qt.AlignCenter; font.pixelSize: units.gu(5); font.bold: true; text: parent.parent.systolic_value }
                                RowLayout {
                                    Layout.alignment: Qt.AlignCenter; spacing: units.gu(6)
                                    Rectangle {
                                        width: units.gu(5.5); height: width; color: "transparent"; border.color: app_style.label.labelColor; radius: width*0.5
                                        Label { anchors.centerIn: parent; font.pixelSize: units.gu(4); color: app_style.label.labelColor; text: "-" }
                                        MouseArea { anchors.fill: parent; onClicked: { parent.parent.parent.parent.systolic_value--; logical_fields.user_profile.ap_hi = parent.parent.parent.parent.systolic_value } }
                                    }
                                    Rectangle {
                                        width: units.gu(5.5); height: width; color: "transparent"; border.color: app_style.label.labelColor; radius: width*0.5
                                        Label { anchors.centerIn: parent; font.pixelSize: units.gu(4); color: app_style.label.labelColor; text: "+" }
                                        MouseArea { anchors.fill: parent; onClicked: { parent.parent.parent.parent.systolic_value++; logical_fields.user_profile.ap_hi = parent.parent.parent.parent.systolic_value } }
                                    }
                                }
                            }
                        }

                        Label { text: i18n.tr("Diastolic Pressure (Low)"); font.bold: true; color: app_style.label.labelColor }
                        
                        LomiriShape {
                            Layout.fillWidth: true
                            Layout.preferredHeight: units.gu(15)
                            aspect: LomiriShape.Flat; radius: "large"; backgroundColor: app_style.shape.shapeColor
                            property int diastolic_value: logical_fields.user_profile.ap_lo > 0 ? logical_fields.user_profile.ap_lo : 80
                            ColumnLayout {
                                anchors.centerIn: parent
                                Label { Layout.alignment: Qt.AlignCenter; font.pixelSize: units.gu(5); font.bold: true; text: parent.parent.diastolic_value }
                                RowLayout {
                                    Layout.alignment: Qt.AlignCenter; spacing: units.gu(6)
                                    Rectangle {
                                        width: units.gu(5.5); height: width; color: "transparent"; border.color: app_style.label.labelColor; radius: width*0.5
                                        Label { anchors.centerIn: parent; font.pixelSize: units.gu(4); color: app_style.label.labelColor; text: "-" }
                                        MouseArea { anchors.fill: parent; onClicked: { parent.parent.parent.parent.diastolic_value--; logical_fields.user_profile.ap_lo = parent.parent.parent.parent.diastolic_value } }
                                    }
                                    Rectangle {
                                        width: units.gu(5.5); height: width; color: "transparent"; border.color: app_style.label.labelColor; radius: width*0.5
                                        Label { anchors.centerIn: parent; font.pixelSize: units.gu(4); color: app_style.label.labelColor; text: "+" }
                                        MouseArea { anchors.fill: parent; onClicked: { parent.parent.parent.parent.diastolic_value++; logical_fields.user_profile.ap_lo = parent.parent.parent.parent.diastolic_value } }
                                    }
                                }
                            }
                        }

                        
                        Rectangle {
                            Layout.alignment: Qt.AlignCenter
                            Layout.topMargin: units.gu(2)
                            width: units.gu(18)
                            height: units.gu(5)
                            radius: units.gu(1)
                            color: Suru.theme === 0 ? "#e0e0e0" : "#333333"
                            Label {
                                anchors.centerIn: parent
                                text: i18n.tr("Update Values")
                                font.bold: true
                                color: app_style.label.labelColor
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: PopupUtils.open(state_updating_blood_pressure_dialog)
                            }
                        }
                    }
                }
            }
        }
    }

    QQC2.PageIndicator {
        id: swipe_view_indicator
        count: 3 // Sempre 3 páginas, evitando erros de renderização
        currentIndex: swipe_view.currentIndex
        anchors.bottom: fab_container.top
        anchors.bottomMargin: units.gu(1)
        anchors.horizontalCenter: parent.horizontalCenter
    }

    // --- BOTÃO FLUTUANTE (FAB) ---
    Item {
        id: fab_container
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: isFormComplete ? units.gu(9) : 0
        visible: height > 0
        Behavior on height { NumberAnimation { duration: 300; easing.type: Easing.OutBack } }

        Rectangle {
            id: fab_button
            anchors.centerIn: parent
            width: parent.width - units.gu(4)
            height: units.gu(6)
            radius: height / 2
            
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#ff9999" }
                GradientStop { position: 1.0; color: "#f45c5c" }
            }

            Label {
                anchors.centerIn: parent
                text: isUpdateMode ? i18n.tr("Update Profile") : i18n.tr("Calculate & Save")
                color: "white"
                font.bold: true
                font.pixelSize: units.gu(2)
            }

            MouseArea {
                anchors.fill: parent
                onPressed: fab_button.scale = 0.95
                onReleased: {
                    fab_button.scale = 1.0
                    PopupUtils.open(calculate_recommended_calories_dialog)
                }
            }
            Behavior on scale { NumberAnimation { duration: 150 } }
        }
    }
}