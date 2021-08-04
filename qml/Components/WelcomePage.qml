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
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.0



Page {
    id: welcomePage
    objectName: 'WelcomePage'    
    header: PageHeader {
        title: i18n.tr("KalTracker")

        StyleHints {
            foregroundColor: root.defaultForegroundColor
            backgroundColor: root.defaultBackgroundColor
        }
    }
        
        
            TextEdit {
                id: msg
                
                anchors.centerIn: parent
                
                wrapMode: TextEdit.Wrap
                text: i18n.tr("Thank's for installing KalTracker. It was devolped on my spare time. It calculates your calories based on an equation. You can pick from a list your foods and drinks. I hope it will be usefull for you.\n")
                leftPadding: units.gu(2)
                width: parent.width
                readOnly: true
                font.family: "Ubuntu Mono"
                textFormat: TextEdit.PlainText
                color: theme.palette.normal.fieldText
            }   
        

        
        Button{
            id: clickToConfigButton
            anchors.top: msg.bottom
            
            anchors.horizontalCenter: parent.horizontalCenter
            
            color:"green"
            text: i18n.tr("Click to start")
            onClicked:{
                mainStack.pop()
                mainStack.push(configUserProfilePage)
            }
        }
      
}
