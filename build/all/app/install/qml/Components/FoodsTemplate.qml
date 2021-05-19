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

Dialog {
       id: aboutFoods

        Connections{
            enabled: true
            ignoreUnknownSignals: true
            target: foodsList
            onFoodsDetailsSender:{
                aboutFoods.title = nameToTemplate
                kcalDetail.text = kcalToTemplate + " kcal"
                foodsDetails.text = i18n.tr("Desc: ") + descToTemplate
            }
        }

        Label{
            id: kcalDetail
        }

        TextEdit {
            id: foodsDetails
            wrapMode: TextEdit.Wrap
            readOnly: true
            textFormat: TextEdit.PlainText
            color: theme.palette.normal.fieldText
            leftPadding: units.gu(1)
        } 

        Row{
            spacing : units.gu(10)
            //anchors.horizontalCenter: parent.horizontalCenter
            width: aboutFoods.title.width
            Button {
                text: "Back"
                onClicked:{
                    PopupUtils.close(aboutFoods)
                } 
            }

            Button {
                text: "Confirm"
                color: "green"
                onClicked: {
                    PopupUtils.close(aboutFoods)
                }
            }
        }

        
}
