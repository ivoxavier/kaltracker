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
import QtQuick.Controls 2.2 as QQC2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Lomiri.Components.ListItems 1.3 
import Lomiri.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import Lomiri.Content 1.3
import Lomiri.Components.Pickers 1.3
import "components"
import "style"
import "plugins"
import "logicalFields"
import "../js/Chart.js" as Charts
import "../js/QChartJsTypes.js" as ChartTypes
import "../js/UserTable.js" as UserTable
import "../js/IngestionsTable.js" as IngestionsTable
import "../js/UserFoodsListTable.js" as UserFoodsListTable


Page{
    id: set_food_page
    objectName: 'SetFoodPage'
    header: PageHeader {
                title: swipe_view.currentIndex == 0 ?
        i18n.tr("Set Your Ingestion") : i18n.tr("Product Details")
                StyleHints {
                    /*foregroundColor: "white"
                    backgroundColor:  Suru.theme === 0 ? ThemeColors.utFoods_blue_theme_background : ThemeColors.utFoods_dark_theme_background */
            }
        }
    
    BackgroundStyle{}
    
    
    function getChartPieValues(){
        var ChartPieData = [
            {
                value: logical_fields.ingestion.fat_ingested,
                color: app_style.chart.circle.productNutrients
                .fatPie,
                highlight: app_style.chart.circle.productNutrients
                .pieHighlight,
                label: i18n.tr("Fat/100g")
            },
            {
                value: logical_fields.ingestion.protein_ingested,
                color: app_style.chart.circle.productNutrients
                .proteinPie,
                highlight: app_style.chart.circle.productNutrients
                .pieHighlight,
                label: i18n.tr("Protein/100g")
            },
            {
                value: logical_fields.ingestion.carbo_ingested,
                color: app_style.chart.circle.productNutrients
                .carbPie,
                highlight: app_style.chart.circle.productNutrients
                .pieHighlight,
                label: i18n.tr("Carbo/100g")
            }
        ]
        return ChartPieData
    }
    

    Component{
        id: sucess_dialog
        StoreIngestionDialog{msg:i18n.tr("Stored!")}
    }

    Component{
        id: error_dialog
        MessageDialog{msg:i18n.tr("Something went wrong. Please, restart the app and try again.")}
    }

    QQC2.SwipeView{
        id: swipe_view
        currentIndex:0
        anchors.top:parent.header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height

        Item{
            //index 0
            Flickable{
                anchors.fill: parent
                contentWidth: swipe_view.width
                contentHeight: ingestions_config.implicitHeight
                interactive: true

                IngestionConfig{id:ingestions_config}
            }
        }
        Item{
            //index 1
            Flickable{
                anchors.fill: parent
                contentWidth: swipe_view.width
                contentHeight: product_details.implicitHeight
                interactive: true

                ProductDetails{id:product_details}
            }
        }
    }

    Row{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: root.width
        layoutDirection: Qt.RightToLeft 
        rightPadding: units.gu(1)
        bottomPadding: units.gu(1)
        IconButton{
            icon_name : "ok"
            MouseArea{
                
                anchors.fill: parent
                onClicked:{
                    try{
                        if(UserFoodsListTable.isUnique(logical_fields.ingestion.product_name) >= 1){
                        /* REGISTER INGESTION */
                        //item already on DB
                        IngestionsTable.saveIngestion(logical_fields.ingestion.product_name,
                        logical_fields.ingestion.nutriscore, logical_fields.ingestion.cal_ingested,
                        logical_fields.ingestion.fat_ingested, logical_fields.ingestion.carbo_ingested,
                        logical_fields.ingestion.protein_ingested, logical_fields.ingestion.meal_type)
                        
                    } else{
                        /* CREATE NEW ENTRY */
                        //new item
                        UserFoodsListTable.saveIngestion(logical_fields.ingestion.product_name,
                        logical_fields.ingestion.nutriscore, logical_fields.ingestion.cal,
                        logical_fields.ingestion.fat, logical_fields.ingestion.carbo,
                        logical_fields.ingestion.protein)

                        /* REGISTER INGESTION */
                        IngestionsTable.saveIngestion(logical_fields.ingestion.product_name,
                        logical_fields.ingestion.nutriscore, logical_fields.ingestion.cal_ingested,
                        logical_fields.ingestion.fat_ingested, logical_fields.ingestion.carbo_ingested,
                        logical_fields.ingestion.protein_ingested, logical_fields.ingestion.meal_type)
                    }
                    } catch (err){
                            PopupUtils.open(error_dialog)
                    } 
                    root.initDB()
                    PopupUtils.open(sucess_dialog)
                }
            }  
        }
    }

    QQC2.PageIndicator{
        id: swipe_view_indicator
        count: swipe_view.count
        currentIndex: swipe_view.currentIndex
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter   
    } 
}