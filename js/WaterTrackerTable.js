/*
 * 2022  Ivo Xavier
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

  var new_glass_of_water = 'INSERT INTO water_tracker (\
    id_user, cups, date)\
    VALUES (?,?,?)';
  
  function saveCup(){          
    var db = connectDB();
    
    db.transaction(function(tx) {
      var results = tx.executeSql(new_glass_of_water, [1,
      1,
      root.stringDate]);
      if (results.rowsAffected > 0) {
        console.log("Water: OK")
      } else {
        console.log("Water: Failed");
      }
    }
  )
}

var remove_all_water_tracker = 'DELETE FROM water_tracker'

  function deleteAllWaterTracker(){
   var db = connectDB();
   var rs;
   db.transaction(function(tx) {
     rs = tx.executeSql(remove_all_water_tracker);
    }
  );
  return console.log("water_tracker removed from option remove_all_water_tracker")
 }