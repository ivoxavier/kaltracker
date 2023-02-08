/*
 * 2022-2023 Ivo Xavier
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
import QtQuick.Controls 2.2 as QQC2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import "components"
import "style"


Page{
    id: user_profile_config_page
    objectName: 'UserProfileConfigPage'
    header: PageHeader {
        visible: true
        title: swipe_view.currentIndex == 0 ?
        i18n.tr("Objective") : swipe_view.currentIndex == 1 ?
        i18n.tr("Sex & Age") : i18n.tr("Height & Weight")
        

        StyleHints {
          /*  foregroundColor: "white"
            backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
        }

        ActionBar {
            id: head_action_bar
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            visible: false
            StyleHints {backgroundColor: app_style.mainView.backgroundColor}

            numberOfSlots: 1
            actions:[  Action{
                    iconName: "tick"
                    text: i18n.tr("Calculate")
                    onTriggered: PopupUtils.open(calculate_recommended_calories_dialog)  
                }
            ]
        }

    }

    BackgroundStyle{}

    function showTick(){
        //assign true if all values from Object are set to true
        var is_user_profile_set = Object.values(user_profile_config_page.user_profile).every(
                    value => value === true
        )
        
        if(is_user_profile_set){
            head_action_bar.visible = true
            timer_profile_config.running = false
        }
    }

    Timer{
        id: timer_profile_config
        interval: 500; running: true; repeat: true
        onTriggered: showTick()
    }
  
    //when true this property triggers the dialog propomt user to select how we would like to loose or gain weight
    property bool is_loose_weight: false
    property bool is_gain_weight: false
    
    //Object that when all its values became true make 'tick' icon availabe
    property var user_profile:({
        plan: false,
        activity: false,
        sex: false,
        age: false,
        weight: false,
        height: false
    })

    /*  Dialogs */
    Component{
        id: loose_weight_definition_dialog
        GoalDefinitionDialog{type_of_goal: i18n.tr("loose")}
    }

    Component{
        id: gain_weight_definition_dialog
        GoalDefinitionDialog{type_of_goal: i18n.tr("gain")}
    }

    Component{
        id: calculate_recommended_calories_dialog
        RecommendedCaloriesDialog{}
    }
    
    Component{
        id: help_dialog
        MessageDialog{msg: i18n.tr("Very Light Include: Driving, Typing, Sewing, Ironing, Cooking.\n\nLight Include: Walking 5 km, House Cleaning, Golf.\n\nModerate Include: Walking 6 km, Dancing, Tennis, Cycling.\n\nHeavy Include: Running, Soccer, Basketball, Football.")}
    }

     
    QQC2.SwipeView{
        id: swipe_view
        currentIndex:0
        anchors.top:parent.header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height
        
        Item{
            //index 0
            Flickable{
                anchors.fill: parent
                contentWidth: swipe_view.width
                contentHeight: planActivity.implicitHeight

                PlanActivity{id:planActivity}
            }
        }
        Item{
            //index 1
            Flickable{
                anchors.fill: parent
                contentWidth: swipe_view.width
                contentHeight: sexAge.implicitHeight
                interactive: false

                SexAge{id:sexAge}
            }
        }
        Item{
            //index 2
            Flickable{
                anchors.fill: parent
                contentWidth: swipe_view.width
                contentHeight: heightWeight.implicitHeight
                interactive: false

                HeightWeight{id:heightWeight}
            }
        }
    }

    QQC2.PageIndicator{
        id: swipe_view_indicator
        count: swipe_view.count
        currentIndex: swipe_view.currentIndex
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter   
    }
}