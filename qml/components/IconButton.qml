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
//import QtQuick.Controls 2.2 as QC
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Ubuntu.Components.ListItems 1.3 
import Ubuntu.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import Ubuntu.Components.Pickers 1.3
import "../../js/ThemeColors.js" as ThemeColors

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
		UbuntuNumberAnimation { }
	}

	Rectangle {
		id: shape		
        anchors.centerIn: parent
        height: units.gu(7.5)
        width:  height
		color: Suru.theme === 0 ? "#90ee90" : "#f1f1f1"
		radius: height*0.5
	}

	Icon {
		id: icon
		anchors.fill: parent
		z: 1
		color: UbuntuColors.porcelain
	}
}