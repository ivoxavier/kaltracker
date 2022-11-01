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
import Ubuntu.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Ubuntu.Components.ListItems 1.3 
import Ubuntu.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import "components"
import "../js/ControlSetSexSelection.js" as ControlSetSexSelection


Page{
    id: set_sex_at_birth_page
    objectName: 'SetSexAtBirthPage'
    header: PageHeader {
        visible: true
        title: i18n.tr("About You")

        StyleHints {
                 /*   foregroundColor: "white"
                    backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
                }
        }

    //enables the next button after user clicking in one slotActivity
    property bool is_sex_at_birth_selected : false
    
    Rectangle{
        anchors{
            top: parent.header.bottom
            left : parent.left
            right : parent.right
            bottom : parent.bottom
        }
        color : Suru.theme === 0 ? root.kaltracker_light_theme.background : root.kaltracker_dark_theme.background
    }
    
    Flickable {

        anchors{
            top: parent.header.bottom
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
        

            CompletationBar{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(9)
                value: 49
            }

            BlankSpace{height:units.gu(2)}

            Text{
                Layout.alignment: Qt.AlignCenter  
                text: i18n.tr("Sex Assigned At Birth?")
                font.pixelSize: units.gu(4)
                color : Suru.theme === 0 ? root.kaltracker_light_theme.text_color : root.kaltracker_dark_theme.text_color 
            }

            BlankSpace{height:units.gu(2)}

            SlotBirthSex{
                id: male_slot
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(9)
                Layout.preferredHeight: units.gu(7)
                //TRANSLATORS PLease Keep This Letters All Capital
                text: i18n.tr("MALE")
                img_path:"../assets/male-svgrepo-com.svg"
                color : Suru.theme === 0 ? root.kaltracker_light_theme.slot_add_meal : root.kaltracker_dark_theme.slot_add_meal 
                MouseArea{
                    anchors.fill: parent
                    onClicked: ControlSetSexSelection.selectSex(0)
                }
            }

            BlankSpace{}

            SlotBirthSex{
                id: female_slot
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(9)
                Layout.preferredHeight: units.gu(7)
                //TRANSLATORS PLease Keep This Letters All Capital
                text: i18n.tr("FEMALE")
                img_path:"../assets/female-gender-svgrepo-com.svg"
                color : Suru.theme === 0 ? root.kaltracker_light_theme.slot_add_meal : root.kaltracker_dark_theme.slot_add_meal
                MouseArea{
                    anchors.fill: parent
                    onClicked: ControlSetSexSelection.selectSex(1)   
                }
            }

            BlankSpace{height:units.gu(22)}

            Button{
                id: next_button
                Layout.alignment: Qt.AlignCenter
                text: i18n.tr("Next")
                enabled: set_sex_at_birth_page.is_sex_at_birth_selected
                color : UbuntuColors.green
                onClicked:{
                    page_stack.push(set_age_page)
                }    
            } 
        }  
    }  
}