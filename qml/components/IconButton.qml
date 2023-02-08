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
//import QtQuick.Controls 2.2 as QC
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import Lomiri.Components.Pickers 1.3
import "../style"

AbstractButton {
	id: button

    //public api
	property alias icon_name: icon.name
    property alias icon_source: icon.source

	width: units.gu(6)
	height: units.gu(6)
	opacity: 0.7//button.pressed ? 0.5 : (enabled ? 1 : 0.2)
    z: 100
	Behavior on opacity {
		LomiriNumberAnimation { }
	}

	Rectangle {
		id: shape		
        anchors.centerIn: parent
        height: units.gu(7.5)
        width:  height
		color: app_style.abstractButton.buttonColor
		radius: height*0.5
	}

	Icon {
		id: icon
		anchors.fill: parent
		z: 1
		color: app_style.abstractButton.iconColor
	}
}