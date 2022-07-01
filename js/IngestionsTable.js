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
  
  function saveIngestion(name,
    nutriscore,
    cal,
    fat,
    carbo,
    protein,
    meal){          
    var db = connectDB();
    var validationMessage = "";
  
    
    db.transaction(function(tx) {
        var rs = tx.executeSql(insert_foods_statement, [1,
          name,
          nutriscore,
          cal,
          fat,
          carbo,
          protein,
          meal,
          root.stringDate]);
        if (rs.rowsAffected > 0) {
          validationMessage = "Ingestion : OK";
        } else {
          validationMessage = "Ingestion : Failed ";
        }
    }
    );
    console.log(validationMessage)
    return validationMessage;
  }

  var remove_all_ingestions = 'DELETE FROM ingestions'

  function deleteAllIngestions(){
   var db = connectDB();
   var rs;
   db.transaction(function(tx) {
     rs = tx.executeSql(remove_all_ingestions);
    }
  );
  return console.log("Ingestions removed from option remove_all_ingestions")
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
 return console.log("Ingestions removed from option today_ingestions")
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
 return console.log("Ingestion removed from by ID")
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
return console.log('auto_clean_removed:' + rs.rowsAffected)
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
 return console.log(rs.rowsAffected)
}