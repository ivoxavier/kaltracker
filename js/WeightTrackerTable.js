/*
 * 2022-2023  Ivo Xavier
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


function connectDB() {
  return LocalStorage.openDatabaseSync("kaltracker_db", "0.2", "keepsYourData", 2000000);
}

  var new_weight_tracking = 'INSERT INTO weight_tracker (\
    id_user, weight, date)\
    VALUES (?,?,?)';
  
  function newWeight(weight){          
    var db = connectDB();
    
    db.transaction(function(tx) {
      var results = tx.executeSql(new_weight_tracking, [1,
      weight,
      logical_fields.application.date_utils.long_date]);
      if (results.rowsAffected > 0) {
      } else {
        console.log("Error saving weight");
      }
    }
  )
}

var remove_all_weight_tracker = 'DELETE FROM weight_tracker'

  function deleteAllWeightTracker(){
   var db = connectDB();
   var rs;
   db.transaction(function(tx) {
     rs = tx.executeSql(remove_all_weight_tracker);
    }
  );
 }
