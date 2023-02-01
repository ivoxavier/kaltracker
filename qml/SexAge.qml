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
import "components"


ColumnLayout{
    width: root.width

    function selectSex(sex){
        //enables the next button after user clicking in one slotActity
        user_profile_config_page.is_sex_at_birth_selected = true

        //property to store type of sex assigned at birth 0 Male 1 Female
        root.user_sex_at_birth = sex == 0 ? 0 : 1

        //highlight Slots selection 
        male_slot.text_color = sex == 0 ? LomiriColors.green : "black"
        female_slot.text_color = sex == 1 ? LomiriColors.green : "black"
    }

    ListItem{
        width: root.width
        divider.visible: false
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
        //TRANSLATORS PLease Keep This Letters All Capital
        text: i18n.tr("MALE")
        img_path:"../assets/male-svgrepo-com.svg"
        color : Suru.theme === 0 ? root.kaltracker_light_theme.slot_add_meal : root.kaltracker_dark_theme.slot_add_meal 
        MouseArea{
            anchors.fill: parent
            onClicked: selectSex(0)
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

        StyleHints {
            highlightBackgroundColor: theme.palette.normal.raised
            highlightColor: LomiriColors.jet
            backgroundColor: theme.palette.normal.base
        }

        circular: false
        model: Array.from(Array(91).keys())
        selectedIndex: 1
        delegate: PickerDelegate {
            Label {
                text: modelData
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

        onSelectedIndexChanged: {
            root.user_age = selectedIndex
        }
    }

}