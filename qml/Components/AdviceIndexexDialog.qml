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
import Ubuntu.Components.Popups 1.3
import "../js/DataBaseTools.js" as DataBase
import "../js/Bmi.js" as CalcBMI
import "../js/Ibw.js" as CalcIBW
import "../js/AwarenessAnalysis.js" as AwarenessAnalysis


Dialog {
    id: adviceDialogPopUP
    title: i18n.tr("Advice") 

    property int awareness_level

    Connections{
        target: indexesCalcPage
        onAwareness_level: {
            adviceDialogPopUP.awareness_level = awareness_level_QML 
            AwarenessAnalysis.generalAnalysis(awareness_level)
        }
    }
    
    TextEdit {
        id: advice_text
        wrapMode: TextEdit.Wrap
        width: parent.width
        readOnly: true
        font.family: "Ubuntu Mono"
        textFormat: TextEdit.PlainText
        color: theme.palette.normal.fieldText
    }   

    Button{
        id: cancelButton
        text: i18n.tr("Back")
        onClicked: PopupUtils.close(adviceDialogPopUP)

    }
    

    //Component.onCompleted: AwarenessAnalysis.generalAnalysis()
}
