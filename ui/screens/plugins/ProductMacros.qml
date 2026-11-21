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

Flickable {
    id: macros_root

    width: parent ? parent.width : units.gu(40)
    height: parent ? parent.height : units.gu(60)
    contentWidth: width
    contentHeight: main_col.height + units.gu(12) // espaço extra para o FAB e PageIndicator
    clip: true

    readonly property real fatVal: Number(logical_fields.ingestion.fat) || 0
    readonly property real proteinVal: Number(logical_fields.ingestion.protein) || 0
    readonly property real carboVal: Number(logical_fields.ingestion.carbo) || 0
    readonly property real totalGrams: fatVal + proteinVal + carboVal
    readonly property int estimatedKcal: Math.round((fatVal * 9) + (proteinVal * 4) + (carboVal * 4))

    readonly property color fatColor: app_style.progressBar.nutrientBar.fatProgress
    readonly property color proteinColor: app_style.progressBar.nutrientBar.proteinProgress
    readonly property color carboColor: app_style.progressBar.nutrientBar.carbProgress

    Column {
        id: main_col
        width: parent.width - units.gu(4)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: units.gu(2)
        spacing: units.gu(2)

        // ==========================================
        // CARTÃO DE RESUMO + BARRA DE PROPORÇÃO
        // ==========================================
        LomiriShape {
            width: parent.width
            height: summary_col.height + units.gu(3)
            radius: "large"
            aspect: LomiriShape.DropShadow
            backgroundColor: app_style.shape.shapeColor

            Column {
                id: summary_col
                width: parent.width - units.gu(3)
                anchors.centerIn: parent
                spacing: units.gu(1.2)

                RowLayout {
                    width: parent.width

                    Label {
                        text: i18n.tr("Macro Distribution")
                        font.pixelSize: units.gu(1.7)
                        font.weight: Font.DemiBold
                        color: app_style.label.labelColor
                        Layout.fillWidth: true
                    }

                    Label {
                        text: "~ " + macros_root.estimatedKcal + " kcal"
                        font.pixelSize: units.gu(1.6)
                        font.weight: Font.DemiBold
                        color: LomiriColors.ash
                    }
                }

                // Barra horizontal empilhada (Gordura / Proteína / Hidratos)
                Rectangle {
                    width: parent.width
                    height: units.gu(1.2)
                    radius: height / 2
                    color: Qt.rgba(0.5, 0.5, 0.5, 0.18)
                    clip: true

                    Row {
                        anchors.fill: parent
                        visible: macros_root.totalGrams > 0

                        Rectangle {
                            height: parent.height
                            width: parent.width * (macros_root.fatVal / macros_root.totalGrams)
                            color: macros_root.fatColor
                            Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
                        }
                        Rectangle {
                            height: parent.height
                            width: parent.width * (macros_root.proteinVal / macros_root.totalGrams)
                            color: macros_root.proteinColor
                            Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
                        }
                        Rectangle {
                            height: parent.height
                            width: parent.width * (macros_root.carboVal / macros_root.totalGrams)
                            color: macros_root.carboColor
                            Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
                        }
                    }
                }

                // Legenda em percentagens
                RowLayout {
                    width: parent.width
                    spacing: units.gu(1)

                    Label {
                        Layout.fillWidth: true
                        text: i18n.tr("Fat") + " " + (macros_root.totalGrams > 0 ? Math.round((macros_root.fatVal / macros_root.totalGrams) * 100) : 0) + "%"
                        font.pixelSize: units.gu(1.3)
                        color: macros_root.fatColor
                    }
                    Label {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        text: i18n.tr("Protein") + " " + (macros_root.totalGrams > 0 ? Math.round((macros_root.proteinVal / macros_root.totalGrams) * 100) : 0) + "%"
                        font.pixelSize: units.gu(1.3)
                        color: macros_root.proteinColor
                    }
                    Label {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignRight
                        text: i18n.tr("Carbo") + " " + (macros_root.totalGrams > 0 ? Math.round((macros_root.carboVal / macros_root.totalGrams) * 100) : 0) + "%"
                        font.pixelSize: units.gu(1.3)
                        color: macros_root.carboColor
                    }
                }
            }
        }

        // ==========================================
        // CARTÕES DE MACROS (FAT / PROTEIN / CARBO)
        // ==========================================
        Repeater {
            model: [
                {
                    "field": "fat",
                    "label": i18n.tr("Fat"),
                    "icon": "../../assets/olive-oil-svgrepo-com.svg",
                    "accent": macros_root.fatColor,
                    "max": 100
                },
                {
                    "field": "protein",
                    "label": i18n.tr("Protein"),
                    "icon": "../../assets/cheese-svgrepo-com.svg",
                    "accent": macros_root.proteinColor,
                    "max": 100
                },
                {
                    "field": "carbo",
                    "label": i18n.tr("Carbo"),
                    "icon": "../../assets/bread-svgrepo-com.svg",
                    "accent": macros_root.carboColor,
                    "max": 100
                }
            ]

            delegate: LomiriShape {
                id: macro_card
                width: main_col.width
                height: card_col.height + units.gu(3)
                radius: "large"
                aspect: LomiriShape.DropShadow
                backgroundColor: app_style.shape.shapeColor

                property real currentVal: Number(logical_fields.ingestion[modelData.field]) || 0

                function setMacroValue(val) {
                    var clamped = Math.max(0, Math.min(modelData.max, val));
                    logical_fields.ingestion[modelData.field] = Number(clamped.toFixed(1));
                }

                Column {
                    id: card_col
                    width: parent.width - units.gu(3)
                    anchors.centerIn: parent
                    spacing: units.gu(1.5)

                    // Linha superior: Ícone + Nome + Input Numérico editável
                    RowLayout {
                        width: parent.width
                        spacing: units.gu(1.5)

                        NutrientIcon {
                            img_path: modelData.icon
                        }

                        Label {
                            text: modelData.label
                            font.pixelSize: units.gu(2)
                            font.weight: Font.DemiBold
                            color: app_style.label.labelColor
                            Layout.fillWidth: true
                        }

                        TextField {
                            id: value_input
                            Layout.preferredWidth: units.gu(9.5)
                            horizontalAlignment: TextInput.AlignRight
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            text: macro_card.currentVal.toFixed(1)

                            function commitText() {
                                var parsed = parseFloat(text.replace(",", "."));
                                if (!isNaN(parsed)) {
                                    macro_card.setMacroValue(parsed);
                                } else {
                                    text = macro_card.currentVal.toFixed(1);
                                }
                            }

                            onAccepted: commitText()
                            onActiveFocusChanged: if (!activeFocus) commitText()
                        }

                        Label {
                            text: "g"
                            font.pixelSize: units.gu(1.8)
                            font.weight: Font.DemiBold
                            color: LomiriColors.ash
                        }
                    }

                    // Linha inferior: Slider horizontal com área táctil generosa
                    Item {
                        width: parent.width
                        height: units.gu(3.5)

                        // Trilho de fundo
                        Rectangle {
                            id: slider_track
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: units.gu(0.9)
                            radius: height / 2
                            color: Qt.rgba(0.5, 0.5, 0.5, 0.18)

                            // Preenchimento ativo
                            Rectangle {
                                height: parent.height
                                width: Math.max(0, Math.min(parent.width, (macro_card.currentVal / modelData.max) * parent.width))
                                radius: parent.radius
                                color: modelData.accent
                                Behavior on width { NumberAnimation { duration: 100; easing.type: Easing.OutQuad } }
                            }
                        }

                        // Pega (thumb) circular
                        Rectangle {
                            width: units.gu(2.4)
                            height: units.gu(2.4)
                            radius: width / 2
                            anchors.verticalCenter: parent.verticalCenter
                            x: Math.max(0, Math.min(parent.width - width, (macro_card.currentVal / modelData.max) * parent.width - width / 2))
                            color: "white"
                            border.color: modelData.accent
                            border.width: units.dp(3)
                        }

                        MouseArea {
                            anchors.fill: parent
                            preventStealing: true

                            function updateFromX(mouseX) {
                                var ratio = Math.max(0, Math.min(1, mouseX / width));
                                macro_card.setMacroValue(ratio * modelData.max);
                            }

                            onPressed: updateFromX(mouse.x)
                            onPositionChanged: updateFromX(mouse.x)
                        }
                    }
                }
            }
        }
    }
}
