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

    Text{
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width
        text : i18n.tr("Nutriscore Grade")
        font.pixelSize: units.gu(2)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color : app_style.label.labelColor
    }
    LomiriShape{
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(40)
        Layout.preferredHeight: width//units.gu(12)
        color: ControlFoodsNutriscore.backgroundColor(score_label.text)
        radius: "large"
        aspect: LomiriShape.Inset
        Label{
            id: score_label
            anchors.centerIn: parent
            text: nutriscore_set_food_page
            font.pixelSize: units.gu(4)
            font.capitalization: Font.AllUppercase
            color: "white"
            font.bold : true
        }
    }

    Text{
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width
        font.pixelSize: units.gu(1.5)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color : app_style.label.labelColor
        text : nutriscore_set_food_page === "a" ?
        i18n.tr("Very good nutritional quality") : nutriscore_set_food_page === "b" ?
        i18n.tr("Good nutritional quality") : nutriscore_set_food_page === "c" ?
        i18n.tr("Average nutritional quality") : nutriscore_set_food_page === "d" ?
        i18n.tr("Poor nutritional quality") : nutriscore_set_food_page === "e" ?
        i18n.tr("Bad nutritional quality") : i18n.tr("Unknown")
    }


    BlankSpace{}
    
    Text{
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width
        text : i18n.tr("NOVA Group")
        font.pixelSize: units.gu(2)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color : app_style.label.labelColor
    }

    LomiriShape{
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width - units.gu(40)
        Layout.preferredHeight: width//units.gu(12)
        color: ControlNOVAGroups.backgroundColor(nova_group.text)
        radius: "large"
        aspect: LomiriShape.Inset
        Label{
            id: nova_group
            anchors.centerIn: parent
            text: nova_groups_set_food_page
            font.pixelSize: units.gu(4)
            font.capitalization: Font.AllUppercase
            color: "white"
            font.bold : true
        }
    }
    Text{
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: root.width
        font.pixelSize: units.gu(1.5)
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color : app_style.label.labelColor
        text : nova_groups_set_food_page === "1" ?
        i18n.tr("Unprocessed or minimally processed") : nova_groups_set_food_page === "2" ?
        i18n.tr("Processed culinary ingredients") : nova_groups_set_food_page === "3" ?
        i18n.tr("Processed food") : nova_groups_set_food_page === "4" ?
        i18n.tr("Ultra processed food") : i18n.tr("Unknown") 
    }
}