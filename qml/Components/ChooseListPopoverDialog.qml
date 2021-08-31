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
import QtQuick.Controls 2.2 as QQC2

Dialog {
       id: setFavoriteListPopoverDialog
       title: i18n.tr("Choose options of list foods to show")

        QQC2.RadioButton{
            id: openFoodsFacts_option
            text: i18n.tr("OpenFoodsFacts list")
            checked: appSettings.isOpenFactsFoodsListChecked
            onClicked: {
                if(appSettings.isOpenFactsFoodsListChecked){
                    appSettings.isUserListFoodsChecked = false
                    appSettings.isBothFoodsListChecked = false
                } else {
                    appSettings.isOpenFactsFoodsListChecked = !appSettings.isOpenFactsFoodsListChecked
                }
            }
        }

        QQC2.RadioButton{
            text: i18n.tr("User foods list")
            checked: appSettings.isUserListFoodsChecked
            onClicked: {
                if(appSettings.isUserListFoodsChecked){
                    appSettings.isOpenFactsFoodsListChecked = false
                    appSettings.isBothFoodsListChecked = false
                }else{
                    appSettings.isUserListFoodsChecked = !appSettings.isUserListFoodsChecked
                }
            }

        }

        QQC2.RadioButton{
            text: i18n.tr("Select which one")
            checked: appSettings.isBothFoodsListChecked
            onClicked:  {
 
                if(appSettings.isBothFoodsListChecked){
                    appSettings.isOpenFactsFoodsListChecked = false
                    appSettings.isUserListFoodsChecked = false
                } else {
                    appSettings.isBothFoodsListChecked = !appSettings.isBothFoodsListChecked
                    appSettings.isOpenFactsFoodsListChecked = false
                    appSettings.isUserListFoodsChecked = false
                }
            }

        }

        Button {
            text: "Back"
            onClicked:{
                PopupUtils.close(setFavoriteListPopoverDialog)
            } 
        }
    

        
}
