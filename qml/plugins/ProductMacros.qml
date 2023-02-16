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
import Lomiri.Components.Pickers 1.3
import QtCharts 2.3
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import "../components"
import "../style"


GridLayout{
    width: root.width
    height: root.height - units.gu(18)
    columns: 3
   
    //first row
    Text {Layout.alignment: Qt.AlignTop | Qt.AlignHCenter; text: fat_quick_addition_page; font.bold: true;color : app_style.label.labelColor  }
    Text {Layout.alignment: Qt.AlignTop | Qt.AlignHCenter;text: protein_quick_addition_page; font.bold: true;color : app_style.label.labelColor  }
    Text {Layout.alignment: Qt.AlignTop | Qt.AlignHCenter;text: carbo_quick_addition_page; font.bold: true;color : app_style.label.labelColor }
    
    //second row
    NutrientSlider{
        Layout.alignment: Qt.AlignCenter | Qt.AlignHCenter
        onValueChanged: fat_quick_addition_page = Number(value.toFixed(1))
    }

    NutrientSlider{
        Layout.alignment: Qt.AlignCenter | Qt.AlignHCenter
        onValueChanged : protein_quick_addition_page = Number(value.toFixed(1))   
    }

    NutrientSlider{
        Layout.alignment: Qt.AlignCenter | Qt.AlignHCenter
        onValueChanged : carbo_quick_addition_page = Number(value.toFixed(1))
    }
    
    //third row
    NutrientIcon{Layout.alignment: Qt.AlignCenter | Qt.AlignHCenter;img_path: "../../assets/olive-oil-svgrepo-com.svg"} 
    NutrientIcon{Layout.alignment: Qt.AlignCenter | Qt.AlignHCenter;img_path: "../../assets/cheese-svgrepo-com.svg"} 
    NutrientIcon{Layout.alignment: Qt.AlignCenter | Qt.AlignHCenter;img_path: "../../assets/bread-svgrepo-com.svg"}   
    
    //fourth row
    Text {Layout.alignment: Qt.AlignTop | Qt.AlignHCenter; text: i18n.tr("Fat/100g");color : app_style.label.labelColor  }
    Text {Layout.alignment: Qt.AlignTop | Qt.AlignHCenter;text: i18n.tr("Protein/100g"); color : app_style.label.labelColor  }
    Text {Layout.alignment: Qt.AlignTop | Qt.AlignHCenter;text: i18n.tr("Carbo/100g"); color : app_style.label.labelColor }
}