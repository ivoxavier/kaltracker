/*
 * 2022-2026 Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 */

import QtQuick 2.9
import Lomiri.Components 1.3
import "../theme"

Canvas {
    id: canvas

    width: units.gu(22)
    height: units.gu(22)
    antialiasing: true

    property color trackColor: app_style.chart.circle.calories.inColor
    property color progressColor: app_style.chart.circle.calories.outColor

    property real centerWidth: width / 2
    property real centerHeight: height / 2
    property real radius: units.gu(8.8)
    property real trackWidth: units.gu(1.3)

    // 0: Restantes | 1: Consumidas | 2: Percentagem
    property int displayMode: 0

    property bool isExceeded: logical_fields.user_profile.plan.cal_remaining < 0
    property real rawPercentage: app_settings.rec_cal > 0
                                 ? (logical_fields.user_profile.plan.cal_consumed / app_settings.rec_cal) * 100
                                 : 0
    property bool isWarning: !isExceeded && rawPercentage >= 85
    property real targetValue: Math.max(0, Math.min(100, rawPercentage))
    property real currentValue: 0


    property real targetDisplayValue: {
        if (displayMode === 0) return Math.abs(logical_fields.user_profile.plan.cal_remaining)
        if (displayMode === 1) return logical_fields.user_profile.plan.cal_consumed
        return rawPercentage
    }
    property real animatedValue: 0

    property real angle: (currentValue / 100) * 2 * Math.PI
    property real angleOffset: -Math.PI / 2

    Behavior on currentValue {
        enabled: app_settings.is_graphs_animation_enabled
        NumberAnimation {
            duration: 900
            easing.type: Easing.OutCubic
        }
    }

    Behavior on animatedValue {
        enabled: app_settings.is_graphs_animation_enabled
        NumberAnimation {
            duration: 600
            easing.type: Easing.OutCubic
        }
    }

    Component.onCompleted: {
        currentValue = targetValue
        animatedValue = targetDisplayValue
    }
    onTargetValueChanged: currentValue = targetValue
    onTargetDisplayValueChanged: animatedValue = targetDisplayValue

    onTrackColorChanged: requestPaint()
    onProgressColorChanged: requestPaint()
    onIsExceededChanged: requestPaint()
    onIsWarningChanged: requestPaint()
    onCurrentValueChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d");
        ctx.save();
        ctx.clearRect(0, 0, canvas.width, canvas.height);


        ctx.beginPath();
        ctx.lineWidth = trackWidth;
        ctx.lineCap = "round";
        ctx.strokeStyle = trackColor;
        ctx.globalAlpha = 0.25;
        ctx.arc(centerWidth, centerHeight, radius, 0, 2 * Math.PI);
        ctx.stroke();


        if (currentValue > 0.5) {
            ctx.globalAlpha = 1.0;
            ctx.beginPath();
            ctx.lineWidth = trackWidth;
            ctx.lineCap = "round";

            var grad = ctx.createLinearGradient(0, 0, canvas.width, canvas.height);
            if (isExceeded) {
                grad.addColorStop(0.0, LomiriColors.orange);
                grad.addColorStop(1.0, LomiriColors.red);
            } else if (isWarning) {
                grad.addColorStop(0.0, "#f5b041");
                grad.addColorStop(1.0, LomiriColors.orange);
            } else {
                grad.addColorStop(0.0, Qt.lighter(progressColor, 1.25));
                grad.addColorStop(1.0, progressColor);
            }

            var endAngle = angleOffset + angle;
            ctx.strokeStyle = grad;
            ctx.arc(centerWidth, centerHeight, radius, angleOffset, endAngle);
            ctx.stroke();


            var tipX = centerWidth + radius * Math.cos(endAngle);
            var tipY = centerHeight + radius * Math.sin(endAngle);
            ctx.beginPath();
            ctx.fillStyle = "white";
            ctx.globalAlpha = 0.9;
            ctx.arc(tipX, tipY, trackWidth * 0.28, 0, 2 * Math.PI);
            ctx.fill();
        }

        ctx.restore();
    }


    Column {
        anchors.centerIn: parent
        width: radius * 1.55
        spacing: units.gu(0.3)

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: canvas.displayMode === 2
                  ? Math.round(canvas.animatedValue) + "%"
                  : Math.round(canvas.animatedValue)
            font.pixelSize: units.gu(4.2)
            minimumPixelSize: units.gu(2.4)
            fontSizeMode: Text.HorizontalFit
            font.weight: Font.DemiBold
            color: canvas.isExceeded
                   ? LomiriColors.red
                   : (canvas.isWarning ? LomiriColors.orange : app_style.label.labelColor)
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: {
                if (canvas.displayMode === 0) {
                    return canvas.isExceeded ? i18n.tr("EXCEEDED") : i18n.tr("REMAINING")
                } else if (canvas.displayMode === 1) {
                    return i18n.tr("CONSUMED")
                }
                return i18n.tr("OF GOAL")
            }
            font.pixelSize: units.gu(1.3)
            font.weight: Font.DemiBold
            font.letterSpacing: units.dp(1.2)
            color: canvas.isExceeded
                   ? LomiriColors.red
                   : (canvas.isWarning ? LomiriColors.orange : LomiriColors.ash)
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: canvas.displayMode === 2 ? i18n.tr("daily") : i18n.tr("kcal")
            font.pixelSize: units.gu(1.4)
            color: LomiriColors.ash
            opacity: 0.8
        }
    }


    MouseArea {
        anchors.fill: parent
        onClicked: canvas.displayMode = (canvas.displayMode + 1) % 3
    }
}
