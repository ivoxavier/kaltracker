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

  var insert_foods_statement = 'INSERT INTO user_foods_list (\
    id_user,\
    name,\
    nutriscore,\
    cal,\
    fat,\
    carbo,\
    protein)\
    VALUES (?,?,?,?,?,?,?)';
  
  function saveIngestion(name,
    nutriscore,
    cal,
    fat,
    carbo,
    protein){          
    var db = connectDB();
    var validationMessage = "";
    
    db.transaction(function(tx) {
        var rs = tx.executeSql(insert_foods_statement, [1,
          name,
          nutriscore,
          cal,
          fat,
          carbo,
          protein]);
        if (rs.rowsAffected > 0) {
          validationMessage = "Ingestion : OK";
        } else {
          validationMessage = "Ingestion : Failed ";
        }
    }
    );
    return validationMessage;
  }


function isUnique(product_name){
  var is_unique_statement = 'SELECT u.id AS id \
  FROM user_foods_list u \
  WHERE u.name == "which_name"'.replace("which_name", product_name);
    var db = connectDB();
    var rsToQML
    db.transaction(function (tx) {
    var results = tx.executeSql(is_unique_statement)
    for (var i = 0; i < results.rows.length; i++) {
      rsToQML = results.rows.item(i).id
    }
   })

   return rsToQML
  }

  const get_all_user_foods = 'SELECT u.id AS id, \
  u.name AS name,\
  u.nutriscore AS nutriscore,\
  u.cal AS cal, \
  u.fat AS fat,\
  u.carbo AS carbo,\
  u.protein AS protein \
  FROM user_foods_list u';
  
  function getFoods(){
    var db = connectDB();
    db.transaction(function (tx) {
      var results = tx.executeSql(get_all_user_foods)
      for (var i = 0; i < results.rows.length; i++) { 
        (function(){
          var j = i;
          user_foods_list_model.append({"id": results.rows.item(j).id,
          "product_name": results.rows.item(j).name,
          "nutriscore_grade" : results.rows.item(j).nutriscore,
          "energy_kcal_100g": results.rows.item(j).cal,
          "fat_100g" : results.rows.item(j).fat,
          "carbohydrates_100g" : results.rows.item(j).carbo,
          "proteins_100g" : results.rows.item(j).protein})
          })()
      }
  }) 
}

function deleteFoods(id){
  var remove_statement = 'DELETE FROM user_foods_list \
  WHERE user_foods_list.id = which_id'.replace("which_id",id)
   var db = connectDB();
   var rs;
   db.transaction(function(tx) {
    rs = tx.executeSql(remove_statement);
   }
 );
}
