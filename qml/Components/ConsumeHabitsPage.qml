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
import Ubuntu.Components.ListItems 1.3 //as ListItem
import Ubuntu.Components.Popups 1.3
import QtQuick.Layouts 1.3
import Ubuntu.Components.Pickers 1.3
import QtQuick.LocalStorage 2.12
import io.thp.pyotherside 1.5
import Qt.labs.platform 1.0
import Ubuntu.Content 1.3
import "../js/DataBaseTools.js" as DataBase



Page{
    id: consumeHabitsPage
    objectName: 'ConsumeHabitsPage'

    signal awareness_level(double awareness_level_QML)


    header: PageHeader {
        title: i18n.tr("Your Habits")
    



        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }

        ActionBar {

            StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
            }
            
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    ScrollView{
        id: scrollView
        width: parent.width
        height : parent.height
        clip : true                 
 

        Column{  
            id: userDetailsColumn
            topPadding:  consumeHabitsPage.header.height
            width: consumeHabitsPage.width

            Row{

                Rectangle{
                    height: consumeHabitsPage.header.height * 2
                    width: consumeHabitsPage.width
                    color: "transparent"

                    Label{
                        id: favoriteFoods

                        anchors.centerIn: parent
                        text: DataBase.getFavFood()
                        
                        
                        font.bold: true    
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("large")
                    }
                    Label{
                        text: i18n.tr("Most consumed")
                        
                        anchors.top: favoriteFoods.bottom
                        
                        anchors.horizontalCenter: parent.horizontalCenter
                        
  
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("medium")
                    }
                    
                }
            }

            Row{

                Rectangle{
                    height: consumeHabitsPage.header.height * 2
                    width: consumeHabitsPage.width
                    color: "transparent"

                    Label{
                        id: favGrade_label

                        anchors.centerIn: parent
                        text: DataBase.getFavGrade()
                        
                        
                        font.bold: true    
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("large")
                    }
                    Label{
                        text: i18n.tr("Nutriscore grade class most eaten")
                        
                        anchors.top: favGrade_label.bottom
                        
                        anchors.horizontalCenter: parent.horizontalCenter
                        
  
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("medium")
                    }
                    
                }
            }

        }
    }

}