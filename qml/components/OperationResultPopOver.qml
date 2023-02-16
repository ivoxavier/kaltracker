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
import QtQuick.Controls.Suru 2.2
import Lomiri.Components.Pickers 1.3
import "../style"

Popover{
    id: operation_result_popover
    width: units.gu(56)
    height: units.gu(12)
    y:10
    
    ColumnLayout{
        id: main_column_pop
        width: parent.width
        ListItem{
            color: app_style.shape.shapeColor
            ListItemLayout{
                title.text: i18n.tr("Operation Sucess")
                title.color: app_style.label.labelColor
                Icon{SlotsLayout.position: SlotsLayout.Leading; name: "ok"; color: LomiriColors.green; height: units.gu(4)}
            }
        }

        
        Timer{id: timer;repeat: false}

    }

    Component.onCompleted:{

        function animationState(delayMiliseconds, cb) {
                timer.interval = delayMiliseconds;
                timer.triggered.connect(cb);
                timer.start();
            }  
             animationState(1000, function () {
                PopupUtils.close(operation_result_popover) 
            })
    }
}
