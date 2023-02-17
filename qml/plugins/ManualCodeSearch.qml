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
import QtQuick.Window 2.0
import Lomiri.Components 1.3
import QtMultimedia 5.12
import QtGraphicalEffects 1.0
import QZXing 3.3
import QtQuick.Controls 2.2 as QQC2
import Lomiri.Content 1.3
import Lomiri.Components.Pickers 1.3
import Lomiri.Components.Popups 1.3
import Qt.labs.settings 1.0
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.3
import "../components"
import "../style"

ColumnLayout{
    width: root.width

    LomiriShape{  
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(2)
        Layout.preferredHeight: units.gu(4)
        radius: "large"
        aspect: LomiriShape.Inset
        backgroundColor: app_style.shape.textInput.shapeColor
        
        TextField{
            anchors.fill: parent
            //overwriteMode: true
            horizontalAlignment: TextField.AlignHCenter
            verticalAlignment: TextField.AlignVCenter
            inputMethodHints: Qt.ImhDigitsOnly
            color : app_style.label.labelColor 
            placeholderText: "5600380894296"
            onTextChanged:{ 
            
            }
        }
    }

}