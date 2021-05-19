/*
KalTracker DataBase Tools
*/

function createSQLContainer() {
  return LocalStorage.openDatabaseSync("kaltracker_db", "0.2", "keepsYourData", 2000000);
}

/*date method's */
var longFormatDate = new Date();
function shortDateFormateOnString(date){
   var dd = (date.getDate() < 10 ? '0' : '') + date.getDate();
   var MM = ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1);
   var yyyy = date.getFullYear();
   return (yyyy + "-" + MM + "-" + dd);
}


 /* DataWarehouse Start*/

 //dropTablesStatements
const drop_userTableStatement = ' DROP TABLE IF EXISTS User ';
const drop_ingestionTableStatement = ' DROP TABLE IF EXISTS Ingestion ';


const dropTasks = [drop_userTableStatement,drop_ingestionTableStatement];


function dropTables() {
  var db = createSQLContainer();
  console.log("DataBase.dropTables : connected to SQL_CONTAINER");
  try {
    db.transaction(function(tx) {
    for(var i = 0; i < dropTasks.length; i++){
      tx.executeSql(dropTasks[i]);
    } console.log("DataBase.dropTables : OK")});
  } catch (err) {console.log('Error on drop_tables: '+ err)}
}



//createTablesStatements
const create_userTableStatement = 'CREATE TABLE User(\
  idUser	INTEGER PRIMARY KEY,\
  name	TEXT,\
  age INTEGER,\
	sex	TEXT,\
	weight	REAL,\
	height	REAL,\
	activityLevel	TEXT,\
	goal	INTEGER)';

const create_ingestionTableStatement = 'CREATE TABLE Ingestion(\
    idIngestion	INTEGER,\
    idUser	INTEGER,\
    name	TEXT,\
    type	INTEGER,\
    kcal	INTEGER,\
    dte  TEXT, \
    FOREIGN KEY(idUser) REFERENCES User(idUser), \
    PRIMARY KEY(idIngestion))';


const createTasks = [create_userTableStatement, create_ingestionTableStatement];

function createTables() {
  var db = createSQLContainer();
  console.log("DataBase.createTables : connected to SQL_CONTAINER");
  try {
    db.transaction(function(tx) {
      for(var i = 0; i < createTasks.length; i++){
        tx.executeSql(createTasks[i]);
      } console.log("DataBase.createTables : OK")});
   } catch (err) {console.log('Error on table_creation: '+ err)}
}

//*populate Components*//
//resumePage header title
const populateUserName = 'SELECT name FROM User';

function getUserName(){
  var db = createSQLContainer();
  db.transaction(function (tx) {
                   var results = tx.executeSql(populateUserName)
                   for (var i = 0; i < results.rows.length; i++) {
                     (function(){
                       var j = i;
                       var rsToQML = results.rows.item(j).name
                       resumePage.header.title = rsToQML + i18n.tr("'s Dashboard");
                     })()
                    }
 }) 
}

//resumePage Dashboard Goal Label
const populateUserGoal = 'SELECT goal FROM User';

function getUserGoal(){
  var db = createSQLContainer();
  db.transaction(function (tx) {
                   var results = tx.executeSql(populateUserGoal)
                   for (var i = 0; i < results.rows.length; i++) {
                     (function(){
                       var j = i;
                       var rsToQML = results.rows.item(j).goal
                       dashboardUserGoal.text = rsToQML  + "\n" + i18n.tr("Goal");
                      console.log("User Goal IS OK")
                     })()
                    }
 }) 
}

//resumePage Dashboard Foods Daily Ingestion
const populateUserDayKaloriesIngested = 'SELECT SUM(kcal) AS totalKcal \
FROM Ingestion \
WHERE dte == date("now")';

function getUserKaloriesIngestedDuringDay(){
  var db = createSQLContainer();
  
  db.transaction(function (tx) {
                   var results = tx.executeSql(populateUserDayKaloriesIngested)
                   for (var i = 0; i < results.rows.length; i++) {
                     (function(){
                       var j = i;
                       var rsToQML = results.rows.item(j).totalKcal
                       if(rsToQML === null){
                        dashboardUserKaloriesIngestedDuringDay.text = 0  + "\n" + i18n.tr("Foods");
                       } else{
                        dashboardUserKaloriesIngestedDuringDay.text = rsToQML + "\n" + i18n.tr("Foods")
                       }
                     })()
                    }
 })
 
}

