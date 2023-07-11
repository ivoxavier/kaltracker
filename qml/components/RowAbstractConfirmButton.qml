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
import Lomiri.Components 1.3
//import QtQuick.Controls 2.2 as QC
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import Lomiri.Components.Pickers 1.3
import QtQuick.LocalStorage 2.12
import "../../js/UserFoodsListTable.js" as UserFoodsListTable
import "../../js/IngestionsTable.js" as IngestionsTable

Row{
	width: root.width
    layoutDirection: Qt.RightToLeft 
    rightPadding: units.gu(2)
    bottomPadding: units.gu(2)

    IconButton{
        icon_name: "ok"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                try{
                    if(UserFoodsListTable.isUnique(logical_fields.ingestion.product_name) >= 1){
                        /* REGISTER INGESTION */
                        //item already on DB
                        IngestionsTable.saveIngestion(logical_fields.ingestion.product_name,
                        logical_fields.ingestion.nutriscore, logical_fields.ingestion.cal,
                        logical_fields.ingestion.fat, logical_fields.ingestion.carbo,
                        logical_fields.ingestion.protein, logical_fields.ingestion.meal_type)
                        
                    } else{
                        /* CREATE NEW ENTRY */
                        //new item
                        UserFoodsListTable.saveIngestion(logical_fields.ingestion.product_name,
                        logical_fields.ingestion.nutriscore, logical_fields.ingestion.cal,
                        logical_fields.ingestion.fat, logical_fields.ingestion.carbo,
                        logical_fields.ingestion.protein)

                        /* REGISTER INGESTION */
                        IngestionsTable.saveIngestion(logical_fields.ingestion.product_name,
                        logical_fields.ingestion.nutriscore, logical_fields.ingestion.cal,
                        logical_fields.ingestion.fat, logical_fields.ingestion.carbo,
                        logical_fields.ingestion.protein, logical_fields.ingestion.meal_type)  
                    }

                    root.initDB()
                    PopupUtils.open(sucess_dialog)
                } catch (err){
                    PopupUtils.open(error_dialog)
                }  
            }
        }
    }
}