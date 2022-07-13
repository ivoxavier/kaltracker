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

function confrim(){
  ////stores plan type
  app_settings.plan_type = root.type_goal
  
  page_stack.pop(set_height_page)
  page_stack.pop(set_weight_page)
  page_stack.pop(set_age_page)
  page_stack.pop(set_sex_at_birth_page)
  page_stack.pop(set_activity_page)
  page_stack.pop(set_plan_page)
  page_stack.push(create_storage_page)
}

function calcCal(){
  var goal_calc = root.type_goal == "loose" ?
  (-root.user_goal) : root.type_goal == "gain" ?
  root.user_goal : 0
  root.equation_recommended_calories = (RecommendedCalories.equation(root.user_age,
  root.user_weight,root.user_height,root.user_sex_at_birth,root.user_activity_level)) + goal_calc  
}