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
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import "components"
import "style"


Page{
    id: login_page
    objectName: 'LoginPage'
    header: PageHeader {visible: false}

    BackgroundStyle{}
    
    Flickable {
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentWidth: parent.width
        contentHeight: main_column.height  

        interactive : root.height > root.width ? false : true

        ColumnLayout{
            id: main_column
            width: root.width

            BlankSpace{height: units.gu(4)}

            Text{
                Layout.alignment: Qt.AlignCenter 
                text: i18n.tr("Welcome")
                font.pixelSize: units.gu(4) 
                color: app_style.label.labelColor 
            }

            BlankSpace{height: units.gu(3)}

            LomiriShape{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: units.gu(12)
                Layout.preferredHeight: units.gu(12)
                radius: "large"
                aspect: LomiriShape.DropShadow
                source : Image{
                    source : "../assets/logo.svg"
                }
            }

            Text{
                Layout.alignment: Qt.AlignCenter 
                text: "KalTracker"
                font.pixelSize: units.gu(3) 
                color: app_style.label.labelColor  
            }


            BlankSpace{height:units.gu(7)}

            Button{
                id: next_button
                Layout.alignment: Qt.AlignCenter
                text: i18n.tr("Start")
                color : app_style.button.confirmButton.buttonColor 
                onClicked:{
                    page_stack.push(user_profile_config_page)
                }
            } 
        }  
    }          
}