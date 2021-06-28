/*
 * 2021  Ivo Xavier
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
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import "../js/DataBaseTools.js" as DataBase


Dialog {
    id: editProfileDialog
    property color  labelColor;

    title: i18n.tr("Change Profile")   
    Row{ 
        spacing: units.gu(2)
        Label{
            anchors.verticalCenter: parent.verticalCenter
            text: i18n.tr("Weight")
        }
    TextField {
        id: weightEdit
        width: units.gu(12)
        text: userSettings.userConfigsWeight
        inputMethodHints: Qt.ImhDigitsOnly
        validator: IntValidator{}
        onTextChanged:{
            if(text != userSettings.userConfigsWeight){
                console.log("weight diffet")
            }else{
                console.log(userSettings.userConfigsWeight)
            }
        }
        
    }
    }

    Row{
        spacing: units.gu(2)
        Label{
            anchors.verticalCenter: parent.verticalCenter
            text: i18n.tr("Height")
        }
    TextField {
        id: heightEdit
        width: units.gu(12)
        text: userSettings.userConfigsHeight
        inputMethodHints: Qt.ImhDigitsOnly
        validator: IntValidator{}
        onTextChanged:{
            if(text > userSettings.userConfigsHeight){
                console.log(text)
                userSettings.userConfigsHeight = text
            }else{
                console.log("false")
            }
        }
    }
    }
    Row{ 
         spacing: units.gu(2)
         Label{
            anchors.verticalCenter: parent.verticalCenter
            text: i18n.tr("Age")
        }
    TextField {
        id: ageEdit
        width: units.gu(12)
        text: userSettings.userConfigsAge
        inputMethodHints: Qt.ImhDigitsOnly
        validator: IntValidator{}
    
        onTextChanged:{
            if(text > userSettings.userConfigsAge){
                console.log(text)
                userSettings.userConfigsAge = text
            }else{
                console.log("false")
            }
        }
    }

    }

    Row{
        spacing: units.gu(10)
        Button {
            text: i18n.tr("Cancel")
            color: UbuntuColors.grey
            onClicked:{
                PopupUtils.close(editProfileDialog)
            }

        }

        Button {
            text: i18n.tr("Save")
            color: UbuntuColors.green
            onClicked:{
                
            }
        }
    }
}
