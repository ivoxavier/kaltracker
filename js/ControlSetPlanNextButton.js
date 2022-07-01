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

function next(){
  if(set_plan_page.is_loose_weight){
    PopupUtils.open(loose_weight_definition_dialog)
  } else if(set_plan_page.is_gain_weight){
    PopupUtils.open(gain_weight_definition_dialog)
  } else{
    page_stack.push(set_activity_page)
  }
}