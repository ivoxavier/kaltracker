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
import Lomiri.Components.Popups 1.3
import "../components"
import "../theme"

Page {
    id: body_measures_page
    objectName: 'BodyMeasuresPage'

    header: PageHeader {
        title: i18n.tr("Body Measures")
    }

    BackgroundStyle {}

    property int user_height: 0
    property double user_weight: 0
    property int user_sex_at_birth: 0
    property double user_bmi: 0
    property double user_ideal_weight: 0
    property int user_ap_hi: 0
    property int user_ap_lo: 0

    property int bmiIndex: 2
    property int bpIndex: 0

    function loadBodyMeasures() {
        var userData = userRepository.getUser();
        if (userData) {
            user_height = Number(userData.height) || 0;
            user_weight = Number(userData.weight) || 0;
            user_sex_at_birth = Number(userData.sex_at_birth) || 0;
            user_ap_hi = Number(userData.ap_hi) || 0;
            user_ap_lo = Number(userData.ap_lo) || 0;
            user_bmi = user_height > 0 ? Number(userRepository.getBmi(user_height, user_weight)) : 0;
            user_ideal_weight = user_height > 0 ? Number(userRepository.getIdealWeight(user_sex_at_birth, user_height)) : 0;
            bmiIndex = userRepository.getBmiIndex(user_bmi);
            bpIndex = userRepository.getBloodPressureIndex(user_ap_hi, user_ap_lo);
        }
    }

    function getBmiLabel(idx) {
        if (idx === 1) return i18n.tr("Underweight");
        if (idx === 2) return i18n.tr("Normal Weight");
        if (idx === 3) return i18n.tr("Overweight");
        if (idx === 4) return i18n.tr("Pre-Obesity");
        return i18n.tr("Obesity");
    }

    function getBmiColor(idx) {
        if (idx === 1) return "#4A90E2";         // Azul
        if (idx === 2) return "#2ECC71";         // Verde
        if (idx === 3) return "#F1C40F";         // Amarelo
        if (idx === 4) return LomiriColors.orange;
        return LomiriColors.red;
    }

    function getBpLabel(idx) {
        if (idx === 0) return i18n.tr("Normal");
        if (idx === 1) return i18n.tr("Elevated");
        if (idx === 2) return i18n.tr("High Blood Pressure Stage I");
        if (idx === 3) return i18n.tr("High Blood Pressure Stage II");
        return i18n.tr("Hypertensive Crisis");
    }

    function getBpColor(idx) {
        if (idx === 0) return "#2ECC71";
        if (idx === 1) return "#F1C40F";
        if (idx === 2) return LomiriColors.orange;
        return LomiriColors.red;
    }

    Component {
        id: info_bmi
        MessageDialog {
            msg: i18n.tr("KalTracker does not take muscle mass into consideration. This value is only a reference.")
        }
    }

    Flickable {
        anchors {
            top: parent.header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentWidth: width
        contentHeight: main_col.height + units.gu(4)
        clip: true

        Column {
            id: main_col
            width: parent.width - units.gu(3)
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: units.gu(2)
            bottomPadding: units.gu(4)
            spacing: units.gu(2)


            LomiriShape {
                width: parent.width
                height: bmi_col.height + units.gu(3.5)
                radius: "large"
                aspect: LomiriShape.DropShadow
                backgroundColor: app_style.shape.shapeColor

                Column {
                    id: bmi_col
                    width: parent.width - units.gu(3)
                    anchors.centerIn: parent
                    spacing: units.gu(1.5)


                    RowLayout {
                        width: parent.width

                        Label {
                            text: i18n.tr("Body Mass Index (BMI)")
                            font.pixelSize: units.gu(1.8)
                            font.weight: Font.DemiBold
                            color: app_style.label.labelColor
                            Layout.fillWidth: true
                        }

                        Icon {
                            name: "info"
                            width: units.gu(2.5)
                            height: units.gu(2.5)
                            color: LomiriColors.ash

                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: -units.gu(1)
                                onClicked: PopupUtils.open(info_bmi)
                            }
                        }
                    }

                    RowLayout {
                        width: parent.width
                        spacing: units.gu(1.5)

                        Label {
                            text: body_measures_page.user_bmi.toFixed(1)
                            font.pixelSize: units.gu(4.2)
                            font.weight: Font.DemiBold
                            color: app_style.label.labelColor
                        }

                        Rectangle {
                            height: units.gu(3.2)
                            width: bmi_badge_label.implicitWidth + units.gu(2.4)
                            radius: height / 2
                            color: body_measures_page.getBmiColor(body_measures_page.bmiIndex)

                            Label {
                                id: bmi_badge_label
                                anchors.centerIn: parent
                                text: body_measures_page.getBmiLabel(body_measures_page.bmiIndex)
                                font.pixelSize: units.gu(1.4)
                                font.weight: Font.DemiBold
                                color: "white"
                            }
                        }

                        Item { Layout.fillWidth: true }
                    }


                    Item {
                        width: parent.width
                        height: units.gu(3)

                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: units.gu(1)
                            spacing: units.dp(2)

                            Rectangle { width: (parent.width - units.dp(8)) * 0.14; height: parent.height; radius: height / 2; color: "#4A90E2" }
                            Rectangle { width: (parent.width - units.dp(8)) * 0.26; height: parent.height; radius: height / 2; color: "#2ECC71" }
                            Rectangle { width: (parent.width - units.dp(8)) * 0.20; height: parent.height; radius: height / 2; color: "#F1C40F" }
                            Rectangle { width: (parent.width - units.dp(8)) * 0.20; height: parent.height; radius: height / 2; color: LomiriColors.orange }
                            Rectangle { width: (parent.width - units.dp(8)) * 0.20; height: parent.height; radius: height / 2; color: LomiriColors.red }
                        }

                        Rectangle {
                            property real normalizedBmi: Math.max(0, Math.min(1, (body_measures_page.user_bmi - 15.0) / 25.0))
                            width: units.gu(2)
                            height: units.gu(2)
                            radius: width / 2
                            anchors.verticalCenter: parent.verticalCenter
                            x: Math.max(0, Math.min(parent.width - width, normalizedBmi * parent.width - width / 2))
                            color: "white"
                            border.color: body_measures_page.getBmiColor(body_measures_page.bmiIndex)
                            border.width: units.dp(3)

                            Behavior on x {
                                NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                            }
                        }
                    }


                    RowLayout {
                        width: parent.width
                        Label { text: "15"; font.pixelSize: units.gu(1.2); color: LomiriColors.ash; Layout.fillWidth: true }
                        Label { text: "18.5"; font.pixelSize: units.gu(1.2); color: LomiriColors.ash; Layout.fillWidth: true }
                        Label { text: "25"; font.pixelSize: units.gu(1.2); color: LomiriColors.ash; horizontalAlignment: Text.AlignHCenter; Layout.fillWidth: true }
                        Label { text: "30"; font.pixelSize: units.gu(1.2); color: LomiriColors.ash; horizontalAlignment: Text.AlignRight; Layout.fillWidth: true }
                        Label { text: "40"; font.pixelSize: units.gu(1.2); color: LomiriColors.ash; horizontalAlignment: Text.AlignRight; Layout.fillWidth: true }
                    }
                }
            }


            LomiriShape {
                width: parent.width
                height: weight_col.height + units.gu(3.5)
                radius: "large"
                aspect: LomiriShape.DropShadow
                backgroundColor: app_style.shape.shapeColor

                Column {
                    id: weight_col
                    width: parent.width - units.gu(3)
                    anchors.centerIn: parent
                    spacing: units.gu(1.5)

                    RowLayout {
                        width: parent.width
                        spacing: units.gu(1)

                        Icon {
                            source: "../../assets/balance_icon.svg"
                            width: units.gu(3)
                            height: units.gu(3)
                        }

                        Label {
                            text: i18n.tr("Weight Overview")
                            font.pixelSize: units.gu(1.8)
                            font.weight: Font.DemiBold
                            color: app_style.label.labelColor
                            Layout.fillWidth: true
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: units.dp(1)
                        color: Qt.rgba(0.5, 0.5, 0.5, 0.15)
                    }


                    RowLayout {
                        width: parent.width
                        spacing: units.gu(2)

                        Column {
                            Layout.fillWidth: true
                            spacing: units.gu(0.4)

                            Label {
                                text: i18n.tr("Current")
                                font.pixelSize: units.gu(1.4)
                                color: LomiriColors.ash
                            }

                            Label {
                                text: body_measures_page.user_weight.toFixed(1) + " kg"
                                font.pixelSize: units.gu(2.8)
                                font.weight: Font.DemiBold
                                color: app_style.label.labelColor
                            }
                        }

                        Rectangle {
                            width: units.dp(1)
                            height: units.gu(5)
                            color: Qt.rgba(0.5, 0.5, 0.5, 0.15)
                        }

                        Column {
                            Layout.fillWidth: true
                            spacing: units.gu(0.4)

                            Label {
                                text: i18n.tr("Ideal")
                                font.pixelSize: units.gu(1.4)
                                color: LomiriColors.ash
                            }

                            Label {
                                text: body_measures_page.user_ideal_weight.toFixed(1) + " kg"
                                font.pixelSize: units.gu(2.8)
                                font.weight: Font.DemiBold
                                color: "#2ECC71"
                            }
                        }
                    }

                    Label {
                        property double diff: body_measures_page.user_weight - body_measures_page.user_ideal_weight
                        visible: body_measures_page.user_ideal_weight > 0
                        text: {
                            if (Math.abs(diff) < 0.5) return i18n.tr("You are right on your ideal weight!");
                            if (diff > 0) return i18n.tr("%1 kg above ideal weight").arg(diff.toFixed(1));
                            return i18n.tr("%1 kg below ideal weight").arg(Math.abs(diff).toFixed(1));
                        }
                        font.pixelSize: units.gu(1.4)
                        color: LomiriColors.ash
                    }
                }
            }


            LomiriShape {
                visible: app_settings.is_blood_pressure_defined
                width: parent.width
                height: bp_col.height + units.gu(3.5)
                radius: "large"
                aspect: LomiriShape.DropShadow
                backgroundColor: app_style.shape.shapeColor

                Column {
                    id: bp_col
                    width: parent.width - units.gu(3)
                    anchors.centerIn: parent
                    spacing: units.gu(1.5)

                    RowLayout {
                        width: parent.width
                        spacing: units.gu(1)

                        Icon {
                            source: "../../assets/blood_icon.svg"
                            width: units.gu(3)
                            height: units.gu(3)
                        }

                        Label {
                            text: i18n.tr("Blood Pressure")
                            font.pixelSize: units.gu(1.8)
                            font.weight: Font.DemiBold
                            color: app_style.label.labelColor
                            Layout.fillWidth: true
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: units.dp(1)
                        color: Qt.rgba(0.5, 0.5, 0.5, 0.15)
                    }

                    RowLayout {
                        width: parent.width
                        spacing: units.gu(1)

                        Label {
                            text: body_measures_page.user_ap_hi + " / " + body_measures_page.user_ap_lo
                            font.pixelSize: units.gu(3.4)
                            font.weight: Font.DemiBold
                            color: app_style.label.labelColor
                        }

                        Label {
                            text: "mmHg"
                            font.pixelSize: units.gu(1.6)
                            color: LomiriColors.ash
                            Layout.alignment: Qt.AlignBaseline
                        }

                        Item { Layout.fillWidth: true }
                    }

                    Rectangle {
                        height: units.gu(3.2)
                        width: Math.min(parent.width, bp_badge_label.implicitWidth + units.gu(2.4))
                        radius: height / 2
                        color: body_measures_page.getBpColor(body_measures_page.bpIndex)

                        Label {
                            id: bp_badge_label
                            anchors.centerIn: parent
                            text: body_measures_page.getBpLabel(body_measures_page.bpIndex)
                            font.pixelSize: units.gu(1.4)
                            font.weight: Font.DemiBold
                            color: "white"
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: loadBodyMeasures()
    onVisibleChanged: {
        if (visible) {
            loadBodyMeasures();
        }
    }
}