//resumePage Dashboard Foods Metric
const populateUserKaloriesIngestionMetric = 'WITH Subtraction AS \
(SELECT (User.goal - SUM(Ingestion.kcal)) AS dif \
FROM Ingestion \
JOIN User ON Ingestion.idUser = User.idUser \
WHERE Ingestion.dte == date("now")) \
SELECT dif FROM Subtraction';

function getUserKaloriesIngestionMetric(){
  var share
  function hackToMetricLabel(){
    var db = createSQLContainer();
    db.transaction(function (tx) {
                   var results = tx.executeSql(populateUserGoal)
                   for (var i = 0; i < results.rows.length; i++) {
                     (function(){
                       var j = i;
                       var rsToQML = results.rows.item(j).goal
                       resumePage.dashboardUserMetric = rsToQML + "\n" + i18n.tr("Remaining");
                       console.log("DailyIngested " + rsToQML)
                     })()
                    }
     })
}
var db = createSQLContainer();
  db.transaction(function (tx) {
                   var results = tx.executeSql(populateUserKaloriesIngestionMetric)
                   for (var i = 0; i < results.rows.length; i++) {
                     (function(){
                        var j = i;
                        var rsToQML = results.rows.item(j).dif
                        if(rsToQML === null){
                          console.log("Query === "+rsToQML+" no ingestions, probably fresh install")
                          hackToMetricLabel()                        
                        }else{
                          dashboardUserKaloriesIngestionMetric.text =  rsToQML  + "\n" + i18n.tr("Remaining");
                        }
                      })()
                    }
                }) 
}


//resumePage log book view
const populateUserDailyLogIngestionFoods = 'SELECT Ingestion.dte AS dte, Ingestion.type AS type,Ingestion.name AS name, Ingestion.kcal AS kcal \
FROM Ingestion \
JOIN User ON Ingestion.idUser = User.idUser \
WHERE Ingestion.dte == date("now")';

function getUserDailyLogIngestionFoods(){
  var db = createSQLContainer();
  db.transaction(function (tx) {
                   var results = tx.executeSql(populateUserDailyLogIngestionFoods)
                   for (var i = 0; i < results.rows.length; i++) { 
                     (function(){
                       var j = i;
                       var rsToQML = results.rows.item(j).dte + ' '+ results.rows.item(j).type + ' ' + results.rows.item(j).name + ' ' + results.rows.item(j).kcal + '\n';
                       //userDailyLogBook.text = " "; 
                       userDailyLogBook.text += rsToQML;
                     })()
                 }
 }) 
}


   /* Data Saving Start */
  //stores the data given by user for userProfile
const saveUserProfile = 'INSERT INTO User (\
  name, age, sex, weight, height, activityLevel, goal)\
  VALUES (?,?,?,?,?,?,?)';

function createUserProfile(userName,userAge,userSex,userWeight,userHeight,userActivityLevel,userGoal){          
  var db = createSQLContainer();
  console.log("DataBase.createUserProfile : connected to SQL_CONTAINER");
  
  db.transaction(function(tx) {
      var results = tx.executeSql(saveUserProfile, [userName,userAge,userSex,userWeight,userHeight,userActivityLevel,userGoal]);
      if (results.rowsAffected > 0) {
        console.log("DataBase.createUserProfile : OK")
      } else {
        console.log("DataBase.createUserProfile : Failed");
      }
  }
  )
}


const saveNewIngestionStatement = 'INSERT INTO Ingestion (\
  idUser, name, type, kcal, dte)\
  VALUES (?,?,?,?,?)';

function saveNewIngestion(name,type,kcal){          
  var db = createSQLContainer();
  console.log("DataBase.saveNewIngestion : connected to SQL_CONTAINER");
  var validationMessage = "";
  var dateFormatted = shortDateFormateOnString(longFormatDate);
  
  db.transaction(function(tx) {
      var rs = tx.executeSql(saveNewIngestionStatement, [1, name, type, kcal, dateFormatted]);
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

  /* Data Loading End */
/* DataWarehouse End*/

 /*delete data from table*/
 function deleteAllIngestions(){
  var db = createSQLContainer();
  var rs;
  db.transaction(function(tx) {
    rs = tx.executeSql('DELETE FROM Ingestion;');
   }
 );
 return rs.rowsAffected;
}