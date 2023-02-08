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
import QtQuick.Layouts 1.3
import QtQuick.Controls.Suru 2.2
import "../style"

Dialog {
    id: msg_dialog

    //public API
    property alias msg : label_msg.text

    Text{
        id: label_msg
        Layout.alignment: Qt.AlignCenter
        font.pixelSize: units.gu(2)
        width: parent.width
        wrapMode: Text.Wrap;
        horizontalAlignment: Text.AlignJustify    
        color : app_style.label.labelColor  
    }
    
    Button {
        text: i18n.tr("Back")
        onClicked:{
            PopupUtils.close(msg_dialog)
        } 
    }
}