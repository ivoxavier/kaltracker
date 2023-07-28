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

  var insert_foods_statement = 'INSERT INTO ingestions (\
    id_user,\
    name,\
    nutriscore,\
    cal,\
    fat,\
    carbo,\
    protein,\
    meal,\
    date)\
    VALUES (?,?,?,?,?,?,?,?,?)';
  
  function saveIngestion(name,nutriscore,cal,fat,carbo,protein,meal) {      
      var db = connectDB();

      //In multiSelection case an object is passed rather than single arguments
      if(typeof name === 'object' && name !== null) {
        for(var i in name){
          db.transaction(function(tx) {
            tx.executeSql(insert_foods_statement, [1,
              name[i].product_name,name[i].nutriscore_grade,name[i].energy_kcal_100g,name[i].fat_100g,name[i].carbohydrates_100g,name[i].proteins_100g,
              logical_fields.ingestion.meal_type,logical_fields.application.date_utils.long_date]);
          }
        );

        }

      } else {
        // for single arguments 
        db.transaction(function(tx) {
          tx.executeSql(insert_foods_statement, [1,
            name,nutriscore,cal,fat,carbo,protein,meal,
            logical_fields.application.date_utils.long_date]);
        }
      );
      }
  }

  var remove_all_ingestions = 'DELETE FROM ingestions'

  function deleteAllIngestions(){
   var db = connectDB();
   var rs;
   db.transaction(function(tx) {
     rs = tx.executeSql(remove_all_ingestions);
    }
  );
 }

 var remove_today_ingestions = 'DELETE FROM ingestions \
 WHERE ingestions.date == date("now")'

 function deleteTodayIngestions(){
  var db = connectDB();
  var rs;
  db.transaction(function(tx) {
    rs = tx.executeSql(remove_today_ingestions);
   }
 );
}

function deleteMonthYearIngestion(month, year){
  var statement = 'DELETE FROM ingestions \
  WHERE strftime("%m", date) == "which_month" AND strftime("%Y", date) == "which_year"'.replace("which_month", month).replace("which_year", year)
  var db = connectDB();
  var rs;
   db.transaction(function(tx) {
    rs = tx.executeSql(statement);
   }
 );
 return console.log("Ingestions removed from option month_year")
}

function deleteIngestion(id){
  var statement = 'DELETE FROM ingestions \
  WHERE id == "which_id"'.replace("which_id", id)
  var db = connectDB();
  var rs;
   db.transaction(function(tx) {
    rs = tx.executeSql(statement);
   }
 );
}


var check_old_ingestions = 'SELECT COUNT(*) AS oldest \
FROM ingestions \
WHERE ingestions.date < strftime("%Y", date())'

function checkOldest(){
  var db = connectDB();
  var rsToQML;
  db.transaction(function(tx) {
   var results = tx.executeSql(check_old_ingestions);
    for (var i = 0; i < results.rows.length; i++) {
      rsToQML = results.rows.item(i).oldest
    }
   }
 );
 return rsToQML
 }

var auto_clean = 'DELETE FROM ingestions \
WHERE ingestions.date < strftime("%Y", date())'

function autoClean(){
 var db = connectDB();
 var rs;
 db.transaction(function(tx) {
   rs = tx.executeSql(auto_clean);
  }
);
}


function deleteSpecificTodayIngestion(id){
  var remove_today_speficic_ingestion = 'DELETE FROM ingestions \
  WHERE ingestions.id = which_id'.replace("which_id",id)
   var db = connectDB();
   var rs;
   db.transaction(function(tx) {
    rs = tx.executeSql(remove_today_speficic_ingestion);
   }
 );
}
