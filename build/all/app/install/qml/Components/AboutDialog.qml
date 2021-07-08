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
import "../js/DataBaseTools.js" as DataBase

Dialog {
       id: aboutApp

        Image{
            source:'../../assets/logo.svg'
            fillMode: Image.PreserveAspectFit
        }
        Label{
            
            anchors.horizontalCenter: aboutApp.horizontalCenter
            
            text: i18n.tr("© KalTracker 2020-2021")
        }

        Label{
            
            anchors.horizontalCenter: aboutApp.horizontalCenter
            
            text: i18n.tr("Version: " + root.appVersion)
        }
        
        Button {
            text: "Back"
            onClicked:{
                PopupUtils.close(aboutApp)
            } 
        }
    

        
}
