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
    id: deleteOperationDialog
    property string msg
    property color  labelColor;

    title: i18n.tr("Delete")
    Label{
        text: i18n.tr("Deletes your *" + msg + "* records." + '\n' + "No recovery possible")
        color: labelColor
    }

    
    TextField {
                id: confirmDeleteCode
                width: units.gu(12)
                placeholderText: i18n.tr("Type '123' to confirm")
                 horizontalAlignment: TextInput.AlignHCenter
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator {}
    }

    Label{id: operationResultLabel; color: UbuntuColors.red}

    Row{
        spacing: units.gu(10)
        Button {
            text: i18n.tr("Cancel")
            color: UbuntuColors.green
            onClicked:{
                PopupUtils.close(deleteOperationDialog)
            }

        }

        Button {
            text: i18n.tr("Delete")
            color: UbuntuColors.red
            onClicked:{
                if (confirmDeleteCode.text === "123"){

                    switch(msg){
                        case "today":
                            DataBase.deleteTodayIngestions()
                            root.initDB()
                            root.refreshListModel()
                            PopupUtils.close(deleteOperationDialog)
                        break
                        case "all":
                            DataBase.deleteAllIngestions()
                            root.initDB()
                            root.refreshListModel()
                            PopupUtils.close(deleteOperationDialog)
                        break

                        default:
                            operationResultLabel.text = i18n.tr("Something went wrong")
                    }

                } else {

                    operationResultLabel.text = i18n.tr("Wrong code, try again")
    
                }   
            }
        }
    }
}
