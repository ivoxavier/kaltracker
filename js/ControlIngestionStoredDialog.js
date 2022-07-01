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

function finishingIngestion (){
  if(page_stack.currentPage.objectName == "QuickAdditionPage"){
    page_stack.pop(quick_addition_page)
    page_stack.pop(quick_list_foods_page) 
    PopupUtils.close(msg_dialog)
} else{
    page_stack.pop(set_food_page)
    page_stack.pop(quick_list_foods_page)    
    PopupUtils.close(msg_dialog)
}
}

function continueIngestion(){
  if(page_stack.currentPage.objectName == "QuickAdditionPage"){
    page_stack.pop(quick_addition_page)
    PopupUtils.close(msg_dialog)
} else{
    page_stack.pop(set_food_page)
    PopupUtils.close(msg_dialog)
}
}