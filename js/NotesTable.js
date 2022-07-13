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

  var new_note = 'INSERT INTO notes (\
    id_user, note, date)\
    VALUES (?,?,?)';
  
  function saveNote(note){          
    var db = connectDB();
    
    db.transaction(function(tx) {
      var results = tx.executeSql(new_note, [1,
      note,
      root.stringDate]);
      if (results.rowsAffected > 0) {
        console.log("Notes : OK")
      } else {
        console.log("Notes : Failed");
      }
    }
  )
}

var remove_all_notes = 'DELETE FROM notes'

  function deleteAllNotes(){
   var db = connectDB();
   var rs;
   db.transaction(function(tx) {
     rs = tx.executeSql(remove_all_notes);
    }
  );
  return console.log("notes removed from option remove_all_notes")
 }


 function deleteNote(id){
  var remove_statement = 'DELETE FROM notes \
  WHERE notes.id = which_id'.replace("which_id",id)
   var db = connectDB();
   var rs;
   db.transaction(function(tx) {
    rs = tx.executeSql(remove_statement);
   }
 );
 return console.log(rs.rowsAffected)
}