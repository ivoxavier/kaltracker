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
import "../../js/Chart.js" as Charts
import "../../js/QChartJsTypes.js" as ChartTypes
import "../../js/UserTable.js" as UserTable
import "../../js/IngestionsTable.js" as IngestionsTable
import "../../js/UserFoodsListTable.js" as UserFoodsListTable
import "../../js/ControlFoodsNutriscore.js" as ControlFoodsNutriscore
import "../../js/ControlNOVAGroups.js" as ControlNOVAGroups


ColumnLayout{
    width: root.width
    spacing: units.gu(1)

    Text{
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width
        text : i18n.tr("Macros")
        font.pixelSize: units.gu(2)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color : app_style.label.labelColor
    }

    BlankSpace{}

    Grid {
        id:chart_pie_wrapper
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(6)
        Layout.preferredHeight:  units.gu(17)
        visible: true
        columns:1
        columnSpacing: units.gu(1)

        QChartJs {
            id: chart_pie
            width: parent.width
            height: parent.height
            chartType: ChartTypes.QChartJSTypes.PIE
            chartData: getChartPieValues()
            animation: app_settings.is_graphs_animation_enabled
            chartAnimationEasing: Easing.InOutElastic;
            chartAnimationDuration: 2000;
        }
    }

    BlankSpace{}

    RowLayout{
        Layout.alignment: Qt.AlignCenter
        spacing: units.gu(1)
        
        Label {
            Layout.alignment: Qt.AlignVCenter
            text: i18n.tr("Classified as")
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
                    product_grades.visible = !product_grades.visible 
                    
                }
            }
        }
    }

    RowLayout{
        id: product_grades
        Layout.alignment: Qt.AlignCenter
        visible: false
        spacing: units.gu(1)

        SlotProductGrades{
            grade : nutriscore_set_food_page
            subject : nutriscore_set_food_page === "a" ?
            i18n.tr("Very good nutritional quality") : nutriscore_set_food_page === "b" ?
            i18n.tr("Good nutritional quality") : nutriscore_set_food_page === "c" ?
            i18n.tr("Average nutritional quality") : nutriscore_set_food_page === "d" ?
            i18n.tr("Poor nutritional quality") : nutriscore_set_food_page === "e" ?
            i18n.tr("Bad nutritional quality") : i18n.tr("Unknown")
            color : ControlFoodsNutriscore.backgroundColor(nutriscore_set_food_page)
        }

        SlotProductGrades{
            grade : nova_groups_set_food_page
            subject : nova_groups_set_food_page === "1" ?
            i18n.tr("Unprocessed or minimally processed") : nova_groups_set_food_page === "2" ?
            i18n.tr("Processed culinary ingredients") : nova_groups_set_food_page === "3" ?
            i18n.tr("Processed foods") : nova_groups_set_food_page === "4" ?
            i18n.tr("Ultra-processed foods") : i18n.tr("Unknown")
            color : ControlNOVAGroups.backgroundColor(nova_groups_set_food_page)
        }
    }
}