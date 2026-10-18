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

Item {
    function setSemaphore(smph_id,event_type){
        var evnt_mapping_light = {
            "user_event": "red", //user_event is always priority
            "app_event": "yellow", //app_event is necessary
            "default": "yellow" // stream_event and possible others
        };
        smph_id.light = evnt_mapping_light[event_type] || evnt_mapping_light["default"];
    }
    function forceForward(smph_id){
        smph_id.light = "yellow"
    }
    function stopSemaphore(smph_id){
        smph_id.light = "red"
    }
    function defaultSemaphore(smph_id){
        smph_id.light = "yellow"
    }
}