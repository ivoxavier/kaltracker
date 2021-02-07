/*
KalTracker DataBase tools
SQLite needs for each transaction a connection to the file
*/
function dataBaseFile() {
    return LocalStorage.openDatabaseSync("kaltracker_db", "0.1", "keepsYourData", 1000000);
}

/*date method's */
var longFormatDate = new Date();
function shortDateFormateOnString(date){
   var dd = (date.getDate() < 10 ? '0' : '') + date.getDate();
   var MM = ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1);
   var yyyy = date.getFullYear();
   return (dd + "-" + MM + "-" + yyyy);
}



 /* Table(s) creation */
function createTables() {
     var db = dataBaseFile();
     try {
     db.transaction(
         function(tx) {
             tx.executeSql('CREATE TABLE IF NOT EXISTS ingestion(\
                 idIngestion INTEGER PRIMARY KEY AUTOINCREMENT,\
                 ingestionType INTEGER,\
                 ingestionDesc TEXT,\
                 date TEXT)');
                 });
         } catch (err) {console.log('Error on table creation: '+ err)}
  }

 /* Insert Values */
function insertIngestion(ingestionType,ingestionDesc){          
      var db = dataBaseFile();
      var validationMessage = "";
      var dateFormatted = shortDateFormateOnString(longFormatDate);
      
      db.transaction(function(tx) {
          var rs = tx.executeSql('INSERT INTO ingestion (\
            ingestionType, ingestionDesc, date)\
            VALUES (?,?,?);', [ingestionType, ingestionDesc, dateFormatted]);
          if (rs.rowsAffected > 0) {
            validationMessage = "Data inserted with success";
          } else {
            validationMessage = "NO DATA inserted: Sorry";
          }
      }
      );
      console.log(validationMessage)
      return validationMessage;
 }

function getAllIngestions(){
     var db = dataBaseFile();
     db.transaction(function (tx) {
                      var results = tx.executeSql('SELECT idIngestion, ingestionType, ingestionDesc, date FROM ingestion')
                      for (var i = 0; i < results.rows.length; i++) { 
                        (function(){
                          var j = i;
                          var rsToQML = results.rows.item(j).idIngestion + ' on: ' + results.rows.item(j).ingestionDesc + ' on: ' + results.rows.item(j).date + '\n';
                          historyText.text += rsToQML;
                        })()
                    }
       
    })
    
}

function deleteAllIngestions(){
      var db = dataBaseFile();
      var rs;
      db.transaction(function(tx) {
        rs = tx.executeSql('DELETE FROM ingestion;');
       }
     );
     return rs.rowsAffected;
}


