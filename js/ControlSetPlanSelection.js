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

function selectPlan(plan){

  //enables the next button after user clicking in one slotPlans
  set_plan_page.is_plan_choosed = true

  //property to store the user goal for further calories daily objectiv calculation.
  root.user_goal = plan == 0 ? 0 : 0

  //property to store type of plan
  root.type_goal = plan == 0 ? "maintain" : plan == 1 ? "loose" : "gain"

  //highlight Slots selection 
  maintain_weight_slot.text_color = plan == 0 ? UbuntuColors.green : "black"
  loose_weight_slot.text_color = plan == 1 ? UbuntuColors.green : "black"
  gain_weight_slot.text_color = plan == 2 ? UbuntuColors.green : "black"

  //when true this property triggers the dialog propomt user to select how we would like to loose or gain weight
  set_plan_page.is_loose_weight = plan == 1 ? true : false
  set_plan_page.is_gain_weight = plan == 2 ? true : false
}