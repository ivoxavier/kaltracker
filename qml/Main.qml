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
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import io.thp.pyotherside 1.5
import "./js/DataBaseTools.js" as DataBase
import "./js/SpentTimeOnApp.js" as Telemetry
import "./Components"
import "./Components/ActionBar"



MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'kaltracker.ivoxavier'
    property string appVersion : "0.2"
    automaticOrientation: false
    anchorToKeyboard: true
    width: units.gu(45)
    height: units.gu(75)

    
    //app general
    property int metric
    property color defaultForegroundColor: UbuntuColors.porcelain
    property string defaultBackgroundColor: UbuntuColors.blue
    property color followSystemTheme : {}
    property int activeTheme: Suru.theme === 0 ? followSystemTheme = UbuntuColors.porcelain : followSystemTheme = UbuntuColors.dark
    backgroundColor: followSystemTheme
    property date boot : new Date()
    property int boot_hours : boot.getHours()
    property int boot_minutes : boot.getMinutes()
    property int boot_seconds : boot.getSeconds()

    //required to update dashboard after newIngestion
    signal initDB()

    //required to refresh dailyIngestion ListModel
    signal refreshListModel()


    //passing values to foodsTemplate
    property int foods_ingested
    property int now_or_after_ingestion
    property string stackProductName
    property string stackType
    property double stackEnergyKcal
    property double stackFat
    property double stackSaturated
    property double stackCarborn
    property double stackSugars
    property double stackProtein
    property string nutriscore_grade
    property string stackMonthIngestions
    property string userSchedule_time
    property string userSchedule_date


    //resumePage
    property int dashboardDailyIngestion : Math.round(DataBase.getUserKaloriesIngestedDuringDay())
    //property int dashboardUserMetric : DataBase.getUserKaloriesIngestionMetric()

    //user configs variables
    property string userName : DataBase.getUserName()
    property int userGoal : DataBase.getUserGoal()
    property string userActivityLevel : DataBase.getUserActivityLevel()
    property int userWeight : DataBase.getUserWeight()
    property int userHeight : DataBase.getUserHeight()
    property int userAge : DataBase.getUserAge()
    property string userSex : DataBase.getUserSex()
    property string userGoalCategory : DataBase.getUserGoalCategory()

    //pass id to hourPicker on resumePage
    property int id_ingestion_update_time


    Component{
        id: userFoodsListEditPage
        UserFoodsListEditPage{}
    }

    Component{
        id: userListIngestionPage
        UserListIngestionPage{}
    }
    

    Component{
        id: createUserListPage
        CreateUserListPage{}
    }
    
    Component{
        id: consumeHabitsPage
        ConsumeHabitsPage{}
    }


    Component{
        id: indexesCalcPage
        IndexesCalcPage{}
    }
    
     
    Component{
        id: alertDialog
        AlertDialog{}
    }
     
    Component{
        id: alertsPage
        AlertsPage{}
    }
     
    Component{
        id: maintenancePage
        MaintenancePage{}
    }

    
    Component{
        id: monthIngestionsPage
        MonthIngestionsPage{}
    }
    
    Component{
        id: averageCaloriesMonth
        AverageCaloriesMonthPage{}
    }

    Component{
        id: statsPage
        StatsPage{}
    }
    
    
    Component{
        id: settingsPage
        SettingsPage{}
    }

    Component{
        id: userAccountPage
        UserAccountPage{}
    }

    Component{
        id: exportDataPage
        ExportDataPage{}
    }

    Component{
        id: foodsTemplate
        FoodsTemplate{}
    }

    Component{
        id: helpUserConfigDialog
        HelpUserConfigDialog{}
    }

    Component {
        id: configUserProfilePage
        ConfigUserProfilePage{}
    }

    Component {
        id: scheduleIngestionPage
        ScheduleIngestionPage {}
    }

    Component {
        id: openFoodsFactsListPage
        OpenFoodsFactsListPage {}
    }

    Component {
        id: welcomePage
        WelcomePage {}
    }


    Component{
        id: resumePage
        ResumePage{}
    }

    Component {
      id: createTablesDialog
        CreateTablesDialog{}
    }


    Settings {
        id: appSettings

        category: "app_configs"

        property bool isCleanInstall: true
        property bool isAutoCleanChecked: true
        property bool isExceedCaloriesChecked : true
        property bool displayAlert: false
        property bool isUserListCreated : false
        property bool isBothFoodsListChecked : false
        property bool isOpenFactsFoodsListChecked : true
        property bool isUserListFoodsChecked : false
        property bool isTelemetryChecked : true
        property bool isTelemetryDBCreated : false
    }


    Python{
        id: py
        Component.onCompleted:{
            console.log('Python: ' + pythonVersion())
            console.log('PyOtherSide: ' + pluginVersion())
            addImportPath(Qt.resolvedUrl('./py/'))
            importModule('store_telemetry', function() {
                py.call('store_telemetry.moduleState', [] ,function(returnValue){
                console.log(returnValue)
            })
            })

        }
        onError: {
            console.log('Python error: ' + traceback);
        }

    }                                 

    PageStack{
        id: mainStack
        onCurrentPageChanged: {
            console.log("Current Stack: " + currentPage.objectName)
        }

    }


    Component.onCompleted: {
        console.log("boot at",boot)
        if (appSettings.isCleanInstall){

            mainStack.push(welcomePage);

        } else {

            mainStack.push(resumePage);
        }

        if (appSettings.isAutoCleanChecked){

            DataBase.autoClean()

        } else {
                //pass
        }

        if (appSettings.isExceedCaloriesChecked){
            if (appSettings.displayAlert){
                PopupUtils.open(alertDialog)
            }
            } else {
                    //pass
            }
        
        if(appSettings.isTelemetryChecked){
            if(appSettings.isTelemetryDBCreated){
                //pass
            } else{
                py.call('store_telemetry.ManageDW.dropTable', [] ,function(returnValue){
                console.log(returnValue)
            })

            py.call('store_telemetry.ManageDW.createTable', [] ,function(returnValue){
                console.log(returnValue)
            })

            appSettings.isTelemetryDBCreated = !appSettings.isTelemetryDBCreated
            }
            
            
        } else {
            //pass
        }
    }

    Component.onDestruction:{
        if(appSettings.isTelemetryChecked){
            py.call('store_telemetry.ManageDW.saveTime', [Telemetry.getTimeUsage()] ,function(returnValue){
            })
        
        } else {
            //pass
        }
 }  
}

