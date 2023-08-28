/*
 * 2023  Ivo Xavier
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



Popover{
    id: notification_pop
    width: units.gu(58)
    height: units.gu(12)
    y: 10
    
    property alias title : notif_data.title
    property alias subtitle : notif_data.subtitle

    ColumnLayout{
        id: main_column_pop
        width: root.width
        spacing: units.gu(2)
        ListItem{
            color: LomiriColors.porcelain
            ListItemLayout{
                id: notif_data
                title.font.bold : true
                Icon{SlotsLayout.position: SlotsLayout.Leading; name: "notification"; height: units.gu(3.5)}
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
                PopupUtils.close(notification_pop) 
        })
    }
}
