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

function selectActivity(activity){

  //enables the next button after user clicking in one slotActity
  set_activity_page.is_activity_choosed = true


  //property to store type of plan
  root.user_activity_level = activity == 0 ? 0 : activity == 1 ? 1 : activity == 2 ? 2 : 3

  //highlight Slots selection 
  very_light_slot.text_color = activity == 0 ? UbuntuColors.green : "black"
  light_slot.text_color = activity == 1 ? UbuntuColors.green : "black"
  moderate_slot.text_color = activity == 2 ? UbuntuColors.green : "black"
  heavy_slot.text_color = activity == 3 ? UbuntuColors.green : "black"

}