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
import Lomiri.Components.Pickers 1.3
import QtCharts 2.3
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import "../components"
import "../style"
import "../logicalFields"


ColumnLayout{
    width: root.width

    function selectSex(sex){
        //Change value of Object user_profile
        user_profile_config_page.user_profile.sex = true

        //property to store type of sex assigned at birth 0 Male 1 Female
        //root.user_sex_at_birth = sex == 0 ? 0 : 1
        logical_fields.user_profile.user_sex_at_birth = sex == 0 ? 0 : 1

        //highlight Slots selection 
        male_slot.text_color = sex == 0 ? LomiriColors.green : "black"
        female_slot.text_color = sex == 1 ? LomiriColors.green : "black"
    }

    ListItem{
        width: root.width
        divider.visible: false
        visible: page_stack.currentPage.objectName == "UpdateUserValuesPage" ? false : true
        ListItemLayout{
            subtitle.text: i18n.tr("At Birth")
            subtitle.font.bold: true
        }
    }

    SlotBirthSex{
        id: male_slot
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(9)
        Layout.preferredHeight: units.gu(7)
        state: page_stack.currentPage.objectName
        //TRANSLATORS Please Keep This Letters All Capital
        text: i18n.tr("MALE")
        img_path:"../../assets/male-svgrepo-com.svg" 
        MouseArea{
            anchors.fill: parent
            onClicked: selectSex(0)
        }
    }

    BlankSpace{visible: page_stack.currentPage.objectName == "UpdateUserValuesPage" ? false : true}

    SlotBirthSex{
        id: female_slot
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(9)
        Layout.preferredHeight: units.gu(7)
        state: page_stack.currentPage.objectName
        //TRANSLATORS Please Keep This Letters All Capital
        text: i18n.tr("FEMALE")
        img_path:"../../assets/female-gender-svgrepo-com.svg"
        MouseArea{
            anchors.fill: parent
            onClicked: selectSex(1)   
        }
    }

    ListItem{
        width: root.width
        divider.visible: false
        ListItemLayout{
            subtitle.text: i18n.tr("Age")
            subtitle.font.bold: true
        }
    } 

    Picker {
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(12)
        Layout.preferredHeight: units.gu(9)

        StyleHints {
            highlightBackgroundColor: app_style.pickers.yearsPicker.highlightBackgroundColor
            highlightColor: app_style.pickers.yearsPicker.highlightColor
            backgroundColor: app_style.pickers.yearsPicker.backgroundColor
        }

        circular: false
        model: Array.from(Array(101).keys())
        selectedIndex: 1
        delegate: PickerDelegate {
            Label {
                //TRANSLATORS Please Add A WhiteSpace Before The Word
                text: modelData + i18n.tr(" years")
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

        onSelectedIndexChanged: {
            if(page_stack.currentPage.objectName == "UserProfileConfigPage"){
                //root.user_age = selectedIndex
                logical_fields.user_profile.user_age = selectedIndex
                user_profile_config_page.user_profile.age = true
            }else{
                update_user_values_page.update_age = selectedIndex 
                update_user_values_page.user_profile.age = true
            }
        }
    }

}