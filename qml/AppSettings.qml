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
import Qt.labs.settings 1.0

Settings {

    //stores the app configuration
    property bool is_clean_install : true
    property bool is_user_created_foods_list_enabled : false
    property bool is_weight_tracker_chart_enabled: false
    property bool is_api_openfoodsfacts_enabled : false
    property bool is_auto_cleaning : false
    property bool is_graphs_animation_enabled : true
    property bool is_blood_pressure_defined : false
    
    //stores 
    property double water_weight_calc
    
    //stores the target time for sport activity
    property int target_time : 60

    //stores the user starts using date
    property string using_app_date

    //stores plan type
    property string plan_type
    
    //stores recommended calories
    property int rec_cal

}