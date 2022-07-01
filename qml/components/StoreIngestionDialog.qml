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
import QtQuick.Layouts 1.3
import "../../js/UserFoodsListTable.js" as UserFoodsListTable
import "../../js/ControlIngestionStoredDialog.js" as ControlIngestionStoredDialog

Dialog {
    id: msg_dialog
    property alias msg : label_msg.text

    Text{
        id: label_msg
        font.pixelSize: units.gu(2)
        width: parent.width
        color: "black"
        Layout.alignment: Qt.AlignCenter
        wrapMode: Text.Wrap;
        horizontalAlignment: Text.AlignJustify    
        }

    Button {
        text: i18n.tr("I'm not going eat more")
        color: UbuntuColors.green
            onClicked: ControlIngestionStoredDialog.finishingIngestion()
        }

    Button {
        text: i18n.tr("Continue registering...")
        color: UbuntuColors.blue
            onClicked: ControlIngestionStoredDialog.continueIngestion()
        }
}