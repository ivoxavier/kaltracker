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

function initialConfig(){
  var goal_calc = root.type_goal == "loose" ?
  (-root.user_goal) : root.type_goal == "gain" ?
  root.user_goal : 0
  root.equation_recommended_calories = (RecommendedCalories.equation(root.user_age,
  root.user_weight,root.user_height,root.user_sex_at_birth,root.user_activity_level)) + goal_calc  
}

function updatingProfile(){
var update_goal_calc = update_user_values_page.update_type_goal == "loose" ?
    (-update_user_values_page.update_user_goal) : update_user_values_page.update_type_goal == "gain" ?
    update_user_values_page.update_user_goal : 0

    update_user_values_page.update_recommended_calories = (RecommendedCalories.equation(update_user_values_page.update_age,
    update_user_values_page.update_weight,
    update_user_values_page.update_height,
    update_user_values_page.sex_at_birth,
    update_user_values_page.update_activity_level)) + update_goal_calc

}
