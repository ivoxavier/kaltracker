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


ColumnLayout{
    width: root.width


    ListItem{
        width: root.width
        divider.visible: false
        ListItemLayout{
            subtitle.text: i18n.tr("Systolic Presure (High Pressure)")
            subtitle.font.bold: true
        }
    }

    LomiriShape{
        id: systolic_shape
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(9)
        Layout.preferredHeight: units.gu(19)
        aspect: LomiriShape.DropShadow
        radius: "large"
        backgroundColor : app_style.shape.shapeColor

        //Stores the systolic_value & diastolic_value
        property int systolic_value : 120
        

        ColumnLayout{
            anchors.fill: parent

            Label{
                id:systolic_value_label
                Layout.alignment: Qt.AlignCenter
                font.pixelSize: units.gu(5)
                font.bold: true
                text:systolic_shape.systolic_value
            }

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
                                systolic_shape.systolic_value-- , update_user_values_page.update_ap_hi = systolic_shape.systolic_value
                                update_user_values_page.blood_pressure.ap_hi = true
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
                                systolic_shape.systolic_value++ , update_user_values_page.update_ap_lo = systolic_shape.systolic_value
                                update_user_values_page.blood_pressure.ap_hi = true
                                
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
            subtitle.text: i18n.tr("Diastolic Presure (Low Pressure)")
            subtitle.font.bold: true
        }
    } 
    LomiriShape{
        id: diastolic_shape
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(9)
        Layout.preferredHeight: units.gu(19)
        aspect: LomiriShape.DropShadow
        radius: "large"
        backgroundColor : app_style.shape.shapeColor

        property int diastolic_value : 80

        ColumnLayout{
            anchors.fill: parent

            Label{
                id:diastolic_value_label
                Layout.alignment: Qt.AlignCenter
                font.pixelSize: units.gu(5)
                font.bold: true
                text:diastolic_shape.diastolic_value
            }

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
                                diastolic_shape.diastolic_value-- , update_user_values_page.update_ap_lo = diastolic_shape.diastolic_value
                                update_user_values_page.blood_pressure.ap_lo = true
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
                                diastolic_shape.diastolic_value++ , update_user_values_page.update_ap_hi = diastolic_shape.diastolic_value
                                update_user_values_page.blood_pressure.ap_lo = true
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
}
