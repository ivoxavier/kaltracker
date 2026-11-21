/*
 * 2022-2026 Ivo Xavier
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
import QtQuick.LocalStorage 2.12
import QtQuick.Controls.Suru 2.2
import "../components"
import "../theme"

Page {
    id: create_storage_page
    objectName: 'CreateStoragePage'
    header: PageHeader { visible: false }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ff9999" }
            GradientStop { position: 1.0; color: "#f45c5c" }
        }
    }

    Component {
        id: operation_failed
        MessageDialog { msg: err }
    }

    
    Timer {
        id: transition_timer
        interval: 3500 
        repeat: false
        onTriggered: {
            page_stack.pop(create_storage_page)
            page_stack.push(home_page)
        }
    }

    
    Item {
        anchors.centerIn: parent
        width: units.gu(20)
        height: units.gu(20)

      
        Rectangle {
            anchors.centerIn: parent
            width: units.gu(12)
            height: units.gu(12)
            radius: width / 2
            color: "#ffffff"
            opacity: 0

            SequentialAnimation on scale {
                loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 2.5; duration: 1500; easing.type: Easing.OutCubic }
            }
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { from: 0.4; to: 0.0; duration: 1500; easing.type: Easing.OutCubic }
            }
        }

       
        Rectangle {
            anchors.centerIn: parent
            width: units.gu(12)
            height: units.gu(12)
            radius: width / 2
            color: "#ffffff"
            opacity: 0

            SequentialAnimation on scale {
                loops: Animation.Infinite
                PauseAnimation { duration: 500 }
                NumberAnimation { from: 1.0; to: 2.2; duration: 1500; easing.type: Easing.OutCubic }
            }
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                PauseAnimation { duration: 500 }
                NumberAnimation { from: 0.3; to: 0.0; duration: 1500; easing.type: Easing.OutCubic }
            }
        }

       
        Rectangle {
            anchors.centerIn: parent
            width: units.gu(14)
            height: units.gu(14)
            radius: width / 2
            color: "transparent" 

            SequentialAnimation on anchors.verticalCenterOffset {
                loops: Animation.Infinite
                NumberAnimation { from: -6; to: 6; duration: 1800; easing.type: Easing.InOutSine }
                NumberAnimation { from: 6; to: -6; duration: 1800; easing.type: Easing.InOutSine }
            }

            Image {
                source: "../../assets/logo.svg"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
            }
        }
    }

 
    Column {
        anchors.top: parent.verticalCenter
        anchors.topMargin: units.gu(14)
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: units.gu(1)

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: i18n.tr("Setting up your journey...")
            color: "white"
            font.pixelSize: units.gu(2.5)
            font.weight: Font.DemiBold
            
            
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { from: 0.6; to: 1.0; duration: 1200; easing.type: Easing.InOutSine }
                NumberAnimation { from: 1.0; to: 0.6; duration: 1200; easing.type: Easing.InOutSine }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: i18n.tr("Preparing your KalTracker profile")
            color: "white"
            font.pixelSize: units.gu(1.5)
            opacity: 0.75
        }
    }

    Component.onCompleted: {
        try {
            localStorage.dropTables()
            localStorage.createTables()
            
            userRepository.createUserProfile({
                "id": 1,
                "age": logical_fields.user_profile.user_age,
                "sexAtBirth": logical_fields.user_profile.user_sex_at_birth,
                "weight": logical_fields.user_profile.user_weight,
                "height": logical_fields.user_profile.user_height,
                "activity": logical_fields.user_profile.user_activity_level,
                "recommendedCalories": logical_fields.user_profile.equation_recommended_calories
            })
            
            app_settings.water_weight_calc = logical_fields.user_profile.user_weight
            app_settings.rec_cal = logical_fields.user_profile.equation_recommended_calories
            app_settings.using_app_date = logical_fields.application.date_utils.long_date
            app_settings.is_clean_install = !app_settings.is_clean_install

            
            transition_timer.start()
        } catch (err) {
            console.log(err)
        } 
    }
}