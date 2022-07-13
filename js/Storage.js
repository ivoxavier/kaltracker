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

function connectDB() {
  return LocalStorage.openDatabaseSync("kaltracker_db", "0.2", "keepsYourData", 2000000);
}

/*date and time*/
var long_date = new Date();
var local_country = Qt.locale()
var current_date = long_date.toLocaleString(local_country, 'yyyy-MM-dd')
var current_time = long_date.toLocaleString(local_country, 'hh:mm')


/*cleans tables before writting new ones --start--*/
var drop_user_table_statement = ' DROP TABLE IF EXISTS user ';
var drop_ingestions_table_statement = ' DROP TABLE IF EXISTS ingestions ';
var drop_user_foods_list_table_statement = ' DROP TABLE IF EXISTS user_foods_list ';
var drop_weight_tracker_table_statement = ' DROP TABLE IF EXISTS weight_tracker ';
var drop_water_tracker_table_statement = ' DROP TABLE IF EXISTS water_tracker ';
var drop_notes_table_statement = ' DROP TABLE IF EXISTS notes ';
/*cleans tables before writting new ones --end--*/

//stores the statetments in an array 
var drop_tasks = [
  drop_user_table_statement,
  drop_ingestions_table_statement,
  drop_user_foods_list_table_statement,
  drop_weight_tracker_table_statement,
  drop_water_tracker_table_statement,
  drop_notes_table_statement];

//execute all the statements stored in the array
function dropTables() {
  var db = connectDB();

  try {

    db.transaction(function(tx) {

    for(var i = 0; i < drop_tasks.length; i++){

      tx.executeSql(drop_tasks[i]);

    } console.log("Storage: dropped Tables")});

  } catch (err) {console.log('Error on drop_tables: '+ err)}
}


/*create tables --start--*/
var create_user_table_statement = 'CREATE TABLE user(\
  id	INTEGER PRIMARY KEY,\
  age INTEGER,\
	sex_at_birth	INTEGER,\
	weight	DOUBLE,\
	height	INTEGER,\
	activity	INTEGER,\
	rec_cal	INTEGER,\
  ap_lo INTEGER, \
  ap_hi INTEGER)';

var create_ingestions_table_statement = 'CREATE TABLE ingestions(\
  id	INTEGER,\
  id_user	INTEGER,\
  name	TEXT,\
  nutriscore	TEXT,\
  cal	INTEGER,\
  fat	DOUBLE,\
  carbo	DOUBLE,\
  protein	DOUBLE,\
  date  TEXT, \
  meal  INTEGER, \
  FOREIGN KEY(id_user) REFERENCES user(id), \
  PRIMARY KEY(id))';

var create_user_foods_list_table_statement = 'CREATE TABLE user_foods_list(\
  id	INTEGER,\
  id_user	INTEGER,\
  name	TEXT,\
  nutriscore	TEXT,\
  cal	INTEGER,\
  fat	DOUBLE,\
  carbo	DOUBLE,\
  protein	DOUBLE,\
  FOREIGN KEY(id_user) REFERENCES user(id), \
  PRIMARY KEY(id))';

var create_weight_tracker_table_statement = 'CREATE TABLE weight_tracker(\
  id	INTEGER,\
  id_user	INTEGER,\
  weight	DOUBLE,\
  date	TEXT,\
  FOREIGN KEY(id_user) REFERENCES user(id), \
  PRIMARY KEY(id))';

var create_water_tracker_table_statement = 'CREATE TABLE water_tracker(\
  id	INTEGER,\
  id_user	INTEGER,\
  cups	INTEGER,\
  date	TEXT,\
  FOREIGN KEY(id_user) REFERENCES user(id), \
  PRIMARY KEY(id))';

var create_notes_table_statement = 'CREATE TABLE notes(\
  id	INTEGER,\
  id_user	INTEGER,\
  note	TEXT,\
  date	TEXT,\
  FOREIGN KEY(id_user) REFERENCES user(id), \
  PRIMARY KEY(id))';

/*create tables --end--*/

//stores the statetments in an array 
var create_tasks = [
  create_user_table_statement, 
  create_ingestions_table_statement,
  create_user_foods_list_table_statement,
  create_weight_tracker_table_statement,
  create_water_tracker_table_statement,
  create_notes_table_statement];

//execute all the statements stored in the array
function createTables() {
  var db = connectDB();
  
  try {
    db.transaction(function(tx) {

      for (var i = 0; i < create_tasks.length; i++){

        tx.executeSql(create_tasks[i]);

      } console.log("Storage: Tables Created")});
   } catch (err) {console.log('Error on table_creation: '+ err)}
}