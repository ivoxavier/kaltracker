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
                energy_kcal.text = i18n.tr("Calories:") + kcalToTemplate + "kcal"
                fat.text = i18n.tr("Fat:") + fatToTemplate + "g"
                saturated_fat.text = i18n.tr("Saturated Fat:") +saturatedToTemplate + "g"
                carbohydrates.text = i18n.tr("Carbonhydrates:") +carboToTemplate + "g"
                sugars.text = i18n.tr("Sugar:") +sugarsToTemplate + "g"
                fiber.text = i18n.tr("Fiber:") +fiberToTemplate + "g"
                proteins.text = i18n.tr("Protein:") +proteinsToTemplate + "g"
                salt.text = i18n.tr("Salt:") + saltToTemplate + "g"
            }
        }

        Label{
            id: energy_kcal
        }

        Label{
            id: fat
        }

        Label{
            id: saturated_fat
        }

        Label{
            id: carbohydrates
        }

        Label{
            id: sugars
        }

        Label{
            id: fiber
        }

        Label{
            id: proteins
        }

        Label{
            id: salt
        }

            Button {
                text: "Back"
                onClicked:{
                    PopupUtils.close(aboutFoods)
                } 
            }


        
}
