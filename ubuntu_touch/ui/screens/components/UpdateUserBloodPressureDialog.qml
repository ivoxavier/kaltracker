/*
 * 2022-2026 Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 */

import QtQuick 2.9
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import QtQuick.Layouts 1.3

Dialog {
    id: updating_user_table_dialog
    text: i18n.tr("Updating Blood Pressure")
   
    Column { 
        spacing: units.gu(2)

        Timer {
            id: timer
            repeat: false
        }

        ActivityIndicator {
            id: loadingCircle
            anchors.horizontalCenter: parent.horizontalCenter
            running: false
            
            onRunningChanged: {
                if (running) {
                    timer.interval = 1500;
                    timer.triggered.connect(function() {
                        page_stack.pop()
                        root.initDB()
                        PopupUtils.close(updating_user_table_dialog)
                    });
                    timer.start();
                }
            }
        }
    }

    Component.onCompleted: {
        userRepository.updateApHi(logical_fields.user_profile.ap_hi)
        userRepository.updateApLo(logical_fields.user_profile.ap_lo)
        app_settings.is_blood_pressure_defined = true
        loadingCircle.running = true
    }
}