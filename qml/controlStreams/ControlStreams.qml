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
import Qt.labs.settings 1.0
import io.thp.pyotherside 1.5
import QtQuick.LocalStorage 2.12
import Lomiri.Components.Popups 1.3
import "../components"



Item {
    id: ctrl_strs

    property var notification_data: ({title: "", subtitle: ""})

    Component{
        id:ctrl_strs_notif
        NotificationPop{
            title.text: ctrl_strs.notification_data.title
            subtitle.text: ctrl_strs.notification_data.subtitle !== null ? ctrl_strs.notification_data.subtitle : " "
        }
    }
    
    property bool has_executed_strmKcal : false
    property bool has_executed_ddWthReg : false
    

    Timer{id: notification_queue_timer;repeat: false}

    function strmKcal(){
        if (!ctrl_strs.has_executed_strmKcal) {
            if(!(app_settings.using_app_date === logical_fields.application.date_utils.long_date)){
                streams.call('streams.Streams.kcal_consumption', [] ,function(returnValue){
                    ctrl_strs.notification_data.title = i18n.tr("Total Calories Registed In The Kaltracker")
                    ctrl_strs.notification_data.subtitle = returnValue.toString()
                    PopupUtils.open(ctrl_strs_notif) 
                })
            }
        }
        ctrl_strs.has_executed_strmKcal = true
    }

    function delayNotif(delayMiliseconds, cb) {
        notification_queue_timer.interval = delayMiliseconds;
        notification_queue_timer.triggered.connect(cb);
        notification_queue_timer.start();
    } 

    function ddWthReg(){
        if (!ctrl_strs.has_executed_ddWthReg) {
            streams.call('streams.Streams.days_without_reg', [] ,function(returnValue){
                if(returnValue === 0){
                    ctrl_strs.notification_data.title = i18n.tr("You Haven't Registed Foods In The Last 5 Days")  
                    delayNotif(3000, function () {
                            PopupUtils.open(ctrl_strs_notif)
                    })
                }   
            })
        }
        ctrl_strs.has_executed_ddWthReg = true
    }

    Timer{
        id: ctrl_strs_timer
        interval: 9000
        running: (app_settings.is_streams_enabled && !app_settings.is_clean_install)
        repeat: true
        onTriggered: {
                if (streams_smph.light === "yellow" && app_settings.stream_kcal_consumption) {
                    ctrl_strs.strmKcal();
                }
                if(streams_smph.light === "yellow" && app_settings.stream_days_without_reg){
                    ctrl_strs.ddWthReg();
                }
        }
    }
}