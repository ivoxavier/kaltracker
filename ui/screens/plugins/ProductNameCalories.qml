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
import QtQuick.Layouts 1.3
import "../components"
import "../theme"

Column {
    id: details_root

    width: parent ? parent.width : root.width
    topPadding: units.gu(2)
    bottomPadding: units.gu(12) // espaço para o FAB e PageIndicator
    spacing: units.gu(2)

    // ==========================================
    // CARTÃO 1: DETALHES DO PRODUTO (NOME + KCAL)
    // ==========================================
    LomiriShape {
        width: parent.width - units.gu(4)
        anchors.horizontalCenter: parent.horizontalCenter
        height: details_col.height + units.gu(4)
        radius: "large"
        aspect: LomiriShape.DropShadow
        backgroundColor: app_style.shape.shapeColor

        Column {
            id: details_col
            width: parent.width - units.gu(3)
            anchors.centerIn: parent
            spacing: units.gu(1.5)

            // Nome do Produto
            Label {
                text: i18n.tr("Product Name")
                font.pixelSize: units.gu(1.7)
                font.weight: Font.DemiBold
                color: app_style.label.labelColor
            }

            TextField {
                id: product_name_input
                width: parent.width
                placeholderText: i18n.tr("e.g. Greek Yogurt, Banana...")
                text: logical_fields.ingestion.product_name || ""
                onTextChanged: logical_fields.ingestion.product_name = text
            }

            // Separador subtil
            Rectangle {
                width: parent.width
                height: units.dp(1)
                color: Qt.rgba(0.5, 0.5, 0.5, 0.15)
            }

            // Calorias
            Label {
                text: i18n.tr("Calories")
                font.pixelSize: units.gu(1.7)
                font.weight: Font.DemiBold
                color: app_style.label.labelColor
            }

            RowLayout {
                width: parent.width
                spacing: units.gu(1.5)

                TextField {
                    id: calories_input
                    Layout.fillWidth: true
                    placeholderText: "0"
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator { bottom: 0; top: 99999 }
                    text: logical_fields.ingestion.cal > 0 ? String(logical_fields.ingestion.cal) : ""
                    onTextChanged: logical_fields.ingestion.cal = Number(text) || 0
                }

                Label {
                    text: i18n.tr("kcal")
                    font.pixelSize: units.gu(1.9)
                    font.weight: Font.DemiBold
                    color: LomiriColors.ash
                }
            }
        }
    }

    // ==========================================
    // CARTÃO 2: NUTRI-SCORE
    // ==========================================
    LomiriShape {
        width: parent.width - units.gu(4)
        anchors.horizontalCenter: parent.horizontalCenter
        height: nutriscore_col.height + units.gu(3)
        radius: "large"
        aspect: LomiriShape.DropShadow
        backgroundColor: app_style.shape.shapeColor

        Column {
            id: nutriscore_col
            width: parent.width - units.gu(3)
            anchors.centerIn: parent
            spacing: units.gu(1)

            Label {
                text: i18n.tr("Nutriscore Grade")
                font.pixelSize: units.gu(1.7)
                font.weight: Font.DemiBold
                color: app_style.label.labelColor
            }

            OptionSelector {
                width: parent.width
                expanded: true
                selectedIndex: -1
                model: [
                    i18n.tr("A: Very Good Nutritional Quality"),
                    i18n.tr("B: Good Nutritional Quality"),
                    i18n.tr("C: Average Nutritional Quality"),
                    i18n.tr("D: Poor Nutritional Quality"),
                    i18n.tr("E: Bad Nutritional Quality")
                ]
                onSelectedIndexChanged: {
                    var grades = ["a", "b", "c", "d", "e"];
                    if (selectedIndex >= 0 && selectedIndex < grades.length) {
                        logical_fields.ingestion.nutriscore = grades[selectedIndex];
                    }
                }
            }
        }
    }
}
