/*
 * 2022  Ivo Xavier
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
import QtQuick.LocalStorage 2.12
import Lomiri.Components.Pickers 1.3
import "../style"
import "../../js/IngestionsTable.js" as IngestionsTable



Dialog {
    id: delete_operation_dialog
    property string msg
    property color labelColor
    property int confirmed

    title: i18n.tr("Delete")
    
    Label{
        text: i18n.tr("Deletes your *%1* records.\nNo recovery possible").arg(msg)
        color: app_style.label.labelColor
    }

    
    Text {
        id: confirm_delete_code
        width: units.gu(12)
        text: i18n.tr("Confirm Operation With: YES")
        color: app_style.label.labelColor
    }

    BlankSpace{}

    ConfirmPicker{onSelectedIndexChanged: confirmed = selectedIndex}

    Label{id: operation_label; color: app_style.label.labelError.labelColor}

    Button {
        text: i18n.tr("Delete")
        color: app_style.button.deleteButton.buttonColor
        onClicked:{
            if (confirmed == 2){
                switch(msg){
                    case "today":
                        IngestionsTable.deleteTodayIngestions()
                        root.initDB()
                        //root.refreshListModel()
                        PopupUtils.close(delete_operation_dialog)
                        PopupUtils.open(operation_result_popover)
                    break
                    case "all":
                        IngestionsTable.deleteAllIngestions()
                        root.initDB()
                        //root.refreshListModel()
                        PopupUtils.close(delete_operation_dialog)
                        PopupUtils.open(operation_result_popover)
                    break
                    default:
                        operation_label.text = i18n.tr("Something Went Wrong")
                }
            } else {
                operation_label.text = i18n.tr("Wrong Answer, Try Again")
                }   
            }
    }

    Button {
        text: i18n.tr("Cancel")
        onClicked: PopupUtils.close(delete_operation_dialog)
    }
    
}
