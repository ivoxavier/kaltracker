/*
 * 2022-2026 Ivo Xavier 
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
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import Lomiri.Content 1.3
import "../components"
import "../theme"


Page {
    id: body_measures_page
    objectName: 'BodyMeasuresPage'
    header: PageHeader {
        title: i18n.tr("Body Measures")
    }

    BackgroundStyle{}

    // properties updated from C++
    property int user_height: 0
    property double user_weight: 0
    property int user_sex_at_birth: 0
    property double user_bmi: 0
    property int user_ap_hi: 0
    property int user_ap_lo: 0

    Component.onCompleted: {
        var userData = userRepository.getUser();
        if (userData) {
            user_height = userData.height;
            user_weight = userData.weight;
            user_sex_at_birth = userData.sex_at_birth;
            user_ap_hi = userData.ap_hi;
            user_ap_lo = userData.ap_lo;
            user_bmi = userRepository.getBmi(user_height, user_weight);
        }
    }

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
        
        interactive: root.height > root.width ? false : true

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
                message: {
                    var index = userRepository.getBmiIndex(user_bmi);
                    if (index === 1) return i18n.tr('Low Weigth');
                    if (index === 2) return i18n.tr('Normal Weigth');
                    if (index === 3) return i18n.tr('Weigth Exceed');
                    if (index === 4) return i18n.tr('Pre-Obesity');
                    return i18n.tr('Obesity');
                }
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
                source: "../../assets/balance_icon.svg"
                height: units.gu(3.5)
            }

            SlotIndexes{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width - units.gu(28)
                Layout.preferredHeight: units.gu(12)
                value: userRepository.getIdealWeight(user_sex_at_birth, user_height) 
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
                source: "../../assets/blood_icon.svg"
                height: units.gu(3.5)
            }
            
            SlotIndexes{
                Layout.alignment: Qt.AlignCenter
                Layout.preferredWidth: root.width
                Layout.preferredHeight: units.gu(12)
                visible: app_settings.is_blood_pressure_defined
                value: {
                    var index = userRepository.getBloodPressureIndex(user_ap_hi, user_ap_lo);
                    if (index === 0) return i18n.tr("Normal");
                    if (index === 1) return i18n.tr("Elevated");
                    if (index === 2) return i18n.tr("High Blood Pressure Stage I");
                    if (index === 3) return i18n.tr("High Blood Pressure Stage II");
                    return i18n.tr("Hypertensive Crisis");
                }
            }
        }  
    }
}