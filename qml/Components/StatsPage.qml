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
import Ubuntu.Components.ListItems 1.3 as ListItem
import Ubuntu.Components.Popups 1.3
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12
import io.thp.pyotherside 1.5
import Qt.labs.platform 1.0
import Ubuntu.Content 1.3
import "../js/DataBaseTools.js" as DataBase


Page{
    id: statsPage
    objectName: 'Stats Page'

    property string type
    property int total

    header: PageHeader {
        Component.onCompleted:{
            recordsPageColumn.visible = false;
            topPanelLabel.visible = true;
            statsView.visible = true
        }

        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }

        title: i18n.tr("Stats")
        sections {

            model: {[i18n.tr("Frequencies"), i18n.tr("History")]} //logs - index 0 // Stats - index 1
            selectedIndex: 0
            
            onSelectedIndexChanged: {
                if (sections.selectedIndex === 1){
                    recordsPageColumn.visible = true;
                    topPanelLabel.visible = false;
                    statsView.visible = false
                 
                } else {
                    recordsPageColumn.visible = false;
                    topPanelLabel.visible = true;
                    statsView.visible = true
                }
            }
        }  
    }

    ListModel {
        id: foodsCategory
        Component.onCompleted: DataBase.getFoodsType()
    }

    Label{
        id: topPanelLabel
        text: i18n.tr(" Total foods ingested by type")
        font.bold: true 

        anchors.top: statsPage.header.bottom
        anchors.horizontalCenter: statsPage.horizontalCenter   
    }

        GridView {
            id: statsView
            width: statsPage.width
            anchors.horizontalCenter: statsPage.horizontalCenter 
            anchors.top: topPanelLabel.bottom
            
        
            model: foodsCategory
    
            delegate: Column{ 
                id: statsColumn
                width: statsPage.width
                topPadding: units.gu(2)
                spacing: units.gu(2)

                Row{
                    Label { text: type + '\n' + total}
                }

                ListItem.ThinDivider{}    

            }  

        }  

    Column{
        id: recordsPageColumn
        width: statsPage.width  

        anchors {
            top: statsPage.header.bottom
            left: statsPage.left
            right: statsPage.right
            bottom: statsPage.bottom
        }
            ScrollView {
                id: scrollView

                anchors {
                    top: recordsPageColumn.top
                    topMargin: units.gu(1)
                    left: recordsPageColumn.left
                    right: recordsPageColumn.right
                    bottom: recordsPageColumn.bottom
                }


            TextEdit {
                id: recordsHistory
                text: DataBase.getAllIngestions("recordsLog")
                wrapMode: TextEdit.Wrap
                width: scrollView.width
                readOnly: true
                font.family: "Ubuntu Mono"
                textFormat: TextEdit.PlainText
                color: theme.palette.normal.fieldText
            }        
        }
    }      
}


        