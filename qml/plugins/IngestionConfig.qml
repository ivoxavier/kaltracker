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
import "../components"
import "../style"
import "../logicalFields"
import "../../js/Chart.js" as Charts
import "../../js/QChartJsTypes.js" as ChartTypes
import "../../js/UserTable.js" as UserTable
import "../../js/IngestionsTable.js" as IngestionsTable
import "../../js/UserFoodsListTable.js" as UserFoodsListTable


ColumnLayout{
    width: root.width
    spacing: units.gu(1)

    Text{
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width
        text: logical_fields.ingestion.product_name
        font.pixelSize: units.gu(4)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color : app_style.label.labelColor
    }

    Text{
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width
        text: i18n.tr("Calories: %1 ").arg(logical_fields.ingestion.cal_ingested) 
        font.pixelSize: units.gu(3)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color : app_style.label.labelColor
    }


    ListItem{
        divider.visible : false
        ListItemLayout{
            title.text: i18n.tr("Fat: %1gr").arg(logical_fields.ingestion.fat_ingested)
            title.font.bold : false
            NutrientIcon{img_path: "../../assets/olive-oil-svgrepo-com.svg"} 
        }
    }

    ListItem{
        divider.visible : false
        ListItemLayout{
            title.text: i18n.tr("Protein: %1gr").arg(logical_fields.ingestion.protein_ingested)
            title.font.bold : false
            NutrientIcon{img_path: "../../assets/cheese-svgrepo-com.svg"}      
        }
    }

    ListItem{
        divider.visible : false
        
        ListItemLayout{
            title.text: i18n.tr("Carbohydrates: %1gr").arg(logical_fields.ingestion.carbo_ingested)
            title.font.bold : false
            NutrientIcon{img_path: "../../assets/bread-svgrepo-com.svg"}    
        }
    }


    Text{
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width
        text: i18n.tr("Size Portion") 
        font.pixelSize: units.gu(2)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color : app_style.label.labelColor
    }

    SizePicker{
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(12)
        Layout.preferredHeight: units.gu(7)
        onSelectedIndexChanged: {
            selectedIndex == 0 ?
            logical_fields.ingestion.size_portions = 1 : selectedIndex == 1 ?
            logical_fields.ingestion.size_portions = 0.50 : selectedIndex == 2 ?
            logical_fields.ingestion.size_portions = 0.33 : selectedIndex == 3 ?
            logical_fields.ingestion.size_portions = 0.25 : selectedIndex == 4 ?
            logical_fields.ingestion.size_portions = 0.20 : logical_fields.ingestion.size_portions = 0.17
        }
    }

    BlankSpace{}

    Text{
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width
        text: i18n.tr("Quantity")
        font.pixelSize: units.gu(2)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color : app_style.label.labelColor
    }

    LomiriShape{
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(12)
        Layout.preferredHeight: units.gu(12)
        aspect: LomiriShape.DropShadow
        radius: "large"
        backgroundColor : app_style.shape.shapeColor
     
        ColumnLayout{
            anchors.fill: parent

            Label{
                id:weight_value_label
                Layout.alignment: Qt.AlignCenter
                font.pixelSize: units.gu(5)
                font.bold: true
                text:logical_fields.ingestion.quantity_portions
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
                            logical_fields.ingestion.quantity_portions--
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
                            logical_fields.ingestion.quantity_portions++     
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
    BlankSpace{}
}