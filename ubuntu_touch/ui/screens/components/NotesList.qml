import QtQuick 2.9
import QtQml.Models 2.2      
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import Lomiri.Components.Pickers 1.0
import Lomiri.Components.ListItems 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

ListModel {
    id: notes_list_model

    dynamicRoles: true

    Component.onCompleted: {
       
        notes_list_model.clear();


        var notesData = notesRepository.getNotes(); 

     
        if (notesData) {
            for (var i = 0; i < notesData.length; i++) {
                notes_list_model.append({
                    "id": notesData[i].id,
                    "note": notesData[i].note,
                    "date": notesData[i].date
                });
            }
        }
    }
}