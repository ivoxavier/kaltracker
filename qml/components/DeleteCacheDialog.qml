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


import QtQuick 2.9
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3



Dialog { 
    id: delete_cache_dialog
    
    property int confirmed

    title: i18n.tr("Delete App Cache")   

    Text {
        id: confirm_delete_code
        width: units.gu(12)
        text: i18n.tr("Confirm Operation With: YES")
    } 

    Picker {
        width: units.gu(10)
        height: units.gu(5)
        circular: false
        selectedIndex: 0
        model: [ i18n.tr("NO"), i18n.tr("STILL NO"), i18n.tr("NO, TAKE ME TO MUMMY"), i18n.tr("I KNOW WHAT I'M DOING"), i18n.tr("YES")] 
        delegate: PickerDelegate { 
            Label {
                text: modelData                    
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        onSelectedIndexChanged: confirmed = selectedIndex
} 

    Label{id: operation_label; color: UbuntuColors.red}
    
    Button{
        id: delete_button
        text: i18n.tr("Delete")
        color: UbuntuColors.red
        onClicked:{
            if(confirmed == 4){
                py.call('clean_cache.CleanCache.cleanCache', [] ,function(returnValue){console.log(returnValue)})
                PopupUtils.close(delete_cache_dialog)
                PopupUtils.open(operation_result_popover)

            }else{
                operation_label.text = i18n.tr("Wrong Answer, Try Again")
            }
        }
    }  

    Button{
        text: i18n.tr("Cancel")
        color: UbuntuColors.green
        onClicked:{
            PopupUtils.close(delete_cache_dialog)
        }
    }        
}
        

