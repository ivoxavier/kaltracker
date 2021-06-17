/* KalTracker DataBase Tools */

function createSQLContainer() {
  return LocalStorage.openDatabaseSync("kaltracker_db", "0.2", "keepsYourData", 2000000);
}

/*date and time*/
var longDate = new Date();
var localCountry = Qt.locale()
var currentDate = longDate.toLocaleString(localCountry, 'yyyy-MM-dd')
var currentTime = longDate.toLocaleString(localCountry, 'hh:mm')

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
    ingestionDate  TEXT, \
    ingestionTime  TEXT, \
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

//resumePage Dashboard Foods Daily Ingestion
const populateUserDayKaloriesIngested = 'SELECT SUM(kcal) AS totalKcal \
FROM Ingestion \
WHERE ingestionDate == date("now")';

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
WHERE Ingestion.ingestionDate == date("now")) \
SELECT dif FROM Subtraction';

function getUserKaloriesIngestionMetric(){
var db = createSQLContainer();
  db.transaction(function (tx) {
                   var results = tx.executeSql(populateUserKaloriesIngestionMetric)
                   for (var i = 0; i < results.rows.length; i++) {
                     (function(){
                        var j = i;
                        var rsToQML = results.rows.item(j).dif
                        if(rsToQML === null){
                          console.log("Query === "+rsToQML+" no ingestions yet")
                          dashboardUserKaloriesIngestionMetric.text = userSettings.userConfigsGoal + "\n" + i18n.tr("To Be Ingested");                      
                        }else{
                          dashboardUserKaloriesIngestionMetric.text =  rsToQML  + "\n" + i18n.tr("Left");
                        }
                      })()
                    }
                }) 
}


//resumePage log book view
const populateUserDailyLogIngestionFoods = 'SELECT Ingestion.ingestionDate AS ingestionDate, Ingestion.ingestionTime AS ingestionTime, Ingestion.type AS type,Ingestion.name AS name, Ingestion.kcal AS kcal \
FROM Ingestion \
JOIN User ON Ingestion.idUser = User.idUser \
WHERE Ingestion.ingestionDate == date("now")';

function getUserDailyLogIngestionFoods(){
  var db = createSQLContainer();
  db.transaction(function (tx) {
                   var results = tx.executeSql(populateUserDailyLogIngestionFoods)
                   for (var i = 0; i < results.rows.length; i++) { 
                     (function(){
                       var j = i;
                       dailyIngestions.append({"kcal": results.rows.item(j).kcal, "name": results.rows.item(j).name, "ingestionDate": results.rows.item(j).ingestionDate, "ingestionTime": results.rows.item(j).ingestionTime})
                     })()
                 }
 }) 
}


const allIngestions = 'SELECT Ingestion.dte AS dte, Ingestion.type AS type,Ingestion.name AS name, Ingestion.kcal AS kcal \
FROM Ingestion \
JOIN User ON Ingestion.idUser = User.idUser'

function getAllIngestions(){
  var db = createSQLContainer();
  db.transaction(function (tx) {
                   var results = tx.executeSql(allIngestions)
                   for (var i = 0; i < results.rows.length; i++) { 
                     (function(){
                       var j = i;
                       var rsToQML = results.rows.item(j).dte + ','+ results.rows.item(j).type + ',' + results.rows.item(j).name + ',' + results.rows.item(j).kcal + ',';
                       exportData.queryToPy += rsToQML
                     })()
                 }
 }) 
}



//statsPage
const populateStatsPageByFoodsType = 'SELECT COUNT(*) AS total, Ingestion.type AS type \
FROM Ingestion \
JOIN User ON Ingestion.idUser = User.idUser \
GROUP BY Ingestion.type'

function getFoodsType(){
  var db = createSQLContainer();
  db.transaction(function (tx) {
                   var results = tx.executeSql(populateStatsPageByFoodsType)
                   for (var i = 0; i < results.rows.length; i++) { 
                     (function(){
                       var j = i;
                       foodsCategory.append({"total": results.rows.item(j).total, "type": results.rows.item(j).type })
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
  idUser, name, type, kcal, ingestionDate, ingestionTime)\
  VALUES (?,?,?,?,?,?)';

function saveNewIngestion(name,type,kcal){          
  var db = createSQLContainer();
  console.log("DataBase.saveNewIngestion : connected to SQL_CONTAINER");
  var validationMessage = "";
  
  
  db.transaction(function(tx) {
      var rs = tx.executeSql(saveNewIngestionStatement, [1, name, type, kcal, currentDate, currentTime]);
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