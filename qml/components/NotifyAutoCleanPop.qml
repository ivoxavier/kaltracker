/*
 * 2022  Ivo Fernandes <pg27165@alunos.uminho.pt>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * utFoods is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
import QtQuick 2.9
import Ubuntu.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Ubuntu.Components.ListItems 1.3 
import Ubuntu.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import Ubuntu.Components.Pickers 1.3
import QtQuick.LocalStorage 2.12
import "../../js/IngestionsTable.js" as IngestionsTable


Popover{
    id: auto_cleaning_pop
    width: units.gu(58)
    height: units.gu(12)
    y: 10
    
    ColumnLayout{
        id: main_column_pop
        width: parent.width
        spacing: units.gu(2)
        ListItem{
            color: UbuntuColors.porcelain
            ListItemLayout{
                title.text: i18n.tr("Deleting Old Ingestions")
                title.font.bold : true
                subtitle.text: i18n.tr("Please, wait this notify dissapears")
                Icon{SlotsLayout.position: SlotsLayout.Leading; name: "timer"; height: units.gu(3.5)}
            }
        }

        Timer{id: timer;repeat: false}

    }

    Component.onCompleted:{
        IngestionsTable.autoClean()

        function animationState(delayMiliseconds, cb) {
                timer.interval = delayMiliseconds;
                timer.triggered.connect(cb);
                timer.start();
            }  
             animationState(2000, function () {
                PopupUtils.close(auto_cleaning_pop) 
        })
    }
}
