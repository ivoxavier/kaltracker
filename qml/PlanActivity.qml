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
import QtCharts 2.3
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import "components"


ColumnLayout{
    width: root.width

    function selectPlan(plan){
        //Change the value of Object user_profile
        user_profile_config_page.user_profile.plan = true

        //property to store the user goal for further calories daily objectiv calculation.
        root.user_goal = plan == 0 ? 0 : 0

        //property to store type of plan
        root.type_goal = plan == 0 ? "maintain" : plan == 1 ? "loose" : "gain"

        //highlight Slots selection 
        maintain_weight_slot.text_color = plan == 0 ? LomiriColors.green : "black"
        loose_weight_slot.text_color = plan == 1 ? LomiriColors.green : "black"
        gain_weight_slot.text_color = plan == 2 ? LomiriColors.green : "black"

        //when true this property triggers the dialog propomt user to select how we would like to loose or gain weight
        user_profile_config_page.is_loose_weight = plan == 1 ? true : false
        user_profile_config_page.is_gain_weight = plan == 2 ? true : false
    }


    function selectActivity(activity){
        //Change the value of Object user_profile
        user_profile_config_page.user_profile.activity = true

        //property to store type of plan
        root.user_activity_level = activity == 0 ? 0 : activity == 1 ? 1 : activity == 2 ? 2 : 3

        //highlight Slots selection 
        very_light_slot.text_color = activity == 0 ? LomiriColors.green : "black"
        light_slot.text_color = activity == 1 ? LomiriColors.green : "black"
        moderate_slot.text_color = activity == 2 ? LomiriColors.green : "black"
        heavy_slot.text_color = activity == 3 ? LomiriColors.green : "black"
    }



    ListItem{
        width: root.width
        divider.visible: false
        ListItemLayout{
            subtitle.text: i18n.tr("Plan")
            subtitle.font.bold: true
        }
    }

    SlotPlans{
        id: loose_weight_slot
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(9)
        Layout.preferredHeight: units.gu(7)
        //TRANSLATORS Please Keep All Letters Capital
        text: i18n.tr("LOOSE WEIGHT")
        img_path:"../assets/shoe-svgrepo-com.svg"
        color : Suru.theme === 0 ? root.kaltracker_light_theme.slot_add_meal : root.kaltracker_dark_theme.slot_add_meal
        MouseArea{
            anchors.fill: parent
            onClicked: {
                selectPlan(1)
                PopupUtils.open(loose_weight_definition_dialog)
            }
        }
    }

    BlankSpace{}

    SlotPlans{
        id: maintain_weight_slot
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(9)
        Layout.preferredHeight: units.gu(7)
        //TRANSLATORS Please Keep All Letters Capital
        text: i18n.tr("MAINTAIN WEIGHT")
        img_path:"../assets/kilograms-justice-svgrepo-com.svg"
        color : Suru.theme === 0 ? root.kaltracker_light_theme.slot_add_meal : root.kaltracker_dark_theme.slot_add_meal 
        MouseArea{
            anchors.fill: parent
            onClicked: selectPlan(0) 
        }
    }

    BlankSpace{}

    SlotPlans{
        id: gain_weight_slot
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(9)
        Layout.preferredHeight: units.gu(7)
        //TRANSLATORS Please Keep All Letters Capital
        text: i18n.tr("GAIN WEIGHT")
        img_path:"../assets/dumbbell-gym-svgrepo-com.svg"
        color : Suru.theme === 0 ? root.kaltracker_light_theme.slot_add_meal : root.kaltracker_dark_theme.slot_add_meal  
        MouseArea{
            anchors.fill: parent
            onClicked: {
                selectPlan(2)
                PopupUtils.open(gain_weight_definition_dialog)
            }   
        }
    }

    ListItem{
        width: root.width
        divider.visible: false
        ListItemLayout{
            subtitle.text: i18n.tr("Activity Level")
            subtitle.font.bold: true
        }
    } 

    SlotActivity{
        id: very_light_slot
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(9)
        Layout.preferredHeight: units.gu(7)
        //TRANSLATORS Please Keep All Letters Capital
        text: i18n.tr("VERY LIGHT")
        img_path:"../assets/cooking-stew-svgrepo-com.svg"
        color : Suru.theme === 0 ? root.kaltracker_light_theme.slot_add_meal : root.kaltracker_dark_theme.slot_add_meal
        MouseArea{
            anchors.fill: parent
            onClicked: selectActivity(0)   
        }
    }

    BlankSpace{}

    SlotActivity{
        id: light_slot
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(9)
        Layout.preferredHeight: units.gu(7)
        //TRANSLATORS Please Keep All Letters Capital
        text: i18n.tr("LIGHT")
        img_path:"../assets/walking-the-dog-svgrepo-com.svg"
        color : Suru.theme === 0 ? root.kaltracker_light_theme.slot_add_meal : root.kaltracker_dark_theme.slot_add_meal
        MouseArea{
            anchors.fill: parent
            onClicked: selectActivity(1)
        }
    }

    BlankSpace{}

     SlotActivity{
        id: moderate_slot
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(9)
        Layout.preferredHeight: units.gu(7)
        //TRANSLATORS Please Keep All Letters Capital
        text: i18n.tr("MODERATE")
        img_path:"../assets/cycling-color-svgrepo-com.svg"
        color : Suru.theme === 0 ? root.kaltracker_light_theme.slot_add_meal : root.kaltracker_dark_theme.slot_add_meal
        MouseArea{
            anchors.fill: parent
            onClicked: selectActivity(2)   
        }
    }

    BlankSpace{}

    SlotActivity{
        id: heavy_slot
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(9)
        Layout.preferredHeight: units.gu(7)
        //TRANSLATORS Please Keep All Letters Capital
        text: i18n.tr("HEAVY")
        img_path:"../assets/soccer-svgrepo-com.svg"
        color : Suru.theme === 0 ? root.kaltracker_light_theme.slot_add_meal : root.kaltracker_dark_theme.slot_add_meal
        MouseArea{
            anchors.fill: parent
            onClicked: selectActivity(3) 
        }
    }
}