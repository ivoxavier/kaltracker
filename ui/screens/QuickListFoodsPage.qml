/*
 * 2022-2026  Ivo Xavier
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
import "../components"
import "../theme"

Page {
    id: quick_list_foods_page
    objectName: 'QuickListFoodsPage'


    property int meal_quick_list_foods_page

    readonly property bool isSearching: search_text.text.trim().length > 0

    function escapeRegExp(str) {
        return str.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    }

    header: PageHeader {
        contents: TextField {
            id: search_text
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: units.gu(1)
            }
            placeholderText: i18n.tr("Search foods...")
            hasClearButton: true
            inputMethodHints: Qt.ImhNoPredictiveText

            primaryItem: Icon {
                height: units.gu(2)
                width: units.gu(2)
                name: "find"
                color: app_style.label.secondaryColor
            }

            onTextChanged: search_timer.restart()
        }
    }

    BackgroundStyle {}

    Timer {
        id: search_timer
        interval: 250
        repeat: false
        onTriggered: {
            var query = search_text.text.trim();
            if (query.length === 0) {
                sorted_model.filter.pattern = /.*/;
            } else {
                sorted_model.filter.pattern = new RegExp(escapeRegExp(query), "i");
            }
        }
    }

    SortFilterModel {
        id: sorted_model
        model: UserFoodsList {}
        sort.property: "product_name"
        sort.order: Qt.AscendingOrder
        sortCaseSensitivity: Qt.CaseInsensitive
        filter.property: "product_name"
        filter.pattern: /.*/
    }

    ListViewFoods {
        id: list_view_foods
        visible: list_view_foods.modelCount > 0
        anchors {
            top: parent.header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }

    Column {
        visible: list_view_foods.modelCount === 0
        anchors.centerIn: parent
        width: parent.width - units.gu(6)
        spacing: units.gu(2)
        z: 5

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: units.gu(11)
            height: units.gu(11)
            radius: width / 2
            color: app_style.shape.textInput.shapeColor

            Icon {
                anchors.centerIn: parent
                width: units.gu(5.5)
                height: units.gu(5.5)
                name: quick_list_foods_page.isSearching ? "find" : "empty-symbolic"
                color: app_style.label.secondaryColor
            }
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.pixelSize: units.gu(2)
            font.weight: Font.DemiBold
            color: app_style.label.labelColor
            text: quick_list_foods_page.isSearching
                  ? i18n.tr("No results for \"%1\"").arg(search_text.text.trim())
                  : i18n.tr("No foods registered yet")
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.pixelSize: units.gu(1.5)
            color: app_style.label.secondaryColor
            text: quick_list_foods_page.isSearching
                  ? i18n.tr("You can add it as a new product right away.")
                  : i18n.tr("Tap the buttons below to add a food manually or scan a barcode.")
        }

        Button {
            visible: quick_list_foods_page.isSearching
            anchors.horizontalCenter: parent.horizontalCenter
            text: i18n.tr("Add \"%1\"").arg(search_text.text.trim())
            color: app_style.button.confirmButton.buttonColor
            onClicked: {
                logical_fields.ingestion.product_name = search_text.text.trim();
                page_stack.push(quick_addition_page);
            }
        }
    }

    SlotMultiAddition {
        id: slotMultiAddition
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: units.gu(2)
        width: parent.width - units.gu(5)
        height: units.gu(8)
        selectCount.text: i18n.tr("Total item selected %1").arg(list_view_foods.selectionCount)
        selectSum.text: list_view_foods.getCalSelection() + i18n.tr(" calories")
        visible: opacity > 0
        opacity: list_view_foods.selectionCount > 0 ? 1.0 : 0.0

        Behavior on opacity {
            NumberAnimation { duration: 180; easing.type: Easing.OutQuad }
        }
    }

    Column {
        anchors.right: parent.right
        anchors.bottom: list_view_foods.selectionCount > 0 ? slotMultiAddition.top : parent.bottom
        anchors.margins: units.gu(2)
        spacing: units.gu(2)
        z: 10

        FloatingActionButton {
            id: barcode_button
            iconSource: "../../assets/barcode_icon.svg"
            visible: app_settings.is_api_openfoodsfacts_enabled && quick_addition_button.visible
            onClicked: page_stack.push(scan_page, { meal_scan_page: meal_quick_list_foods_page })
        }

        FloatingActionButton {
            id: quick_addition_button
            iconSource: "../../assets/apple-fruit-svgrepo-com.svg"
            visible: list_view_foods.selectionCount === 0
            onClicked: page_stack.push(quick_addition_page)
        }
    }
}
