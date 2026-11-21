/*
 * 2022-2026  Ivo Xavier
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
import QtQuick.Controls.Suru 2.2

QtObject {
    readonly property bool isLight: Suru.theme === 0

    property QtObject mainView: QtObject {

        property color backgroundColor: isLight ? "#F4F5F7" : "#121214"
    }

    property QtObject label: QtObject {
        property color labelColor: isLight ? "#1C1C1E" : "#F2F2F7"
        property color secondaryColor: isLight ? "#6E6E73" : "#98989D"

        property QtObject labelError: QtObject {
            property color labelColor: "#EF4444"
        }
    }

    property QtObject button: QtObject {
        property QtObject confirmButton: QtObject {
            property color buttonColor: "#10B981"
        }

        property QtObject actionButton: QtObject {
            property color buttonColor: "#3B82F6"
        }

        property QtObject deleteButton: QtObject {
            property color buttonColor: "#EF4444"
        }
    }

    property QtObject abstractButton: QtObject {
        property color buttonColor: "#10B981"
        property color iconColor: "#FFFFFF"
    }

    property QtObject shape: QtObject {
        // Cartões brancos puros em Light, cinzento escuro elevado em Dark
        property color shapeColor: isLight ? "#FFFFFF" : "#1E1E22"

        property QtObject textInput: QtObject {
            property color shapeColor: isLight ? "#F0F1F3" : "#2A2A2F"
        }

        property QtObject sliderNutrient: QtObject {
            property color shapeColor: isLight ? "#FFFFFF" : "#1E1E22"
        }
    }

    property QtObject pickers: QtObject {
        property QtObject datePicker: QtObject {
            property color backgroundColor: shape.shapeColor
            property color highlightColor: isLight ? "#1C1C1E" : "#F2F2F7"
            property color highlightBackgroundColor: theme.palette.normal.raised
        }

        property QtObject yearsPicker: QtObject {
            property color backgroundColor: shape.shapeColor
            property color highlightColor: isLight ? "#1C1C1E" : "#F2F2F7"
            property color highlightBackgroundColor: theme.palette.normal.raised
        }

        property QtObject sizePicker: QtObject {
            property color backgroundColor: shape.shapeColor
            property color highlightColor: isLight ? "#1C1C1E" : "#F2F2F7"
            property color highlightBackgroundColor: theme.palette.normal.raised
        }
    }

    // Paleta de macros equilibrada com bom contraste em Light e Dark Mode
    property QtObject nutrientsColors: QtObject {
        property color fat: "#F59E0B"      // Âmbar
        property color carbo: "#3B82F6"    // Azul vibrante
        property color protein: "#10B981"  // Verde esmeralda
    }

    /** Progress Bars **/

    property QtObject progressBar: QtObject {
        property color backgroundColor: isLight ? "#E5E7EB" : "#2C2C32"

        /** HomePage **/
        property QtObject nutrientBar: QtObject {
            property color fatProgress: nutrientsColors.fat
            property color carbProgress: nutrientsColors.carbo
            property color proteinProgress: nutrientsColors.protein
        }

        property QtObject waterBar: QtObject {
            property color waterProgress: "#38BDF8" // Azul água moderno
        }
    }

    /** Charts **/

    property QtObject chart: QtObject {

        property QtObject circle: QtObject {
            /** HomePage **/
            property QtObject calories: QtObject {
                property color outColor: isLight ? "#10B981" : "#34D399"
                property color inColor: isLight ? "#D1D5DB" : "#3F3F46"
            }

            /** SetFoodPage **/
            property QtObject productNutrients: QtObject {
                property color fatPie: nutrientsColors.fat
                property color carbPie: nutrientsColors.carbo
                property color proteinPie: nutrientsColors.protein
                property color pieHighlight: "#8B5CF6"
            }
        }

        property QtObject bar: QtObject {
            /** GraphsPage **/
            property QtObject nutriscore: QtObject {
                property color backgroundColor: shape.shapeColor
                property string fillColor: isLight ? "rgba(16, 185, 129, 0.25)" : "rgba(52, 211, 153, 0.25)"
                property string strokeColor: isLight ? "rgba(16, 185, 129, 1)" : "rgba(52, 211, 153, 1)"
            }
        }

        property QtObject line: QtObject {
            /** GraphsPage **/
            property QtObject weight: QtObject {
                property color backgroundColor: shape.shapeColor
                property string fillColor: isLight ? "rgba(59, 130, 246, 0.2)" : "rgba(96, 165, 250, 0.2)"
                property string strokeColor: isLight ? "rgba(59, 130, 246, 1)" : "rgba(96, 165, 250, 1)"
            }
        }
    }
}
