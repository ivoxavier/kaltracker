/*
 * 2021  Ivo Xavier
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
import Ubuntu.Components.ListItems 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12
import io.thp.pyotherside 1.5
import Qt.labs.platform 1.0
import Ubuntu.Content 1.3
import QtCharts 2.3
import "../js/DataBaseTools.js" as DataBase



Page{
    id: monthIngestionsPage
    objectName: 'Month Ingestions Page'

    

    header: PageHeader {

        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }

        title: stackValues.stackMonthIngestions === '01' ? i18n.tr("January") : stackValues.stackMonthIngestions === '02' ? i18n.tr("February") :stackValues.stackMonthIngestions === '03' ? i18n.tr("March") : stackValues.stackMonthIngestions === '04' ? i18n.tr("April") : stackValues.stackMonthIngestions === '05' ? i18n.tr("May") : stackValues.stackMonthIngestions === '06' ? i18n.tr("June") : stackValues.stackMonthIngestions === '07' ? i18n.tr("July") : stackValues.stackMonthIngestions === '08' ? i18n.tr("August") : stackValues.stackMonthIngestions === '09' ? i18n.tr("September") : stackValues.stackMonthIngestions === '10' ? i18n.tr("October") : stackValues.stackMonthIngestions === '11' ? i18n.tr("November") : i18n.tr("December")

    }


   ScrollView{
        id: scrollView
        
        anchors.top: monthIngestionsPage.header.bottom
        anchors.bottom: monthIngestionsPage.bottom
        anchors.right: monthIngestionsPage.right
        anchors.left: monthIngestionsPage.left

        TextEdit {
            id: recordsHistory
            wrapMode: TextEdit.Wrap
            text: DataBase.getAllIngestionsMonth(stackValues.stackMonthIngestions)
            width: scrollView.width
            readOnly: true
            font.family: "Ubuntu Mono"
            textFormat: TextEdit.PlainText
            color: theme.palette.normal.fieldText
        }   
    
    }
    
}