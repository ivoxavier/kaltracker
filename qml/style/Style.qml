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
import QtQuick.Controls.Suru 2.2

QtObject{
    property QtObject mainView : QtObject{
        property color backgroundColor : Suru.theme === 0 ? LomiriColors.porcelain : LomiriColors.jet
    }

    property QtObject label : QtObject{
        property color labelColor : Suru.theme === 0 ? theme.palette.normal.backgroundText : theme.palette.normal.foregroundText
    }

    property QtObject button : QtObject{

        property QtObject confirm{
            property color buttonColor : LomiriColors.green
        }

        property QtObject delete{
            property color buttonColor : LomiriColors.red
        }
        
    }

    property QtObject shape : QtObject{
        property color shapeColor : Suru.theme === 0 ? "#FFFFFF" : "#808080ff" 
    }

    property QtObject nutrientsColors : QtObject{
        property color fat : "#ed3146"
        property color carbo : "#19b6ee"
        property color protein : "#90ee90"
    }

    /** Progress Bar's **/

    property QtObject progressBar : QtObject{
        property QtObject nutrientBar : QtObject{
            property color backgroundColor : "#e6e6e6"
            property color fatProgress : nutrientsColors.fat
            property color carbProgress : nutrientsColors.carbo
            property color proteinProgress : nutrientsColors.protein
        } 

        property QtObject waterBar : QtObject{
            property color backgroundColor : "#e6e6e6"
            property color waterProgress : "#5abcd8"
        }
    }

    /** Chart's **/

    property QtObject chart : QtObject{

        property QtObject circle : QtObject{

            /** HomePage **/
            property QtObject calories : QtObject{
                property color outColor : Suru.theme === 0 ? "#90ee90" : "#808080ff" 
                property color inColor : "#aea79f" 
            }

            /** SetFoodPage **/
            property QtObject productNutrients : QtObject{
                property color fatPie :  nutrientsColors.fat
                property color fatPieHighlight : "#FF5A5E"
                property color carbPie : nutrientsColors.carbo 
                property color carbPieHighlight : "#A8B3C5"
                property color proteinPie : nutrientsColors.protein 
                property color proteinPieHighlight : "#5AD3D1"

            }
        }

        property QtObject bar : QtObject{

            /** GraphsPage **/
            property QtObject nutriscore : QtObject{
                property color backgroundColor : mainView.backgroundColor
                property string fillColor : Suru.theme === 0 ? "rgba(119,33,11,0.2)" : "rgba(144,238,144,0.2)"
                property string strokeColor : Suru.theme === 0 ? "rgba(119,33,11,1)" : "rgba(144,238,144,1)"
            }
        }

        property QtObject line: QtObject{

            /** GraphsPage **/
            property QtObject weight : QtObject{
                property color backgroundColor : mainView.backgroundColor
                property string fillColor : Suru.theme === 0 ? "rgba(119,33,11,0.2)" : "rgba(144,238,144,0.2)"
                property string strokeColor : Suru.theme === 0 ? "rgba(119,33,11,1)" : "rgba(144,238,144,1)"
            }

        }

    }
}