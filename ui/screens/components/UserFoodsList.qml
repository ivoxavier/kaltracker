import QtQuick 2.9

ListModel {
    id: user_foods_list_model

    
    function loadFoods() {
        user_foods_list_model.clear();
        
        var myFoods = ingestionRepository.getUserFoods();

        
        if (!myFoods) {
            return;
        }

        // Popula a lista
        for (var i = 0; i < myFoods.length; i++) {
            user_foods_list_model.append(myFoods[i]);
        }
    }

    Component.onCompleted: {
     
        loadFoods();
        
   
        root.initDB.connect(loadFoods);
    }
    
    
    Component.onDestruction: {
        root.initDB.disconnect(loadFoods);
    }
}