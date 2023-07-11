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
import QtQuick.LocalStorage 2.12
import Lomiri.Content 1.3
import "components"
import "style"
import "../js/UserTable.js" as UserTable
import "../js/BodyMassIndex.js" as BMI
import "../js/IdealWeight.js" as IBW
import "../js/BloodPressureIndex.js" as BloodPressureIndex


Page{
    id: body_measures_page
    objectName: 'BodyMeasuresPage'
    header: PageHeader {
                //visible: app_settings.is_page_headers_enabled ? true : false
                title: i18n.tr("Body Measures")

                StyleHints {
                  /*  foregroundColor: Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_text : ThemeColors.utFoods_dark_theme_text 
                    backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
                }
            }

    BackgroundStyle{}

    //stores values for bmi calculation
    property int user_height : UserTable.getHeight()
    property int user_weight : UserTable.getWeight()
    property string user_sex_at_birth : UserTable.getSexAtBirth()
    property double user_bmi : BMI.getBmi(user_height, user_weight)
    property var user_ap_hi : UserTable.getApHi()
    property var user_ap_lo : UserTable.getApLo()

    Component{
        id: info_bmi
        MessageDialog{msg: i18n.tr("KalTracker is not taking in consideration your muscule weight. This is ONLY e a reference")}
    }

    
    Flickable {

        anchors{
            top:   parent.header.bottom 
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

            ListItem{
                divider.visible : false
                ListItemLayout{
                    subtitle.text : i18n.tr("Body Mass Index")
                }
            }

            SlotIndexes{
                id: bmi_slot
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(17)
                Layout.preferredHeight: units.gu(9)
                value: user_bmi
                message: BMI.getIndex(user_bmi) == 1 ?
                i18n.tr('Low Weigth') : BMI.getIndex(user_bmi) == 2 ?
                i18n.tr('Normal Weigth') : BMI.getIndex(user_bmi) == 3 ?
                i18n.tr('Weigth Exceed') : BMI.getIndex(user_bmi) == 4 ?
                i18n.tr('Pre-Obesity') : i18n.tr('Obesity')

            }

            Icon{
                Layout.alignment: Qt.AlignCenter
                name: "info"
                height: units.gu(2.5)
                MouseArea{
                    anchors.fill: parent
                    onClicked: PopupUtils.open(info_bmi)
                }
            }

            ListItem{
                divider.visible : false
                ListItemLayout{
                    subtitle.text : i18n.tr("Ideal Weight")
                }
            }

            Icon{
                Layout.alignment: Qt.AlignCenter
                source: "../assets/balance_icon.svg"
                height: units.gu(3.5)
            }

            SlotIndexes{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(28)
                Layout.preferredHeight: units.gu(12)
                value: IBW.getIdealWeight(user_sex_at_birth, user_height) 
                message: i18n.tr("KG")
            }

            ListItem{
                divider.visible : false
                visible: app_settings.is_blood_pressure_defined
                ListItemLayout{
                    subtitle.text : i18n.tr("Blood Pressure")
                }
            }

            Icon{
                Layout.alignment: Qt.AlignCenter
                visible: app_settings.is_blood_pressure_defined
                source: "../assets/blood_icon.svg"
                height: units.gu(3.5)
            }

            
            SlotIndexes{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width// - units.gu(26)
                Layout.preferredHeight: units.gu(12)
                visible: app_settings.is_blood_pressure_defined
                value: BloodPressureIndex.getIndex(user_ap_hi,user_ap_lo) == 0 ?
                i18n.tr("Normal") : BloodPressureIndex.getIndex(user_ap_hi,user_ap_lo) == 1 ?
                i18n.tr("Elevated") : BloodPressureIndex.getIndex(user_ap_hi,user_ap_lo) == 2 ?
                i18n.tr("High Blood Pressure Stage I") : BloodPressureIndex.getIndex(user_ap_hi,user_ap_lo) == 3 ?
                i18n.tr("High Blood Pressure Stage II") : i18n.tr("Hypertensive Crisis")
            

            }

            

        }  
    }
    
}