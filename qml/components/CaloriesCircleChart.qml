/*
 * 2015 Johan Guerreros
 * 2022 Ivo Xavier 
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
import QtQuick.Controls.Suru 2.2

  
Canvas {
    id: canvas
        
    width: units.gu(20)
    height: units.gu(20)
    antialiasing: true
    

    property color primaryColor: "#aea79f"
    property color secondaryColor: Suru.theme === 0 ? root.kaltracker_light_theme.circle_chart : root.kaltracker_dark_theme.circle_chart

    property real centerWidth: width / 2
    property real centerHeight: height / 2
   
    property real radius: units.gu(8)

    property real minimumValue: 0
    property real maximumValue: 100
    property real currentValue: (home_page.query_total_cal_consumed / app_settings.rec_cal) * 100

    // this is the angle that splits the circle in two arcs
    // first arc is drawn from 0 radians to angle radians
    // second arc is angle radians to 2*PI radians
    property real angle: (currentValue - minimumValue) / (maximumValue - minimumValue) * 2 * Math.PI

    // we want both circle to start / end at 12 o'clock
    // without this offset we would start / end at 9 o'clock
    property real angleOffset: -Math.PI / 2


    onPrimaryColorChanged: requestPaint()
    onSecondaryColorChanged: requestPaint()
    onMinimumValueChanged: requestPaint()
    onMaximumValueChanged: requestPaint()
    onCurrentValueChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d");
        ctx.save();

        ctx.clearRect(0, 0, canvas.width, canvas.height);

        // First, thinner arc
        // From angle to 2*PI

        ctx.beginPath();
        ctx.lineWidth = units.gu(0.5);
        ctx.strokeStyle = primaryColor;
        ctx.arc(canvas.centerWidth,
        canvas.centerHeight,
        canvas.radius,
        angleOffset + canvas.angle,
        angleOffset + 2*Math.PI);
        ctx.stroke();

        // Second, thicker arc
        // From 0 to angle

        ctx.beginPath();
        ctx.lineWidth = units.gu(1);
        ctx.strokeStyle = canvas.secondaryColor;
        ctx.arc(canvas.centerWidth,
        canvas.centerHeight,
        canvas.radius,
        canvas.angleOffset,
        canvas.angleOffset + canvas.angle);
        ctx.stroke();
        ctx.restore();
    }

    Column{
        anchors.centerIn: parent
        width: parent.width / 2
        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            text: home_page.query_total_cal_remaining
            font.pointSize: units.gu(1.7)
            color : Suru.theme === 0 ? root.kaltracker_light_theme.text_color : root.kaltracker_dark_theme.text_color
        }
        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            text: home_page.query_total_cal_remaining < 0 ? i18n.tr("EXCEED") : i18n.tr("REMAINING")
            font.pointSize: units.gu(1.3)
            color : Suru.theme === 0 ? root.kaltracker_light_theme.text_color : root.kaltracker_dark_theme.text_color
        }
    }
} 
