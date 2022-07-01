/*
 * 2022  Ivo Fernandes <pg27165@alunos.uminho.pt>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * utFoods is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import Ubuntu.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import Ubuntu.Components.ListItems 1.3 
import Ubuntu.Components.Popups 1.3
import QtQuick.Controls.Suru 2.2
    
UbuntuShape{
    id: slot_shape
    //public API's
    property alias img_url: recipe_img.source

    property bool is_img_loaded : true

    width: units.gu(28)
    height: units.gu(23)
    radius: "large"
    aspect: UbuntuShape.DropShadow
    source: Image{
        id: recipe_img
        source: slot_shape.img_url
        onStatusChanged: if (recipe_img.status == Image.Ready){
            loading_recipe_img_indicator.visible = false
            loading_recipe_img_indicator.running = false
        }  else if (recipe_img.status == Image.Null || recipe_img.status == Image.Error){
            slot_shape.visible = false
        }
    }

        
        ActivityIndicator{
            id: loading_recipe_img_indicator
            
            anchors.centerIn: slot_shape
            visible: true
            running: true
            
        }

        Label{
            text: i18n.tr("Loading recipe image...")
            anchors.top: loading_recipe_img_indicator.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            visible: loading_recipe_img_indicator.visible ? true : false
        }
    MouseArea{
        anchors.fill: parent
        onClicked:{
            if(loading_recipe_img_indicator.running == false){
                page_stack.push(recipe_page)
            }else{
                //pass
            }

        }
    }
}  