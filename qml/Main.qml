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
import Qt.labs.settings 1.0
import StreamsConn 1.0
import QtQuick.LocalStorage 2.12 as Sql
import "style"
import "settings"
import "logicalFields"

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'kaltracker.ivoxavier'
    automaticOrientation: false
    anchorToKeyboard: true
    width: units.gu(45)
    height: units.gu(75)

    
    /* custom signals --start--*/
    signal initDB()
    /* custom signals --end--*/

    //creates a config file under /home/phablet/.config/kaltracker.ivoxavier
    AppSettings{id: app_settings}

    //Style for the app
    Style{id:app_style}

    //Logical Fields of the App
    LogicalFields{id:logical_fields}

    //handles the push and pop of stacks in MainView. Plus, logs the currentPage
    PageStack{
        id: page_stack
        onCurrentPageChanged: {
            if(currentPage !== null){
                console.log("Current Stack: " + currentPage.objectName)
            }
        }   
    }

    //UserProfileConfig
    Component{
        id: user_profile_config_page
        UserProfileConfigPage{}
    }
    

    //CreatePage, process for creating the db
    Component{
        id: create_storage_page
        CreateStoragePage{}
    }

    //HomePage, its home
    Component{
        id: home_page
        HomePage{}
    }

    //QuickListFoodsPage gives users a list of foods
    Component{
        id: quick_list_foods_page
        QuickListFoodsPage{}
    }

    //QuickListFoodsPage gives users a list of foods
    Component{
        id: quick_addition_page
        QuickAdditionPage{}
    }


    //SetFoodPage, let uses set the ingestions
    Component{
        id: set_food_page
        SetFoodPage{}
    }

    //MenuPage, menu 
    Component{
        id: menu_page
        MenuPage{}
    }

    //UpdateUserValuesPage, let users import a profile pic 
    Component{
        id: update_user_values_page
        UpdateUserValuesPage{}
    }

    //AppLayoutPage, let users define appearance settings
    Component{
        id: app_layout_page
        AppLayoutPage{}
    }

    //OnlineSourcesPage, let enable online sources
    Component{
        id: online_sources_page
        OnlineSourcesPage{}
    }

    //ManageDataPage, let enable online sources
    Component{
        id: manage_data_page
        ManageDataPage{}
    }


    //ManageUserFoodsListPage, let enable online sources
    Component{
        id: manager_user_foods_list_page
        ManageUserFoodsListPage{}
    }

    //DeleteTodayIngestionPage, let user delete each ingestion of dat by swipping from a list
    Component{
        id: delete_today_ingestion_page
        DeleteTodayIngestionPage{}
    }

    //BackupRestorePage, where users can export import data
    Component{
        id: backup_restore_page
        BackupRestorePage{}
    }

    //DataAnalysisPage, where users can check theirs consunption habits
    Component{
        id: data_analysis_page
        DataAnalysisPage{}
    }

    //AverageCaloriesPage, average calories page
    Component{
        id: average_calories_page
        AverageCaloriesPage{}
    }

    //ListFoodsIngestedMonthPage, list with the respective foods ingested by month
    Component{
        id: list_foods_ingested_month_page
        ListFoodsIngestedMonthPage{}
    }

    //GraphsPage, page containig data visualization
    Component{
        id: graphs_page
        GraphsPage{}
    }

    //BodyMeasuresPage, page containig body measurements
    Component{
        id: body_measures_page
        BodyMeasuresPage{}
    }

    //NotesPage, page for view registed notes
    Component{
        id: notes_page
        NotesPage{}
    }

    //ThirdPartySoftwarePage, page with used software from third parties
    Component{
        id: third_party_software_page
        ThirdPartySoftwarePage{}
    }

    //ScanPage, opens a video capture page where the images captured are analyzed to see exists a barcode
    Component{
        id: scan_page
        ScanPage{}
    }

    Streams {
        id: streams
        
        databasePath: Sql.LocalStorage.openDatabaseSync("kaltracker_db", "0.2", "keepsYourData", 2000000).toString()

            function dataBase() {
           
                var query = `SELECT * FROM user; `
                if(streams.openDatabase()){
                    print("yes")
                    var ehehe = streams.executeQuery(query)
                    print(ehehe)
                }
                else{
                    print("no")
                }
            }
    Component.onCompleted: dataBase()

    }


    Component.onCompleted:{
        if(app_settings.is_clean_install){
            //new install || not configured
            page_stack.push(user_profile_config_page)
        }
        else{
        //during experiment time and app configured
            page_stack.push(home_page)
        }
    }
}