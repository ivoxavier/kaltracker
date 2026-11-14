/*
 * 2022-2026  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 * ...
 */

import QtQuick 2.9
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import "../components"
import "../theme"
import "../logicalFields"
import "../../js/Chart.js" as Charts
import "../../js/QChartJsTypes.js" as ChartTypes

ColumnLayout {
    width: parent.width
    spacing: units.gu(3)

    function getGradeColor(grade) {
        var g = String(grade).toLowerCase();
        if (g === 'a' || g === '1') return LomiriColors.green;
        if (g === 'b' || g === '2') return "#09b227";
        if (g === 'c' || g === '3') return "#cba000";
        if (g === 'd' || g === '4') return "#e57a01";
        if (g === 'e') return LomiriColors.red;
        return LomiriColors.ash;
    }

    Item { Layout.preferredHeight: units.gu(1) }

    ColumnLayout {
        Layout.fillWidth: true
        Layout.margins: units.gu(2)
        spacing: units.gu(1)

        Label {
            text: i18n.tr("Macros")
            font.weight: Font.DemiBold
            color: LomiriColors.ash
            Layout.leftMargin: units.gu(1)
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: units.gu(24)
            color: app_style.shape.shapeColor
            radius: units.gu(1.5)

            QChartJs {
                id: chart_pie
                anchors.fill: parent
                anchors.margins: units.gu(2)
                chartType: ChartTypes.QChartJSTypes.PIE
                chartData: getChartPieValues()
                animation: app_settings.is_graphs_animation_enabled
                chartAnimationEasing: Easing.InOutElastic
                chartAnimationDuration: 2000
            }
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        Layout.margins: units.gu(2)
        spacing: units.gu(1)

        Label {
            text: i18n.tr("Classified as")
            font.weight: Font.DemiBold
            color: LomiriColors.ash
            Layout.leftMargin: units.gu(1)
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: grades_layout.implicitHeight + units.gu(4)
            color: app_style.shape.shapeColor
            radius: units.gu(1.5)

            RowLayout {
                id: grades_layout
                anchors.centerIn: parent
                width: parent.width - units.gu(4)
                spacing: units.gu(2)

                SlotProductGrades {
                    Layout.fillWidth: true
                    grade: logical_fields.ingestion.nutriscore
                    subject: logical_fields.ingestion.nutriscore === "a" ? i18n.tr("Very good nutritional quality") : 
                             logical_fields.ingestion.nutriscore === "b" ? i18n.tr("Good nutritional quality") : 
                             logical_fields.ingestion.nutriscore === "c" ? i18n.tr("Average nutritional quality") : 
                             logical_fields.ingestion.nutriscore === "d" ? i18n.tr("Poor nutritional quality") : 
                             logical_fields.ingestion.nutriscore === "e" ? i18n.tr("Bad nutritional quality") : 
                             i18n.tr("Unknown")
                    color: getGradeColor(logical_fields.ingestion.nutriscore)
                }

                SlotProductGrades {
                    Layout.fillWidth: true
                    grade: logical_fields.ingestion.nova_groups
                    subject: logical_fields.ingestion.nova_groups === "1" ? i18n.tr("Unprocessed or minimally processed") : 
                             logical_fields.ingestion.nova_groups === "2" ? i18n.tr("Processed culinary ingredients") : 
                             logical_fields.ingestion.nova_groups === "3" ? i18n.tr("Processed foods") : 
                             logical_fields.ingestion.nova_groups === "4" ? i18n.tr("Ultra-processed foods") : 
                             i18n.tr("Unknown")
                    color: getGradeColor(logical_fields.ingestion.nova_groups)
                }
            }
        }
    }
}