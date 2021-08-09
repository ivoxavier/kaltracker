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
import "../js/Bmi.js" as CalcBMI
import "../js/Ibw.js" as CalcIBW
import "../js/KaloriesCalculator.js" as KalCalculator


Page{
    id: indexesCalcPage
    objectName: 'User Indexes Page'

    signal awareness_level(double awareness_level_QML)


    Component{
        id: adviceDialog
        AdviceIndexexDialog{}
    }

    Python{
        id: py
        Component.onCompleted:{
            addImportPath(Qt.resolvedUrl('../py/'))
            importModule('awareness_level', function() {})

        }
        onError: {
            console.log('Python error: ' + traceback);
        }

    }


    header: PageHeader {
        title: i18n.tr("Indexes")
    



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
            topPadding:  indexesCalcPage.header.height
            width: indexesCalcPage.width

            Row{

                Rectangle{
                    height: indexesCalcPage.header.height * 2
                    width: indexesCalcPage.width
                    color: "transparent"

                    Label{
                        id: userbmi_label

                        anchors.centerIn: parent
                        text: CalcBMI.getBmi()
                        
                        
                        font.bold: true    
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("large")
                    }
                    Label{
                        text: i18n.tr("Body mass index: ") + CalcBMI.getBmiIndex()
                        
                        anchors.top: userbmi_label.bottom
                        
                        anchors.horizontalCenter: parent.horizontalCenter
                        
  
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("medium")
                    }
                    
                }
            }

            Row{

                Rectangle{
                    height: indexesCalcPage.header.height * 2
                    width: indexesCalcPage.width
                    color: "transparent"

                    Label{
                        id: idealWt_label

                        anchors.centerIn: parent
                        text: CalcIBW.idealWT()
                        
                        
                        font.bold: true    
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("large")
                    }
                    Label{
                        text: i18n.tr("Your ideal weight (Kg)")
                        
                        anchors.top: idealWt_label.bottom
                        
                        anchors.horizontalCenter: parent.horizontalCenter
                        
  
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("medium")
                    }
                    
                }
            }

            Row{

                Rectangle{
                    height: indexesCalcPage.header.height * 2
                    width: indexesCalcPage.width
                    color: "transparent"

                    Label{
                        id: difWt_label

                        anchors.centerIn: parent
                        text: CalcIBW.wtDif()
                        
                        
                        font.bold: true    
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("large")
                    }
                    Label{
                        text: i18n.tr("Current weight difference")
                        
                        anchors.top: difWt_label.bottom
                        
                        anchors.horizontalCenter: parent.horizontalCenter
                        
  
                        fontSizeMode: Text.Fit 
                        font.pixelSize: FontUtils.sizeToPixels("medium")
                    }
                    
                }
            }

            
            ListItem{
                ListItemLayout{
                    title.text: i18n.tr("Advices")
        
                    ProgressionSlot{}
                }
               onClicked: {
                
                py.call('awareness_level.getAdvice', [CalcBMI.getBmi(),CalcIBW.idealWT(), userSettings.userConfigsWeight] ,function(returnValue){
                    awareness_level(returnValue)
                
                })
                PopupUtils.open(adviceDialog)
               }
            }

        }
    }

}