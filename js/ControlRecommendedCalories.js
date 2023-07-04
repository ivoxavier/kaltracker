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
  var goal_calc = logical_fields.user_profile.type_goal == "loose" ?
  (-logical_fields.user_profile.user_goal) : logical_fields.user_profile.type_goal == "gain" ?
  logical_fields.user_profile.user_goal : 0
  
  logical_fields.user_profile.equation_recommended_calories = (RecommendedCalories.equation(logical_fields.user_profile.user_age,
  logical_fields.user_profile.user_weight,
  logical_fields.user_profile.user_height,
  logical_fields.user_profile.user_sex_at_birth,
  logical_fields.user_profile.user_activity_level)) + goal_calc  
}

function updatingProfile(){
var update_goal_calc = logical_fields.user_profile.type_goal == "loose" ?
  (-logical_fields.user_profile.user_goal) : logical_fields.user_profile.type_goal == "gain" ?
  logical_fields.user_profile.user_goal : 0

    logical_fields.user_profile.equation_recommended_calories = (RecommendedCalories.equation(logical_fields.user_profile.user_age,
    logical_fields.user_profile.user_weight,
    logical_fields.user_profile.user_height,
    logical_fields.user_profile.user_sex_at_birth,
    logical_fields.user_profile.user_activity_level)) + update_goal_calc

}
