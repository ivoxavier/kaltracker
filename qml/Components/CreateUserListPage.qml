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
import QtQuick.Controls 2.2 as QQC2
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import QtCharts 2.3
import io.thp.pyotherside 1.5
import Qt.labs.platform 1.0
import QtQuick.LocalStorage 2.12
import "../js/DataBaseTools.js" as DataBase
import "../js/UserFoodsListDB.js" as UserFoodsListDB
import "./ListModel"
import "UiAddOns"


Page {
    
    id: manageUserList
    objectName: 'ManageUserListPage'
    
    property bool isActivated: false


    header: PageHeader {
        title: i18n.tr("Create your list")
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
            
            numberOfSlots: 2

            actions: [

                Action{

                    iconName: "ok"
                    
                     onTriggered: {
                          
                            UserFoodsListDB.saveUserListFoods(root.stackProductName,
                            root.nutriscore_grade,
                            root.stackType,
                            root.stackEnergyKcal,
                            root.stackFat,
                            root.stackSaturated,
                            root.stackCarborn,
                            root.stackSugars,
                            root.stackProtein)

                            PopupUtils.open(storedDialog)
                            defaultValues()
                            productNameEntry.remove(0,productNameEntry.length)
                            kcalEntry.remove(0,kcalEntry.length)
                            
                     }
                },

                Action{

                    iconName: "edit"

                    text: i18n.tr("Edit")
                    
                     onTriggered: {
                         mainStack.push(userFoodsListEditPage)
                     }
                }

            ]
        }
    }

   


     Component {
        id: storedDialog
        SaveDataDialog{

            msg:i18n.tr("Saved!")
            
            labelColor:UbuntuColors.green
            }
    }


    ScrollView{ 
        id: scrollView
        width: parent.width
        height : parent.height
        clip : true                 
        


        Column{
            id: column
            topPadding:  manageUserList.header.height
            width: manageUserList.width
            
            ListItemHeader{
                    title.text: i18n.tr("Details")
                }

            ListItem {
                    
                    divider.visible: false

                    ListItemLayout{
                        TextField{
                            id: productNameEntry
                            SlotsLayout.position: SlotsLayout.Leading
                            width: (scrollView.width / 2) + units.gu(5)
                            height: units.gu(5) 
                            placeholderText : i18n.tr("Product name")
                            onTextChanged: root.stackProductName = productNameEntry.text
                        }

                        Picker {
                            id: foodTypePicker
                        SlotsLayout.position: SlotsLayout.Trailing
                        width: units.gu(12)
                        height: units.gu(5)
                        circular: false
                        selectedIndex: 0
                        model: [ i18n.tr("Food"), i18n.tr("Drink")] 
                        delegate: PickerDelegate { 
                            Label {
                                text: modelData
                                
                                anchors.horizontalCenter: parent.horizontalCenter
                                
                                anchors.verticalCenter: parent.verticalCenter
                        }
                        }
                        onSelectedIndexChanged: selectedIndex === 0 ? root.stackType = "Food" : root.stackType = "Drink"
                
            } 

                    }
                }

            
            
            ListItem {

                divider.visible: false

                    ListItemLayout{
                        title.text: i18n.tr("Kcal/100g")

                        
                            TextField{
                                id: kcalEntry
                                width: units.gu(12)
                                height: units.gu(5) 
                                placeholderText: "0"
                                horizontalAlignment: TextInput.AlignHCenter
                                inputMethodHints: Qt.ImhDigitsOnly

                                onTextChanged: root.stackEnergyKcal = kcalEntry.text

                                onFocusChanged: kcalEntry.text = " "
                                
                            }
 
                    }
                    
                }                                               

                ListItem{
                
                 ListItemLayout{
                    title.text: i18n.tr("Nutriscore grade")

                    Picker {
                        id: nutriscorePicker
                        width: units.gu(12)
                        height: units.gu(5)
                        circular: false
                        selectedIndex: 0
                        model: [i18n.tr("A"), i18n.tr("B"),i18n.tr("C"),i18n.tr("D"),i18n.tr("E")] 

                        delegate: PickerDelegate { 
                            Label {
                                text: modelData
                                
                                anchors.horizontalCenter: parent.horizontalCenter
                                
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        onSelectedIndexChanged: selectedIndex === 0 ? 
                        root.nutriscore_grade = "a" : selectedIndex === 1 ?
                        root.nutriscore_grade = "b" : selectedIndex === 2 ? 
                        root.nutriscore_grade = "c" : selectedIndex === 3 ?
                        root.nutriscore_grade = "d" : root.nutriscore_grade = "e"
                
                    }
                }
            }



                ListItemHeader{
                    title.text: i18n.tr("Nutrients")
                }

                ListItem {
                    
                    divider.visible: false

                    ListItemLayout{
                        height: childrenRect.height
                        title.text: i18n.tr("Fat/100g")

                        Slider{
                            id: fatSlider
                            objectName: "slider_live"
                            width: parent.width / 2
                            height: units.gu(12)
                            value: 0
                            minimumValue: 0
                            maximumValue: 100
                            live: true
                            onValueChanged: {

                            root.stackFat = (Math.round(fatSlider.value * 10) / 10)
                            fatSliderValue.text = root.stackFat
                            }
                        }

                        Label{id: fatSliderValue; text: "0"}
                    }
                    
                } 

                ListItem {

                    divider.visible: false

                    ListItemLayout{
                        title.text: i18n.tr("Saturated fat/100g")
                        height: childrenRect.height

                        Slider{
                            id: saturatedSlider
                            objectName: "slider_live"
                            width: parent.width / 2
                            height: units.gu(12)
                            value: 0
                            minimumValue: 0
                            maximumValue: 100
                            live: true
                            onValueChanged: {
                            root.stackSaturated = (Math.round(saturatedSlider.value * 10) / 10)
                            saturatedSliderValue.text = root.stackSaturated
                            }
                        }

                        Label{id: saturatedSliderValue; text: "0"}
                        
 
                    }
                    
                } 

                ListItem {

                    divider.visible: false

                    ListItemLayout{
                        title.text: i18n.tr("Carbohydrates/100g")
                        height: childrenRect.height

                        Slider{
                            id: carboSlider
                            objectName: "slider_live"
                            width: parent.width / 2
                            height: units.gu(12)
                            value: 0
                            minimumValue: 0
                            maximumValue: 100
                            live: true
                            onValueChanged: {
                            root.stackCarborn = (Math.round(carboSlider.value * 10) / 10)
                            carboSliderValue.text = root.stackCarborn
                            }
                        }

                        Label{id: carboSliderValue; text: "0"}
 
                    }
                    
                } 

                ListItem {

                    divider.visible: false

                    ListItemLayout{
                        title.text: i18n.tr("Sugars/100g")
                        height: childrenRect.height
                        Slider{
                            id: sugarSlider
                            objectName: "slider_live"
                            width: parent.width / 2
                            height: units.gu(12)
                            value: 0
                            minimumValue: 0
                            maximumValue: 100
                            live: true
                            onValueChanged: {
                            root.stackSugars = (Math.round(sugarSlider.value * 10) / 10)
                            sugarSliderValue.text = root.stackSugars
                            }
                        }

                        Label{id: sugarSliderValue; text: "0"}
                    }
                    
                } 

                 ListItem {

                    divider.visible: false

                    ListItemLayout{
                        title.text: i18n.tr("Proteins/100g")
                        height: childrenRect.height

                        Slider{
                            id: proteinSlide
                            objectName: "slider_live"
                            width: parent.width / 2
                            height: units.gu(12)
                            value: 0
                            minimumValue: 0
                            maximumValue: 100
                            live: true
                            onValueChanged: {
                            root.stackProtein = (Math.round(proteinSlide.value * 10) / 10)
                            proteinSlideValue.text = root.stackProtein
                            }
                        } 

                        Label{id: proteinSlideValue; text: "0"}
                    }
                    
                } 
        }

    }

    function defaultValues() {
            root.stackType = "Food"
            root.stackEnergyKcal = 0
            root.stackFat = 0
            root.stackSaturated = 0
            root.stackCarborn = 0
            root.stackSugars = 0
            root.stackProtein = 0
            root.nutriscore_grade = "a"
            nutriscorePicker.selectedIndex = 0
            foodTypePicker.selectedIndex = 0
            fatSlider.value = 0
            saturatedSlider.value = 0
            carboSlider.value = 0
            sugarSlider.value = 0
            proteinSlide.value = 0

    }

    Component.onCompleted:{
            if(appSettings.isUserListCreated){
                //pass
            } else{
                UserFoodsListDB.dropTable()
                UserFoodsListDB.createTable()
                appSettings.isUserListCreated = true
            }
            defaultValues()
    }   
}
  


