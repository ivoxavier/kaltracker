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
import Ubuntu.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Ubuntu.Components.ListItems 1.3 
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

Popover{
    contentWidth: day_month_picker.width
    DatePicker {
        id: day_month_picker
        mode: "Years|Months|Days"
        date: root.currentDate
        width: Math.min(root.width - units.gu(8), units.gu(36))
        height: units.gu(10)
        
        StyleHints {
            highlightBackgroundColor: theme.palette.normal.raised
            highlightColor: UbuntuColors.jet
            backgroundColor: theme.palette.normal.base
        }

        Component.onDestruction: {
            root.stringDate = Qt.formatDate(day_month_picker.date,"yyyy-MM-dd")
            icon_down.is_clicked = !icon_down.is_clicked
            root.initDB()
        }
    }
}  