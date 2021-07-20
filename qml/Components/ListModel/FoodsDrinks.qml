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
import Ubuntu.Components.Pickers 1.0
import Ubuntu.Components.ListItems 1.3 as ListItem
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.LocalStorage 2.0
import QtQuick.XmlListModel 2.7



XmlListModel {
        id: xmlScheme

        source: Qt.locale().name === "pt_PT" ? 
        "../../xml/foods_pt.xml" : Qt.locale().name === "fr_FR" ?
        "../../xml/foods_fr.xml" : Qt.locale().name === "es_ES" ?
        "../../xml/foods_es.xml" : "../../xml/foods_uk.xml"
        query: queryCategory === 0 ? "/foods/item/Food" : "/foods/item/Drink"

        XmlRole { name: "product_name"; query: "product_name/string()"}
        XmlRole { name: "nutriscore_grade"; query: "nutriscore_grade/string()" }
        XmlRole { name: "type"; query: "type/string()" }
        XmlRole { name: "energy_kcal_100g"; query: "energy_kcal_100g/string()" }
        XmlRole { name: "fat_100g"; query: "fat_100g/string()" }
        XmlRole { name: "saturated_fat_100g"; query: "saturated_fat_100g/string()" }
        XmlRole { name: "carbohydrates_100g"; query: "carbohydrates_100g/string()" }
        XmlRole { name: "sugars_100g"; query: "sugars_100g/string()" }
        XmlRole { name: "proteins_100g"; query: "proteins_100g/string()" }
        Component.onCompleted: {
        console.log(Qt.locale().name)
        console.log("xml loaded")}
}
    
    