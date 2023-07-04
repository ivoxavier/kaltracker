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
import QtCharts 2.3
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import Lomiri.Content 1.3
import "components"
import "style"
import "plugins"
import "../js/UserTable.js" as UserTable
import "../js/UpdateUserTable.js" as UpdateUserTable
import "../js/RecommendedCalories.js" as RecommendedCalories
import "../js/DefineGoalCalories.js" as DefinePeriod


Page{
    id: update_user_values_page
    objectName: 'UpdateUserValuesPage'
    header: PageHeader {

        title: swipe_view.currentIndex == 0 ?
        i18n.tr("Objective") : swipe_view.currentIndex == 1 ?
        i18n.tr("Age") : swipe_view.currentIndex == 2 ?
        i18n.tr("Height & Weight") :i18n.tr("Blood Pressure")
        StyleHints {
            /*foregroundColor: "white"
            backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
        }
    }

    BackgroundStyle{}


    property bool is_loose_weight : false
    property bool is_gain_weight : false


    function showTick(){
        //assign true if all values from Object are set to true
        var is_user_profile_set = Object.values(update_user_values_page.user_profile).every(
                    value => value === true
        )
        
        if(is_user_profile_set){
            tick_user_detais.visible = true
        }

        var is_blood_pressure_set = Object.values(update_user_values_page.blood_pressure).every(
                    value => value === true
        )

        if(is_blood_pressure_set){
            tick_user_blood_pressure.visible = true
        }
    }

    Timer{
        id: timer_profile_config
        interval: 200; running: true; repeat: true
        onTriggered: showTick()
    }

    //Object that when all its values became true make 'tick' icon availabe
    property var user_profile:({
        plan: false,
        activity: false,
        age: false,
        weight: false,
        height: false
    })

    property var blood_pressure:({
        ap_hi: false,
        ap_lo: false
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

    Component{
        id: state_updating_blood_pressure_dialog
        UpdateUserBloodPressureDialog{}
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
                interactive: true

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
        Item{
            //index 3
            Flickable{
                anchors.fill: parent
                contentWidth: swipe_view.width
                contentHeight: bloodPressure.implicitHeight
                interactive: false

                BloodPressure{id:bloodPressure}
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

    RowAbstractUpdateButton{
        id: tick_user_detais
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        visible: false
    }

    RowAbstractUpdateBloodPressureButton{
        id: tick_user_blood_pressure
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: tick_user_detais.visible ? tick_user_detais.top : parent.bottom
        visible: false
    }

    Component.onCompleted: logical_fields.user_profile.user_sex_at_birth = UserTable.getSexAtBirth()
}