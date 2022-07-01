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


function connectDB() {
  return LocalStorage.openDatabaseSync("kaltracker_db", "0.2", "keepsYourData", 2000000);
}

//statement for saving data into user table
  var save_user_profile = 'INSERT INTO user (\
    id,age, sex_at_birth, weight, height, activity, rec_cal)\
    VALUES (?,?,?,?,?,?,?)';

//function to execute the statement
  function createUserProfile(age,
    sex_at_birth,
    weight,
    height,
    activity,
    rec_cal){          
    var db = connectDB();
    
    db.transaction(function(tx) {
      var results = tx.executeSql(save_user_profile, [1,
        age,
        sex_at_birth,
        weight,
        height,
        activity,
        rec_cal]);
      if (results.rowsAffected > 0) {
        console.log("Data stored")
      } else {
        console.log("error");
      }
    }
  )
}

var user_sex = 'SELECT u.sex_at_birth AS sex_at_birth \
  FROM user u';
  
function getSexAtBirth(){
    var db = connectDB();
    var rsToQML
    db.transaction(function (tx) {
      var results = tx.executeSql(user_sex)
      for (var i = 0; i < results.rows.length; i++) {
        rsToQML = results.rows.item(i).sex_at_birth
      }
   })
   return rsToQML
}

var user_age = 'SELECT u.age AS age \
  FROM user u';
  
  function getAge(){
    var db = connectDB();
    var rsToQML
    db.transaction(function (tx) {
      var results = tx.executeSql(user_age)
      for (var i = 0; i < results.rows.length; i++) {
        rsToQML = results.rows.item(i).age
      }
})
   return rsToQML
}

var user_goal = 'SELECT u.rec_cal AS rec_cal \
FROM user u';

function getGoal(){
  var db = connectDB();
  var rsToQML
  db.transaction(function (tx) {
    var results = tx.executeSql(user_goal)
    for (var i = 0; i < results.rows.length; i++) {
      rsToQML = results.rows.item(i).rec_cal
    }
 })
 return rsToQML
}

var weight = 'SELECT u.weight AS weight \
FROM user u';

function getWeight(){
  var db = connectDB();
  var rsToQML
  db.transaction(function (tx) {
    var results = tx.executeSql(weight)
    for (var i = 0; i < results.rows.length; i++) {
      rsToQML = results.rows.item(i).weight
    }
 })
 return rsToQML
}

var height = 'SELECT u.height AS height \
FROM user u';

function getHeight(){
  var db = connectDB();
  var rsToQML
  db.transaction(function (tx) {
    var results = tx.executeSql(height)
    for (var i = 0; i < results.rows.length; i++) {
      rsToQML = results.rows.item(i).height
    }
 })
 return rsToQML
}

var user_activity = 'SELECT u.activity AS activity \
FROM user u';

function getActivity(){
  var db = connectDB();
  var rsToQML
  db.transaction(function (tx) {
    var results = tx.executeSql(user_activity)
    for (var i = 0; i < results.rows.length; i++) {
      rsToQML = results.rows.item(i).activity
    }
 })
 return rsToQML
}


var user_ap_hi = 'SELECT u.ap_hi AS ap_hi \
  FROM user u';
  
  function getApHi(){
    var db = connectDB();
    var rsToQML
    db.transaction(function (tx) {
      var results = tx.executeSql(user_ap_hi)
      for (var i = 0; i < results.rows.length; i++) {
        rsToQML = results.rows.item(i).ap_hi
      }
})
   return rsToQML
}

var user_ap_lo = 'SELECT u.ap_lo AS ap_lo \
  FROM user u';
  
  function getApLo(){
    var db = connectDB();
    var rsToQML
    db.transaction(function (tx) {
      var results = tx.executeSql(user_ap_lo)
      for (var i = 0; i < results.rows.length; i++) {
        rsToQML = results.rows.item(i).ap_lo
      }
})
   return rsToQML
}