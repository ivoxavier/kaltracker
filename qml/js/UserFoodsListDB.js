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

/* KalTracker DataBase Tools */

function dbConnection() {
  return LocalStorage.openDatabaseSync("userFoodsList_db", "0.1", "ownList", 2000000);
}

const drop_userFoodsTable_statement = 'DROP TABLE IF EXISTS Foods';

const create_userFoodsTable_statement = 'CREATE TABLE Foods(\
  idFoods	INTEGER PRIMARY KEY,\
  product_name	TEXT,\
  nutriscore_grade	TEXT,\
  type	TEXT,\
  energy_kcal_100g	INTEGER,\
  fat_100g	DOUBLE,\
  saturated_fat_100g	DOUBLE,\
  carbohydrates_100g	DOUBLE,\
  sugars_100g	DOUBLE,\
  proteins_100g	DOUBLE)';

function dropTable() {
  var db = dbConnection();
  console.log("UserFoodsListDB.dropTable : connected to SQL_CONTAINER");

  try {

    db.transaction(function(tx) {

      tx.executeSql(drop_userFoodsTable_statement);

     console.log("UserFoodsListDB.dropTable : OK")});

  } catch (err) {console.log('Error on drop_tables: '+ err)}
}

function createTable() {
  var db = dbConnection();
  console.log("UserFoodsListDB.createTable : connected to SQL_CONTAINER");

  try {

    db.transaction(function(tx) {

      tx.executeSql(create_userFoodsTable_statement);

     console.log("UserFoodsListDB.createTable : OK")});

  } catch (err) {console.log('Error on drop_tables: '+ err)}
}



const saveUserListFoods_statement = 'INSERT INTO foods (\
  product_name,\
  nutriscore_grade,\
  type,\
  energy_kcal_100g,\
  fat_100g,\
  saturated_fat_100g,\
  carbohydrates_100g,\
  sugars_100g,\
  proteins_100g)\
  VALUES (?,?,?,?,?,?,?,?,?)';

function saveUserListFoods(product_name,
  nutriscore_grade,
  type,
  energy_kcal_100g,
  fat_100g,
  saturated_fat_100g,
  carbohydrates_100g,
  sugars_100g,
  proteins_100g){          
  var db = dbConnection();
  console.log("DataBase.saveNewIngestion : connected to SQL_CONTAINER");
  var validationMessage = "";
  
  
  db.transaction(function(tx) {
      var rs = tx.executeSql(saveUserListFoods_statement, [product_name,
        nutriscore_grade,
        type,
        energy_kcal_100g,
        fat_100g,
        saturated_fat_100g,
        carbohydrates_100g,
        sugars_100g,
        proteins_100g]);
      if (rs.rowsAffected > 0) {
        validationMessage = "DataBase.saveNewIngestion : OK";
      } else {
        validationMessage = "DataBase.saveNewIngestion : Failed ";
      }
  }
  );
  console.log(validationMessage)
  return validationMessage;
}









const allFoods = 'SELECT F.idFoods AS idFoods, \
F.product_name AS name,\
F.nutriscore_grade AS score_grade,\
F.type AS type,\
F.energy_kcal_100g AS kcal, \
F.fat_100g AS fat,\
F.saturated_fat_100g AS saturated,\
F.carbohydrates_100g AS carbo,\
F.sugars_100g AS sugars,\
F.proteins_100g AS proteins \
FROM Foods F';

function getListFoods(){
  var db = dbConnection();
  db.transaction(function (tx) {
                   var results = tx.executeSql(allFoods)
                   for (var i = 0; i < results.rows.length; i++) { 
                     (function(){

                       var j = i;

                       userFoodsDrinks.append({"idFoods": results.rows.item(j).idFoods,
                       "product_name": results.rows.item(j).name,
                       "kcal": results.rows.item(j).kcal,
                       "score_grade" : results.rows.item(j).score_grade,
                       "type" : results.rows.item(j).type,
                       "kcal" : results.rows.item(j).kcal,
                       "fat" : results.rows.item(j).fat,
                       "saturated" : results.rows.item(j).saturated,
                       "carbo" : results.rows.item(j).carbo,
                       "sugars" : results.rows.item(j).sugars,
                       "proteins" : results.rows.item(j).proteins})
                      })()

                      
                 }
 }) 
}


function deleteEntry(id){
  var removeStatement = 'DELETE FROM Foods \
  WHERE Foods.idFoods = which_id'.replace("which_id",id)
   var db = dbConnection();
   var rs;
   db.transaction(function(tx) {
    rs = tx.executeSql(removeStatement);
   }
 );
 return console.log(rs.rowsAffected)
}