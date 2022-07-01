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
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Ubuntu.Components.ListItems 1.3 
import Ubuntu.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import "components"
import "../js/ThemeColors.js" as ThemeColors


Page{
    id: login_page
    objectName: 'LoginPage'
    header: PageHeader {visible: false}


    Rectangle{
    anchors.fill: parent
    gradient: Gradient {
        GradientStop { position: 0.0; color: Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background }
    }
}


    /*Messages --start--*/
    Component{
        id: info_text_dialog
        MessageDialog{msg:i18n.tr("Hi, Thanks For Installing Kaltracker")}
    }

    /*Messages --end--*/

    
    Flickable {
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentWidth: parent.width
        contentHeight: main_column.height  

        //interactive : root.height > root.width ? false : true

        ColumnLayout{
            id: main_column
            width: root.width

            BlankSpace{height: units.gu(4)}

            Text{
                Layout.alignment: Qt.AlignCenter 
                text: i18n.tr("Welcome")
                font.pixelSize: units.gu(4)
                color : "white"   
            }

            BlankSpace{height: units.gu(3)}

            UbuntuShape{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: units.gu(12)
                Layout.preferredHeight: units.gu(12)
                radius: "large"
                aspect: UbuntuShape.DropShadow
                source : Image{
                    source : "../assets/logo.svg"
                }
            }

            BlankSpace{height:units.gu(4)}

            Button{
                id: next_button
                Layout.alignment: Qt.AlignCenter
                text: i18n.tr("Start")
                color : UbuntuColors.green
                onClicked:{
                    page_stack.push(set_plan_page)
                }
            } 
        }  
    }
    Component.onCompleted:{
        PopupUtils.open(info_text_dialog)
    }            
}