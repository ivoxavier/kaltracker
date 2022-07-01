/*
 * 2022  Ivo Fernandes <pg27165@alunos.uminho.pt>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * utFoods is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.LocalStorage 2.12
import QtQuick.Layouts 1.3
import "../../js/UpdateUserTable.js" as UpdateUserTable
import "../../js/WeightTrackerTable.js" as WeightTrackerTable
import "../../js/RecommendedCalories.js" as RecommendedCalories

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
        var update_goal_calc = update_user_values_page.update_type_goal == "loose" ?
        (-update_user_values_page.update_user_goal) : update_user_values_page.update_type_goal == "gain" ?
        update_user_values_page.update_user_goal : 0

        update_user_values_page.update_recommended_calories = (RecommendedCalories.equation(update_user_values_page.update_age,
        update_user_values_page.update_weight,
        update_user_values_page.update_height,
        update_user_values_page.sex_at_birth,
        update_user_values_page.update_activity_level)) + update_goal_calc
    
        UpdateUserTable.updateWeight(update_user_values_page.update_weight)
        UpdateUserTable.updateHeight(update_user_values_page.update_height)

        WeightTrackerTable.newWeight(update_user_values_page.update_weight)

        app_settings.water_weight_calc = update_user_values_page.update_weight

        app_settings.plan_type = update_user_values_page.update_type_goal
        app_settings.rec_cal =  update_user_values_page.update_recommended_calories

        UpdateUserTable.updateAge(update_user_values_page.update_age)
        UpdateUserTable.updateRecCal(update_user_values_page.update_recommended_calories)
        UpdateUserTable.updateActivity(update_user_values_page.update_activity_level)
        app_settings.is_weight_tracker_chart_enabled = true
        loadingCircle.running = true
    }
}