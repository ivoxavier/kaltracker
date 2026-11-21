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

/*
 * 2022-2026  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 */

import QtQuick 2.9
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import "../theme"

Dialog {
    id: confirm_delete_dialog

    property int confirmed: 0
    property var onConfirm: null

    Label {
        width: parent.width
        text: i18n.tr("Confirm Operation With: YES")
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        horizontalAlignment: Text.AlignHCenter
    }

    ConfirmPicker {
        anchors.horizontalCenter: parent.horizontalCenter
        onSelectedIndexChanged: confirm_delete_dialog.confirmed = selectedIndex
    }

    Label {
        id: operation_label
        width: parent.width
        color: LomiriColors.red
        horizontalAlignment: Text.AlignHCenter
        visible: text !== ""
    }

    Button {
        text: i18n.tr("Delete")
        color: app_style.button.deleteButton.buttonColor
        onClicked: {
            if (confirm_delete_dialog.confirmed === 2) {
                PopupUtils.close(confirm_delete_dialog)
                if (typeof confirm_delete_dialog.onConfirm === "function") {
                    confirm_delete_dialog.onConfirm()
                }
            } else {
                operation_label.text = i18n.tr("Wrong Answer, Try Again")
            }
        }
    }

    Button {
        text: i18n.tr("Cancel")
        onClicked: PopupUtils.close(confirm_delete_dialog)
    }
}
