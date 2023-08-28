/*
 * 2022-2023  Ivo Xavier
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
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.LocalStorage 2.12
import QtQuick.Controls.Suru 2.2
import "../components"
import "../style"
import "../../js/Storage.js" as Storage
import "../../js/UserTable.js" as UserTable
import "../../js/WeightTrackerTable.js" as WeightTrackerTable

Page{
    id: create_storage_page
    objectName: 'CreateStoragePage'
    header: PageHeader {visible: false}

    BackgroundStyle{}

    Component{
        id: operation_failed
        MessageDialog{msg: err}
    }

    Component{
        id: dummy_dialog
        MessageDialog{msg: "DB Created"}
    }


    Timer{id: timer; repeat: false}

    Column{
        anchors{
            top: parent.top
            right: parent.right
            left: parent.left
            bottom: parent.bottom
        }

        BlankSpace{height: units.gu(6)}

        LomiriShape{
            anchors.horizontalCenter: parent.horizontalCenter
            width: units.gu(12)
            height: units.gu(12)
            aspect: LomiriShape.Flat
            source: Image{
                source: "../../assets/db_logo.svg"
                fillMode: Image.PreserveAspectFit
            }
        }

        BlankSpace{height: units.gu(12)}

         Text{
            anchors.horizontalCenter: parent.horizontalCenter
            text: i18n.tr("Creating Database...")
            color : app_style.label.labelColor 
            font.bold : true
        }

        BlankSpace{height: units.gu(12)}

        ActivityIndicator {
            id: loading_circle

            anchors.horizontalCenter: parent.horizontalCenter
            running: false

            function animationState(delayMiliseconds, cb){
                timer.interval = delayMiliseconds;
                timer.triggered.connect(cb);
                timer.start();
            }
            onRunningChanged: {
                animationState(4000, function () {
                    page_stack.pop(create_storage_page)
                    page_stack.push(home_page)
                })
            }
        }
        
    }
    Component.onCompleted: {
        try{
            Storage.dropTables()
            Storage.createTables()
            UserTable.createUserProfile(logical_fields.user_profile.user_age,logical_fields.user_profile.user_sex_at_birth,
            logical_fields.user_profile.user_weight, logical_fields.user_profile.user_height, logical_fields.user_profile.user_activity_level, logical_fields.user_profile.equation_recommended_calories)
            WeightTrackerTable.newWeight(logical_fields.user_profile.user_weight)
            loading_circle.running = !loading_circle.running
            app_settings.water_weight_calc = logical_fields.user_profile.user_weight
            app_settings.rec_cal = logical_fields.user_profile.equation_recommended_calories
            app_settings.using_app_date = logical_fields.application.date_utils.long_date
            app_settings.is_clean_install = !app_settings.is_clean_install
        }catch (err){console.log(err)} 
    }
}