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
import QtQuick.Controls.Suru 2.2
import QtQuick.LocalStorage 2.12
import io.thp.pyotherside 1.5
import "./js/DataBaseTools.js" as DataBase
import "./js/Quotes.js" as Quotes
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

    property color defaultForegroundColor: UbuntuColors.porcelain
    property string defaultBackgroundColor: UbuntuColors.blue
    property color followSystemTheme : {}
    property int activeTheme: Suru.theme === 0 ? followSystemTheme = UbuntuColors.porcelain : followSystemTheme = UbuntuColors.dark
    backgroundColor: followSystemTheme

    //required to update dashboard after newIngestion
    signal initDB()

    //required to refresh dailyIngestion ListModel
    signal refreshListModel()

    //passing values to foodsTemplate
    property string stackProductName
    property double stackEnergyKcal
    property double stackFat
    property double stackSaturated
    property double stackCarborn
    property double stackSugars
    property double stackFiber
    property double stackProtein
    property double stackSalt
    property string stackMonthIngestions

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
        id: newIngestionPage
        NewIngestionPage {}
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
        

    }
                                                    
    Settings {
        id: userSettings
        category: "user_configs"

        property int userConfigsGoal
        property string userConfigsUserName
        property int userConfigsHeight
        property int userConfigsWeight
        property string userConfigsSex
        property int userConfigsAge

    }

    PageStack{
        id: mainStack
        onCurrentPageChanged: {
            console.log("Current Stack: " + currentPage.objectName)
        }

    }

    Component.onCompleted: { /* check on pageComplete */
        if (appSettings.isCleanInstall){
            mainStack.push(welcomePage);
        } else {
            mainStack.push(resumePage);
            function isCleanInstallStatus(){
                console.log('mainView: Not clean install') 
            }
                isCleanInstallStatus();  
        }
    } 
}

