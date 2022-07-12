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
import QtQuick.LocalStorage 2.12
import QtQuick.Controls.Suru 2.2
import "components"
import "../js/UserTable.js" as UserTable
import "../js/IngestionsTable.js" as IngestionsTable
import "../js/UserFoodsListTable.js" as UserFoodsListTable
import "../js/ThemeColors.js" as ThemeColors

Page{
    id: quick_addition_page
    objectName: 'QuickAdditionPage'
    header: PageHeader {
                title : i18n.tr("Quick Addition")

                sections{
                    model: {[i18n.tr("Details"), i18n.tr("Macros")]}
                    onSelectedIndexChanged: sections.selectedIndex == 0 ? is_details_view = true : is_details_view = false
                }

                StyleHints {
                    /*foregroundColor: "white"
                    backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
            }
        }

    //receives meal category from HomePage.slotAddMeal
    property int meal_quick_addition_page

    //food detail
    property string product_name_quick_addition_page
    property string nutriscore_quick_addition_page : "a"

    //macros for calculating nutriscore
    property int cal_quick_addition_page
    property double carbo_quick_addition_page : 0.0
    property double fat_quick_addition_page : 0.0
    property double protein_quick_addition_page : 0.0
 

    //defines active view
    property bool is_details_view : true
   
   
    Component{
        id: sucess_dialog
        StoreIngestionDialog{msg:i18n.tr("Stored!")}
    }

    Component{
        id: error_dialog
        MessageDialog{msg:i18n.tr("Something went wrong. Please, restart the app and try again.")}
    }

    Timer{id: timer;repeat: false}

    Rectangle{
        anchors{
            top: parent.top
            left : parent.left
            right : parent.right
            bottom : parent.bottom
        }
        color : Suru.theme === 0 ? ThemeColors.utFoods_porcelain_theme_background : ThemeColors.utFoods_dark_theme_background 
    }

    Flickable {
        id: flickable
        anchors{
            top: parent.header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        contentWidth: parent.width
        contentHeight: main_column.height  
        
        ColumnLayout{
            id: main_column
            width: root.width
            
            spacing: units.gu(1)

            BlankSpace{}

            Text{
                Layout.alignment: Qt.AlignCenter
                text: i18n.tr("Product name")
                visible: is_details_view ? true: false
                font.bold : true
                color : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 
            }

            UbuntuShape{  
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(2)
                Layout.preferredHeight: units.gu(4)
                radius: "large"
                aspect: UbuntuShape.Inset
                visible: is_details_view ? true: false
                TextInput{
                    anchors.fill: parent
                    overwriteMode: true
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    color : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text
                    onTextChanged: product_name_quick_addition_page = text
                }
            }

            BlankSpace{}

            Text{
                Layout.alignment: Qt.AlignCenter
                text: i18n.tr("Calories")
                visible: is_details_view ? true: false
                font.bold : true
                color : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 
            }
            
            UbuntuShape{  
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(2)
                Layout.preferredHeight: units.gu(4)
                radius: "large"
                aspect: UbuntuShape.Inset
                visible: is_details_view ? true: false
                
                TextInput{
                    anchors.fill: parent
                    overwriteMode: true
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    inputMethodHints: Qt.ImhDigitsOnly
                    color : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text
                    onEditingFinished:{ 
                        cal_quick_addition_page = text
                    }
                }
            }

            BlankSpace{}

            Text{
                Layout.alignment: Qt.AlignCenter
                text: i18n.tr("Nutriscore Grade")
                visible: is_details_view ? true: false
                font.bold : true
                color : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 
            }

            OptionSelector {
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(14)
                expanded: true
                model: [i18n.tr("A: Very Good Nutritional Quality"),
                i18n.tr("B: Good Nutritional Quality"),
                i18n.tr("C: Average Nutritional Quality"),
                i18n.tr("D: Poor Nutritional Quality"),
                i18n.tr("E: Bad Nutritional Quality")]
                selectedIndex: -1
                visible: is_details_view ? true: false
                onSelectedIndexChanged: {
                    nutriscore_quick_addition_page = selectedIndex == 0 ?
                    "a" : selectedIndex == 1 ?
                    "b" : selectedIndex == 2 ?
                    "c" : selectedIndex == 3 ?
                    "d" : "e"
                }
            }
     
            /*MACROS TAB*/

            Text{
                Layout.alignment: Qt.AlignCenter
                text: i18n.tr("Fat/100g")
                visible: is_details_view ? false: true
                font.bold : true
                color : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 
            }

            Text{
                Layout.alignment: Qt.AlignCenter
                text: fat_quick_addition_page
                visible: is_details_view ? false: true
            }

            UbuntuShape{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(30)
                Layout.preferredHeight: units.gu(3)
                radius: "large"
                aspect: UbuntuShape.DropShadow
                visible: is_details_view ? false: true
                backgroundColor : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_slot_background : ThemeColors.utFoods_dark_theme_slot_background
                NutrientSlider{
                        id: fat_slider
                        anchors.centerIn: parent
                        width: parent.width
                        onPressedChanged: fat_quick_addition_page = Number(value.toFixed(1))
                }
            }

            BlankSpace{}

            Text{
                Layout.alignment: Qt.AlignCenter
                text: i18n.tr("Protein/100g")
                visible: is_details_view ? false: true
                font.bold : true
                color : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 
            }

            Text{
                Layout.alignment: Qt.AlignCenter
                text: protein_quick_addition_page
                visible: is_details_view ? false: true
            }

            UbuntuShape{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(30)
                Layout.preferredHeight: units.gu(3)
                radius: "large"
                aspect: UbuntuShape.DropShadow
                visible: is_details_view ? false: true
                backgroundColor : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_slot_background : ThemeColors.utFoods_dark_theme_slot_background
                NutrientSlider{
                        anchors.centerIn: parent
                        width: parent.width
                        onPressedChanged : {
                            protein_quick_addition_page = Number(value.toFixed(1))
                        }    
                    }
            }

            BlankSpace{}

            Text{
                Layout.alignment: Qt.AlignCenter
                text: i18n.tr("Carbo/100g")
                visible: is_details_view ? false: true
                font.bold : true
                color : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 
            }

            Text{
                Layout.alignment: Qt.AlignCenter
                text: carbo_quick_addition_page
                visible: is_details_view ? false: true
            }

            UbuntuShape{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(30)
                Layout.preferredHeight: units.gu(3)
                radius: "large"
                aspect: UbuntuShape.DropShadow
                visible: is_details_view ? false: true
                backgroundColor : Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_slot_background : ThemeColors.utFoods_dark_theme_slot_background
                NutrientSlider{
                        anchors.centerIn: parent
                        width: parent.width
                        onPressedChanged : carbo_quick_addition_page = Number(value.toFixed(1))
                    }
            }           
        }  
    }
    RowAbstractConfirmButton{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }
}