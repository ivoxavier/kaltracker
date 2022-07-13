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

function selectSex(sex){

  //enables the next button after user clicking in one slotActity
  set_sex_at_birth_page.is_sex_at_birth_selected = true


  //property to store type of sex assigned at birth 0 Male 1 Female
  root.user_sex_at_birth = sex == 0 ? 0 : 1

  //highlight Slots selection 
  male_slot.text_color = sex == 0 ? UbuntuColors.green : "black"
  female_slot.text_color = sex == 1 ? UbuntuColors.green : "black"
}