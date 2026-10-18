/*
 * 2022  Ivo Xavier
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
import QtQuick.LocalStorage 2.12
import QtQuick.Layouts 1.3
import "../../js/UpdateUserTable.js" as UpdateUserTable


Dialog {
    id: updating_user_table_dialog
    text: i18n.tr("Updating User Table")

   
    Column{ 
        spacing: units.gu(2)

        Timer{
            id: timer
            repeat: false
        }

        ActivityIndicator {
            id: loadingCircle
        
            anchors.horizontalCenter: parent.horizontalCenter
            running: false
            onRunningChanged: {

                function animationState(delayMiliseconds, cb) {
                    timer.interval = delayMiliseconds;
                    timer.triggered.connect(cb);
                    timer.start();
                }  
                
                animationState(2000, function () {
                    page_stack.pop(update_user_values_page)
                    root.initDB()
                    PopupUtils.close(updating_user_table_dialog)
                })
    
            }
        }
    }

    Component.onCompleted: {
        UpdateUserTable.updateApHi(update_user_values_page.update_ap_hi)
        UpdateUserTable.updateApLo(update_user_values_page.update_ap_lo)
        app_settings.is_blood_pressure_defined = true
        loadingCircle.running = true
    }
}