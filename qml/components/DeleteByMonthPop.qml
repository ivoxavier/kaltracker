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
import Lomiri.Components.Pickers 1.3
import QtQuick.LocalStorage 2.12
import "../style"
import "../../js/IngestionsTable.js" as  IngestionsTable



Dialog { 
    id: delete_month_year_dialog
    property string month_to_delete
    property string year_to_delete
    property int confirmed

    title: i18n.tr("Enter Month & Year")   

    Text {
        id: confirm_delete_code
        width: units.gu(12)
        text: i18n.tr("Confirm Operation With: YES")
        color: app_style.label.labelColor
    } 

    TextField {
        id: month_to_delete_entry
        width: units.gu(8)
        placeholderText: i18n.tr("Month From 1 to 12")
        horizontalAlignment: TextInput.AlignHCenter
        inputMethodHints: Qt.ImhDigitsOnly
        validator: IntValidator{}
        color: app_style.label.labelColor
        onTextChanged:{
            if (month_to_delete_entry.text <= 9){
                //necessary as date formart in database is 'yyyy-mm-dd'
                month_to_delete = `${0}${month_to_delete_entry.text}`
            }
            else{
                month_to_delete = month_to_delete_entry.text
            }
        }
    }

    TextField {
        id: year_to_delete_entry
        width: units.gu(9)
        placeholderText: i18n.tr("Year")
        horizontalAlignment: TextInput.AlignHCenter
        inputMethodHints: Qt.ImhDigitsOnly
        validator: IntValidator{}
        color: app_style.label.labelColor
        onTextChanged:{
            year_to_delete = year_to_delete_entry.text
        }
    }

    ConfirmPicker{onSelectedIndexChanged: confirmed = selectedIndex}

    Label{id: operation_label; color: app_style.label.labelError.labelColor}
    
    Button{
        id: delete_button
        text: i18n.tr("Delete")
        color: app_style.button.deleteButton.buttonColor
        onClicked:{
            if(confirmed == 2){
                IngestionsTable.deleteMonthYearIngestion(month_to_delete, year_to_delete)
                root.initDB()
                //root.refreshListModel()
                PopupUtils.close(delete_month_year_dialog)
                PopupUtils.open(operation_result_popover)

            }else{
                operation_label.text = i18n.tr("Wrong Answer, Try Again")
            }
        }
    }  

    Button{
        text: i18n.tr("Cancel")
        onClicked:{
            PopupUtils.close(delete_month_year_dialog)
        }
    }        
}