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
import QtQuick.Controls 2.2 as QQC2
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


    ListItem{
        width: root.width
        divider.visible: false
        ListItemLayout{
            subtitle.text: i18n.tr("Weight")
            subtitle.font.bold: true
        }
    }

    LomiriShape{
        id: weight_shape
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(9)
        Layout.preferredHeight: units.gu(19)
        aspect: LomiriShape.DropShadow
        radius: "large"
        backgroundColor : app_style.shape.shapeColor

        //Stores the weight & height values
        property int weight_value : 50
        property int height_value : 140 //cm

        ColumnLayout{
            anchors.fill: parent

            Label{
                id:weight_value_label
                Layout.alignment: Qt.AlignCenter
                font.pixelSize: units.gu(5)
                font.bold: true
                text:weight_shape.weight_value
            }

            Label{Layout.alignment: Qt.AlignCenter;font.bold: true;text:i18n.tr("KG")}

            RowLayout{
                Layout.alignment: Qt.AlignCenter
                spacing: units.gu(6)
                    Rectangle {
                        width: units.gu(6)
                        height: width
                        color : "transparent"
                        border.color: color
                        border.width: 1
                        radius: width*0.5
                        MouseArea{
                            anchors.fill: parent
                            onClicked:{
                                if(page_stack.currentPage.objectName == "UserProfileConfigPage"){
                                    weight_shape.weight_value-- , logical_fields.user_profile.user_weight = weight_shape.weight_value
                                    user_profile_config_page.user_profile.weight = true
                                }else{
                                    weight_shape.weight_value-- , update_user_values_page.user_weight = weight_shape.weight_value
                                    update_user_values_page.user_profile.weight = true
                                }
                                
                            }
                            
                        }
                        Label {
                            anchors.centerIn: parent
                            font.pixelSize: units.gu(4)
                            color : app_style.label.labelColor 
                            text: "-"
                        }
                    }

                    Rectangle {
                        width: units.gu(6)
                        height: width
                        color : "transparent"
                        border.color: color
                        border.width: 1
                        radius: width*0.5
                        MouseArea{
                            anchors.fill: parent
                            onClicked:{
                                if(page_stack.currentPage.objectName == "UserProfileConfigPage"){
                                    weight_shape.weight_value++ , logical_fields.user_profile.user_weight = weight_shape.weight_value
                                    user_profile_config_page.user_profile.weight = true
                                }else{
                                    weight_shape.weight_value++ , update_user_values_page.update_weight = weight_shape.weight_value
                                    update_user_values_page.user_profile.weight = true
                                }
                                
                            }
                            
                        }
                        Label {
                            anchors.centerIn: parent
                            font.pixelSize: units.gu(4)
                            color : app_style.label.labelColor 
                            text: "+"
                        }
                    }
            }
        }
    }

    ListItem{
        width: root.width
        divider.visible: false
        ListItemLayout{
            subtitle.text: i18n.tr("Height")
            subtitle.font.bold: true
        }
    } 

    Label {
        Layout.alignment: Qt.AlignCenter
        font.pixelSize: units.gu(4)
        color : app_style.label.labelColor  
        text: Math.round(height_slider.value) + i18n.tr("cm")
    }

    QQC2.Slider{
        id: height_slider
        Layout.alignment: Qt.AlignCenter
        Layout.preferredHeight: units.gu(22)
        orientation: Qt.Vertical
        live: true
        from: 100
        value: 140
        to: 250
        onValueChanged: {
            if(page_stack.currentPage.objectName == "UserProfileConfigPage"){
                logical_fields.user_profile.user_height = value
                user_profile_config_page.user_profile.height = true
            }
            else{
                update_user_values_page.update_height = value
                update_user_values_page.user_profile.height = true
            }
        }
    }
}