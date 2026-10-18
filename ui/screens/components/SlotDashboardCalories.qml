/*
 * 2022  Ivo Xavier
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
import QtCharts 2.3

Item{ 
    id: container

    property int number_columns: root.height > root.width ? 2 : 5;
    property int number_rows: root.height > root.width ? 5 : 2;

    property int slot_size: Math.min (root.width / number_columns, root.height / number_rows) * 0.8;
    property int slot_x_spacing: (root.width - slot_size * number_columns) / (number_columns + 1);
    property int slot_y_spacing: (root.height - slot_size * number_rows) / (number_rows + 1);

    GridLayout{ 
        
        x: container.slot_x_spacing;
        y: container.slot_y_spacing;
        columns: container.number_columns;
        rows: container.number_rows;
        columnSpacing: container.slot_x_spacing;
        rowSpacing: container.slot_y_spacing;

        Text{

            text: i18n.tr("Consumed")
            font.bold: true 
        }


        Text{
            
            font.bold: true 
            text: i18n.tr("Goal")
        }

        Text{
            id: dashboard_calories_consumed
            //Layout.leftMargin: units.gu(1.2)
           // Layout.rightMargin: units.gu(1.2)
            
            
        }

       /* Icon{
            id: notes_icon
            Layout.alignment: Qt.AlignHCenter 
            Layout.bottomMargin: units.gu(7)
            name: "note"
            height: units.gu(2)
            MouseArea{
                anchors.fill: parent
            }
        }*/

        Text{
            //rec_cal
         
            
         //   Layout.bottomMargin: units.gu(7)
            text: app_settings.plan_type == "loose" ? i18n.tr("Loose weight") : app_settings.plan_type == "gain" ? i18n.tr("Gain weight") : i18n.tr("Maintain weight")
        }     

        Text{
            //rec_cal
          
            
         //   Layout.bottomMargin: units.gu(7)
            text: app_settings.plan_type == "loose" ? i18n.tr("Loose weight") : app_settings.plan_type == "gain" ? i18n.tr("Gain weight") : i18n.tr("Maintain weight")
        } 

        Text{
            //rec_cal
           
         //   Layout.bottomMargin: units.gu(7)
            text: i18n.tr("Maintain weight")
        } 
    }
}