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
import Lomiri.Components.Popups 1.3
import QtQuick.Layouts 1.3
import "../style"
import "../../js/UserFoodsListTable.js" as UserFoodsListTable


Dialog {
    id: msg_dialog
    property alias msg : msg_dialog.title

    Button {
        text: i18n.tr("Continue registering...")
        color: app_style.button.actionButton.buttonColor
            onClicked: {
                if(page_stack.currentPage.objectName == "QuickAdditionPage"){
                page_stack.pop(quick_addition_page)
                PopupUtils.close(msg_dialog)
            } else{
                page_stack.pop(set_food_page)
                PopupUtils.close(msg_dialog)
            }
        }
    }

    Button {
        text: i18n.tr("It's ok for now")
        onClicked: {
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
     }
}