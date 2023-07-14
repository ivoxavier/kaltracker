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
import QtQuick.LocalStorage 2.12
import QtQuick.Controls.Suru 2.2
import "components"
import "style"
import "logicalFields"
import "../js/GetData.js" as GetData
import "../js/DefineMacroNutriensPerDay.js" as DefineMacroNutriensPerDay
import "../js/ControlFoodsNutriscore.js" as ControlFoodsNutriscore
import "../js/IngestionsTable.js" as IngestionsTable

Page{
    id: home_page
    objectName: 'HomePage'
    header: PageHeader {visible:false}

    BackgroundStyle{}

    //stores the amount of days user wants to getback to (re)ingest
    property int amount_of_days_back : 1

    ListModel{id: filtered_meal_model}
    
    //this component is need to initializate the db. It's linked to main view so it runs everytime the iniDB signal is emitted
    //without it the dashboard will not update untill a close and opening the app again
    Connections{
        target: root
        onInitDB:{
            GetData.getTotalCalConsumed()
            GetData.getTotalCalRemaining()
            GetData.getBreakfastCalories()
            GetData.getLunchCalories()
            GetData.getDinnerCalories()
            GetData.getSnacksCalories()
            GetData.getTotalFoodsConsumed()
            GetData.getCups()
            GetData.getCarboConsumed()
            GetData.getFatConsumed()
            GetData.getProteinConsumed()
        }
    }


    //popus a datepicker
    Component{
        id: date_popUP
        DateNavigation{}
    }

    //popus a dialog for adding note
    Component{
        id: add_note_dialog
        AddNoteDialog{}
    }

    //message confirming the ingestion on bottom 
    Component{
        id: operation_sucess
        MessageDialog{
            msg: i18n.tr("Ingestion Saved!")
        }
    }

    //popUPs a dialog to notify user that app is cleaning old ingestions
    Component{
        id: notification_pop
        NotifyAutoCleanPop{}
    }

    Flickable {
        id: flickable
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentWidth: parent.width
        contentHeight: main_column.height
        ColumnLayout{
            id: main_column
            width: root.width

            Icon{
                Layout.alignment: Qt.AlignRight
                name : "navigation-menu"
                height: units.gu(3.5)
                MouseArea{
                    anchors.fill: parent
                    onClicked: page_stack.push(menu_page)
                }
             }
            

            CaloriesCircleChart{Layout.alignment: Qt.AlignCenter}

            BlankSpace{}

            RowLayout{
                Layout.alignment: Qt.AlignCenter
                width: parent.width
                spacing: units.gu(1.5)

                SlotDashboardIndicators{
                    Layout.preferredWidth: units.gu(13)
                    Layout.preferredHeight: units.gu(5)
                    slot_indicatior: logical_fields.metrics.total_foods_consumed
                    //TRANSLATORS Please Keep This Only One Word
                    slot_icon_label: i18n.tr("FOODS")
                }


                SlotDashboardIcons{
                    Layout.preferredWidth: units.gu(13)
                    Layout.preferredHeight: units.gu(5)
                    slot_icon : "attachment"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: PopupUtils.open(add_note_dialog)
                    }
                }

                SlotDashboardIndicators{
                    Layout.preferredWidth: units.gu(13)
                    Layout.preferredHeight: units.gu(5)
                    slot_indicatior: logical_fields.user_profile.plan.cal_consumed
                    //TRANSLATORS Please Keep This Only One Word
                    slot_icon_label: i18n.tr("CONSUMED")
                }
                
            }

            BlankSpace{}

            RowLayout{
                Layout.alignment: Qt.AlignCenter
                spacing: units.gu(1.5)

                SlotNutrientProgress{
                    Layout.preferredWidth: units.gu(13)
                    Layout.preferredHeight: units.gu(5)
                    //TRANSLATORS Please Keep This Only One Word
                    slot_icon_label: i18n.tr("FAT")
                    bar_color: app_style.progressBar.nutrientBar
                    .fatProgress
                    nutrient_value:  (logical_fields.metrics.total_fat_consumed / DefineMacroNutriensPerDay.fat(app_settings.plan_type) * 100.0) * 0.01
                }

                SlotNutrientProgress{
                    Layout.preferredWidth: units.gu(13)
                    Layout.preferredHeight: units.gu(5)
                    //TRANSLATORS Please Keep This Only One Word
                    slot_icon_label: i18n.tr("CARBO")
                    bar_color: app_style.progressBar.nutrientBar
                    .carbProgress
                    nutrient_value: (logical_fields.metrics.total_carbo_consumed / DefineMacroNutriensPerDay.carbo(app_settings.plan_type) * 100.0) * 0.01
                }


                SlotNutrientProgress{
                    Layout.preferredWidth: units.gu(13)
                    Layout.preferredHeight: units.gu(5)
                    //TRANSLATORS Please Keep This Only One Word
                    slot_icon_label: i18n.tr("PROTEIN")
                    bar_color: app_style.progressBar.nutrientBar
                    .proteinProgress
                    nutrient_value: (logical_fields.metrics.total_protein_consumed / DefineMacroNutriensPerDay.protein(app_settings.plan_type) * 100.0) * 0.01
                }
            }
            
            BlankSpace{height:units.gu(2)}

            RowLayout{
                Layout.alignment: Qt.AlignCenter
                spacing: units.gu(1)
                Icon{id:calendar_icon;Layout.alignment: Qt.AlignVCenter;name:"calendar-app-symbolic";height: units.gu(3.5)}

                Label {
                    id: dateLabel
                    Layout.alignment: Qt.AlignVCenter
                    text: logical_fields.application.date_utils.long_date//root.stringDate
                    font.pixelSize: units.gu(2)
                    color: app_style.label.labelColor
                }

                Icon{
                    id: icon_down
                    Layout.alignment: Qt.AlignVCenter
                    property bool is_clicked : false
                    name: "go-up"
                    height: units.gu(4)
                    rotation: icon_down.is_clicked ? 180 : 0
                    Behavior on rotation {
                        LomiriNumberAnimation {}
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            icon_down.is_clicked = !icon_down.is_clicked
                            PopupUtils.open(date_popUP, dateLabel)
                        }
                    }
                }
            }
            
            BlankSpace{}

            SlotAddMeal{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(9)
                Layout.preferredHeight: units.gu(7)
                title.text: i18n.tr("Breakfast")
                meal_category: 0
                //TRANSLATORS %1 is a format parameter. When translating make sure you write %1
                subtitle.text: i18n.tr("%1 calories").arg(logical_fields.metrics.total_cal_breakfast)
                img_path:"../assets/breakfast-svgrepo-com.svg"
            }  

            SlotAddMeal{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(9)
                Layout.preferredHeight: units.gu(7)
                title.text: i18n.tr("Lunch")
                meal_category: 1
                //TRANSLATORS %1 is a format parameter. When translating make sure you write %1
                subtitle.text: i18n.tr("%1 calories").arg(logical_fields.metrics.total_cal_lunch)
                img_path:"../assets/fried-chicken-meal-svgrepo-com.svg" 
            } 

            SlotAddMeal{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(9)
                Layout.preferredHeight: units.gu(7)
                title.text: i18n.tr("Dinner")
                meal_category: 2
                //TRANSLATORS %1 is a format parameter. When translating make sure you write %1
                subtitle.text: i18n.tr("%1 calories").arg(logical_fields.metrics.total_cal_dinner)
                img_path:"../assets/dinner-svgrepo-com.svg" 
            }

            SlotAddMeal{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(9)
                Layout.preferredHeight: units.gu(7)
                title.text: i18n.tr("Snacks")
                meal_category: 3
                //TRANSLATORS %1 is a format parameter. When translating make sure you write %1
                subtitle.text: i18n.tr("%1 calories").arg(logical_fields.metrics.total_cal_snacks)
                img_path:"../assets/snack-snacks-svgrepo-com.svg" 
            }

            BlankSpace{}

            SlotWaterTracker{
                id: slot_water
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(9)
                Layout.preferredHeight: units.gu(7)
                img_path:"../assets/glass-of-water-svgrepo-com.svg"
                water_cups_drinked : (logical_fields.metrics.total_water_cups * 0.1) 
            }
        }  
    }

    BottomEdge{
        id: bottom_edge
        parent : home_page

        //holds the date for query db
        property var yesterday_formated_date 
        //holds the meal index for query db
        property int meal_filter

        //filter handler
        onMeal_filterChanged : meal_filter == 0 ?
        GetData.getYesterdayBreakfast() : meal_filter == 1 ? 
        GetData.getYesterdayLunch() : meal_filter == 2 ? 
        GetData.getYesterdayDinner() : meal_filter == 3 ?
        GetData.getYesterdaySnacks() : {}

        Component{
            id: meal_filter_dialog
            MealFilterDialog{}
        }

        contentComponent: Page{
            id: bottom_edge_page
        
            height: bottom_edge.height
    
            Item{
                visible: yesterday_foods_list.visible ? false : true
                anchors.centerIn: parent
                height: parent.height / 2
                width: parent.width / 2
                z:100
                Icon {
                    id: empty_icon
                    anchors.fill: parent
                    name: "empty-symbolic"
                    opacity: 0.75
                }

                Label{
                    anchors.top: empty_icon.bottom
                    anchors.horizontalCenter: empty_icon.horizontalCenter
                    text: i18n.tr("Empty List, Register Ingestions First Or Choose A Filter.")
                    opacity: 0.75
                    color: app_style.label.labelColor
                }
            }

            BackgroundStyle{}

            header: PageHeader{
                title : i18n.tr("Your Previous Ingestions")

                StyleHints {
                   /* foregroundColor: "white"
                    backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
                }

                ActionBar{
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    numberOfSlots : 1

                    StyleHints {
                    /*foregroundColor: "white"
                    backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
                }

                    actions : [
                        Action{
                            iconName : "filters"
                            onTriggered : PopupUtils.open(meal_filter_dialog)
                        }
                    ]
                }
            }

           
        
            ListView{
                id: yesterday_foods_list

                anchors{
                    top: parent.header.bottom
                    left : parent.left
                    right : parent.right
                    bottom : parent.bottom
                }

                highlightRangeMode: ListView.ApplyRange
                highlightMoveDuration: LomiriAnimation.SnapDuration
                model : filtered_meal_model
                visible: filtered_meal_model.count == 0 ? false : true
                delegate: ListItem{
                            divider.visible: false
                            ListItemLayout{
                                title.text: name
                                subtitle.text: cal 
                                LomiriShape{
                                    SlotsLayout.position: SlotsLayout.Leading
                    
                                    height: units.gu(6)
                                    width: height
                                    color: ControlFoodsNutriscore.backgroundColor(score_label.text)
                                    radius: "large"
                                    aspect: LomiriShape.Inset
                                    Label{
                                        id: score_label
                                        anchors.centerIn: parent
                                        text: nutriscore
                                        textSize: Label.Large
                                        font.capitalization: Font.AllUppercase
                                        color: "white"
                                    }
                                }
                            }

                            leadingActions: ListItemActions{
                                    actions:[
                                        Action{
                                           iconName : "delete" 
                                           onTriggered:{
                                               IngestionsTable.deleteIngestion(id)
                                               filtered_meal_model.remove(index)
                                           }
                                        }
                                    ]
                                }

                            onClicked:{
                                IngestionsTable.saveIngestion(name,
                                nutriscore, cal,
                                fat, carbo,
                                protein, bottom_edge.meal_filter)
                                PopupUtils.open(operation_sucess)
                                root.initDB()
                            }
                        }
            }
        }
    }
        
    Component.onCompleted:{
        GetData.getTotalCalConsumed()
        GetData.getTotalCalRemaining()
        GetData.getBreakfastCalories()
        GetData.getLunchCalories()
        GetData.getDinnerCalories()
        GetData.getSnacksCalories()
        GetData.getTotalFoodsConsumed()
        GetData.getCups()
        GetData.getCarboConsumed()
        GetData.getFatConsumed()
        GetData.getProteinConsumed()
        const installed_date = new Date(app_settings.using_app_date);
        const year_diff = logical_fields.application.date_utils.current_date.getYear() - installed_date.getYear();
        if (app_settings.is_auto_cleaning && year_diff >= 1) {
            PopupUtils.open(notification_pop);
            IngestionsTable.autoClean();
        }
    }        
}