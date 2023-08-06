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


Item {


    function executeStream(){}

    Timer{
        id: ctrl_strs_timer
        interval: 200
        running: app_settings.is_streams_enabled
        repeat: true
        onTriggered: {
            if(streams_smph.light == "yellow"){
                if(app_settings.stream_kcal_consumption){
                    streams.call('streams.Streams.moduleState', [] ,function(returnValue){
                    console.log(returnValue)
                    })
                }
            }        
        }
    }
}