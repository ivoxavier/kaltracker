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

UbuntuShape{
    id: slot_shape
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    width: parent.width
    height: units.gu(6.5)
    radius: "small"
    aspect: UbuntuShape.Flat 
    backgroundColor : Suru.theme === 0 ? ThemeColors.utFoods_porcelain_theme_background : ThemeColors.utFoods_dark_theme_background
    visible:app_settings.is_page_headers_enabled ? false : true
                       
    Row{
        spacing: units.gu(2.5)
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
                
        Icon{
            id: account_icon
            name: "back"
            height: units.gu(4)
                    
            MouseArea{
                anchors.fill: parent
                onClicked: {
                     page_stack.pop()
                }
            }
        }

        
    }
}  