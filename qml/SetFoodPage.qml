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
    
   
    //receives values from foods from QuickFoodsList{}
    property string product_name_set_food_page
    property string nutriscore_set_food_page
    property string nova_groups_set_food_page
    property int cal_set_food_page
    property double carbo_set_food_page
    property double fat_set_food_page
    property double protein_set_food_page
    property int meal_set_food_page

    //store quantity and portions
    property int quantity_portions : 1
    property double size_portions : 1

    //cal and nutriens ingested
    property int cal_ingested : Math.round(cal_set_food_page * quantity_portions) * size_portions
    property double carbo_ingested : Math.round((carbo_set_food_page * quantity_portions) * size_portions * 10) / 10
    property double fat_ingested : Math.round((fat_set_food_page * quantity_portions) * size_portions * 10) / 10
    property double protein_ingested : Math.round((protein_set_food_page * quantity_portions) * size_portions * 10) / 10
    
    function getChartPieValues(){
        var ChartPieData = [
            {
                value: fat_ingested,
                color: app_style.chart.circle.productNutrients
                .fatPie,
                highlight: app_style.chart.circle.productNutrients
                .pieHighlight,
                label: i18n.tr("Fat/100g")
            },
            {
                value: protein_ingested,
                color: app_style.chart.circle.productNutrients
                .proteinPie,
                highlight: app_style.chart.circle.productNutrients
                .pieHighlight,
                label: i18n.tr("Protein/100g")
            },
            {
                value: carbo_ingested,
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
                        if(UserFoodsListTable.isUnique(product_name_set_food_page) >= 1){
                        /* REGISTER INGESTION */
                        //item already on DB
                        IngestionsTable.saveIngestion(product_name_set_food_page,
                        nutriscore_set_food_page, cal_ingested,
                        fat_ingested, carbo_ingested,
                        protein_ingested, meal_set_food_page)
                        root.initDB()
                        PopupUtils.open(sucess_dialog)
                    } else{
                        /* CREATE NEW ENTRY */
                        //new item
                        UserFoodsListTable.saveIngestion(product_name_set_food_page,
                        nutriscore_set_food_page, cal_set_food_page,
                        fat_set_food_page, carbo_set_food_page,
                        protein_set_food_page)
                        root.initDB()

                        /* REGISTER INGESTION */
                        IngestionsTable.saveIngestion(product_name_set_food_page,
                        nutriscore_set_food_page, cal_ingested,
                        fat_ingested, carbo_ingested,
                        protein_ingested, meal_set_food_page)
                        root.initDB()
                        PopupUtils.open(sucess_dialog)
                    }
                    } catch (err){
                            PopupUtils.open(error_dialog)
                    } 
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