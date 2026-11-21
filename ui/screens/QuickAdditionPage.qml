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
import QtQuick.Controls 2.2 as QQC2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3
import Lomiri.Components.Popups 1.3
import QtQuick.LocalStorage 2.12
import QtQuick.Controls.Suru 2.2
import "../components"
import "../theme"
import "../plugins"


Page {
    id: quick_addition_page
    objectName: 'QuickAdditionPage'

    readonly property bool isValid: String(logical_fields.ingestion.product_name || "").trim().length > 0
                                    && Number(logical_fields.ingestion.cal) > 0

    header: PageHeader {
        title : swipe_view.currentIndex == 0 ? i18n.tr("Product Details") : i18n.tr("Product Macros")
    }

    BackgroundStyle {}

    Component {
        id: sucess_dialog
        StoreIngestionDialog { msg: i18n.tr("Stored!") }
    }

    Component {
        id: error_dialog
        MessageDialog { msg: i18n.tr("Something went wrong. Please, restart the app and try again.") }
    }

    Timer { id: timer; repeat: false }

    QQC2.SwipeView {
        id: swipe_view
        currentIndex: 0
        anchors.top: parent.header.bottom
        anchors.bottom: parent.bottom
        width: parent.width

        Item {
            // index 0
            Flickable {
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: product_name_calories.implicitHeight
                interactive: true

                ProductNameCalories { id: product_name_calories }
            }
        }

        Item {
            // index 1
            ProductMacros { id: product_macros }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: units.gu(2)
        width: swipe_view_indicator.width + units.gu(4)
        height: swipe_view_indicator.height + units.gu(1)
        color: LomiriColors.inkstone
        opacity: 0.5
        radius: units.gu(2)

        QQC2.PageIndicator {
            id: swipe_view_indicator
            count: swipe_view.count
            currentIndex: swipe_view.currentIndex
            anchors.centerIn: parent
        }
    }

    FloatingActionButton {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: units.gu(8)
        anchors.margins: units.gu(2)
        iconName: "ok"
        z: 10

        enabled: quick_addition_page.isValid
        opacity: quick_addition_page.isValid ? 1.0 : 0.45

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        onClicked: {
            try {
                if (ingestionRepository.checkUserFoodExists(logical_fields.ingestion.product_name) >= 1) {
                    /* REGISTER INGESTION (item already on DB) */
                    ingestionRepository.saveIngestion({
                        "name": String(logical_fields.ingestion.product_name),
                        "nutriscore": String(logical_fields.ingestion.nutriscore),
                        "calories": Number(logical_fields.ingestion.cal),
                        "fat": Number(logical_fields.ingestion.fat),
                        "carbs": Number(logical_fields.ingestion.carbo),
                        "protein": Number(logical_fields.ingestion.protein),
                        "mealType": Number(logical_fields.ingestion.meal_type),
                        "date": logical_fields.application.date_utils.long_date
                    });
                } else {
                    /* CREATE NEW ENTRY & REGISTER INGESTION */
                    ingestionRepository.saveUserFood({
                        "name": String(logical_fields.ingestion.product_name),
                        "nutriscore": String(logical_fields.ingestion.nutriscore),
                        "cal": Number(logical_fields.ingestion.cal),
                        "fat": Number(logical_fields.ingestion.fat),
                        "carbo": Number(logical_fields.ingestion.carbo),
                        "protein": Number(logical_fields.ingestion.protein)
                    });

                    ingestionRepository.saveIngestion({
                        "name": String(logical_fields.ingestion.product_name),
                        "nutriscore": String(logical_fields.ingestion.nutriscore),
                        "calories": Number(logical_fields.ingestion.cal),
                        "fat": Number(logical_fields.ingestion.fat),
                        "carbs": Number(logical_fields.ingestion.carbo),
                        "protein": Number(logical_fields.ingestion.protein),
                        "mealType": Number(logical_fields.ingestion.meal_type),
                        "date": logical_fields.application.date_utils.long_date
                    });
                }

                root.initDB();
                PopupUtils.open(sucess_dialog);
            } catch (err) {
                console.log(err);
                PopupUtils.open(error_dialog);
            }
        }
    }
}
