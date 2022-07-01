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


function connectDB() {
  return LocalStorage.openDatabaseSync("utFoods_db", "0.1", "utFoods_data", 2000000);
}

function updateWeight(newWeight){

    var update_weight_statement = 'UPDATE user \
    SET weight = new_weight \
    WHERE user.id == id_login'.replace("new_weight",newWeight).replace("id_login", app_settings.id_login)
  
    var db = connectDB();
    var rs;
    db.transaction(function(tx) {
      rs = tx.executeSql(update_weight_statement);
     }
   );
   return console.log("New weight defined")
  }
  
function updateAge(newAge){
  
    var update_age_statement = 'UPDATE user \
    SET age = newAge \
    WHERE user.id == id_login'.replace("newAge",newAge).replace("id_login", app_settings.id_login)
  
    var db = connectDB();
    var rs;
    db.transaction(function(tx) {
      rs = tx.executeSql(update_age_statement);
     }
   );
   return console.log("New age defined")
  }
  
  
  
  function updateHeight(newHeight){
  
    var update_height_statement = 'UPDATE user \
    SET height = new_height \
    WHERE user.id == id_login'.replace("new_height",newHeight).replace("id_login", app_settings.id_login)
  
    var db = connectDB();
    var rs;
    db.transaction(function(tx) {
      rs = tx.executeSql(update_height_statement);
     }
   );
   return console.log("New height defined")
  }
  
  
  function updateRecCal(newGoal){
  
    var update_goal_statement = 'UPDATE user \
    SET rec_cal = new_goal \
    WHERE user.id == id_login'.replace("new_goal",newGoal).replace("id_login", app_settings.id_login)
  
    var db = connectDB();
    var rs;
    db.transaction(function(tx) {
      rs = tx.executeSql(update_goal_statement);
     }
   );
   return console.log("New goal defined")
  }

  function updateActivity(newActivity){
  
    var update_activity_statement = 'UPDATE user \
    SET activity = new_activity \
    WHERE user.id == id_login'.replace("new_activity",newActivity).replace("id_login", app_settings.id_login)
  
    var db = connectDB();
    var rs;
    db.transaction(function(tx) {
      rs = tx.executeSql(update_activity_statement);
     }
   );
   return console.log("New activity defined")
  }


  function updateApHi(ap_hi){

    var update_ap_hi_statement = 'UPDATE user \
    SET ap_hi = new_aphi \
    WHERE user.id == id_login'.replace("new_aphi",ap_hi).replace("id_login", app_settings.id_login)
  
    var db = connectDB();
    var rs;
    db.transaction(function(tx) {
      rs = tx.executeSql(update_ap_hi_statement);
     }
   );
   return console.log("ap_hi defined")
  }

  function updateApLo(ap_lo){

    var update_ap_lo_statement = 'UPDATE user \
    SET ap_lo = new_aplo \
    WHERE user.id == id_login'.replace("new_aplo",ap_lo).replace("id_login", app_settings.id_login)
  
    var db = connectDB();
    var rs;
    db.transaction(function(tx) {
      rs = tx.executeSql(update_ap_lo_statement);
     }
   );
   return console.log("ap_lo defined")
  }