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
import Qt.labs.settings 1.0

QtObject{

    property QtObject application : QtObject{
        property QtObject date_utils : QtObject{
            property var locale : Qt.locale()
            property date current_date : new Date()
            property var long_date: current_date.toLocaleDateString(locale, 'yyyy-MM-dd')
        }
    }

    property QtObject user_profile : QtObject{
        property int user_goal
        property string type_goal
        property int user_activity_level
        property int user_sex_at_birth // 0 for Male. 1 for Female
        property int user_age
        property double user_weight
        property int user_height
        property int ap_hi //systolic
        property int ap_lo //diastolic
        property int equation_recommended_calories
        property QtObject plan : QtObject{
            property int cal_consumed
            property int cal_remaining
        }
    }

    property QtObject ingestion : QtObject{
        property string product_name
        property string nutriscore : "a"
        property string nova_groups
        property int cal
        property double carbo : 0.0
        property double fat : 0.0
        property double protein : 0.0
        property int meal_type
        property int quantity_portions : 1
        property double size_portions : 1
        property int cal_ingested : Math.round(cal * quantity_portions) * size_portions
        property double carbo_ingested : Math.round((carbo * quantity_portions) * size_portions * 10) / 10
        property double fat_ingested : Math.round((fat * quantity_portions) * size_portions * 10) / 10
        property double protein_ingested : Math.round((protein * quantity_portions) * size_portions * 10) / 10 
    }

    property QtObject metrics : QtObject{
        property int total_cal_breakfast
        property int total_cal_lunch
        property int total_cal_dinner
        property int total_cal_snacks
        property int total_foods_consumed
        property int total_water_cups
        property double total_carbo_consumed
        property double total_fat_consumed
        property double total_protein_consumed
    }

}