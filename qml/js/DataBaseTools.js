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
    product_name	TEXT,\
    type	INTEGER,\
    energy_kcal_100g	INTEGER,\
    fat_100g	DOUBLE,\
    saturated_fat_100g	DOUBLE,\
    carbohydrates_100g	DOUBLE,\
    sugars_100g	DOUBLE,\
    fiber_100g	DOUBLE,\
    proteins_100g	DOUBLE,\
    salt_100g	DOUBLE,\
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
const populateUserDayKaloriesIngested = 'SELECT SUM(energy_kcal_100g) AS totalKcal \
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
(SELECT (User.goal - SUM(Ingestion.energy_kcal_100g)) AS dif \
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

                        if (rsToQML === null){

                          console.log("Query === "+rsToQML+" no ingestions yet")
                          dashboardUserKaloriesIngestionMetric.text = userSettings.userConfigsGoal + "\n" + i18n.tr("To Be Ingested");                      
                          dashboardUserKaloriesIngestionMetric.color = UbuntuColors.green

                        } else if (rsToQML > 0){

                          dashboardUserKaloriesIngestionMetric.text =  rsToQML  + "\n" + i18n.tr("Left");
                          dashboardUserKaloriesIngestionMetric.color = UbuntuColors.green

                        } else {

                          dashboardUserKaloriesIngestionMetric.text =  Math.abs(rsToQML)  + "\n" + i18n.tr("Exceeded");
                          dashboardUserKaloriesIngestionMetric.color = UbuntuColors.red
                        }

                      })()
                    }
                }) 
}


//resumePage log book view
const populateUserDailyLogIngestionFoods = 'SELECT Ingestion.ingestionDate AS ingestionDate, Ingestion.ingestionTime AS ingestionTime, Ingestion.type AS type,Ingestion.product_name AS name, Ingestion.energy_kcal_100g AS kcal \
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


const allIngestions = 'SELECT Ingestion.ingestionDate AS ingestionDate,Ingestion.ingestionTime AS ingestionTime, Ingestion.type AS type,Ingestion.product_name AS name, Ingestion.energy_kcal_100g AS kcal \
FROM Ingestion \
JOIN User ON Ingestion.idUser = User.idUser'

function getAllIngestions(contextRequest){

  var outputType = contextRequest
  var db = createSQLContainer();
  db.transaction(function (tx) {
                   var results = tx.executeSql(allIngestions)
                   for (var i = 0; i < results.rows.length; i++) { 
                     (function(){
                       var j = i;
                       switch(outputType){

                         case "recordsLog":
                            var rsToQML = results.rows.item(j).ingestionDate + ' '+ results.rows.item(j).ingestionTime + ' ' + results.rows.item(j).name + ' ' + results.rows.item(j).kcal + 'kcal' + '\n'
                            recordsHistory.text += rsToQML
                          break
                          case "exportData":
                            var rsToQML = results.rows.item(j).ingestionDate + ','+ results.rows.item(j).ingestionTime + ',' + results.rows.item(j).type + ',' + results.rows.item(j).name + ',' + results.rows.item(j).kcal + ',';
                            exportData.queryToPy += rsToQML
                          break
                          
                          default:
                            break
                       }
                       
                     })()
                 }
 }) 
}

//statsPage
const populateStatsPage = 'SELECT ROUND(SUM(fat_100g),1) AS fat, ROUND(SUM(saturated_fat_100g),1) AS saturated, ROUND(SUM(carbohydrates_100g),1) AS carbornhydrates, ROUND(SUM(sugars_100g),1) AS sugars, ROUND(SUM(proteins_100g),1) AS protein, ROUND(SUM(fiber_100g),1) AS fiber, ROUND(SUM(salt_100g),1) AS salt \
FROM Ingestion \
JOIN User ON Ingestion.idUser = User.idUser \
WHERE Ingestion.ingestionDate == date("now")'

function getDietary(){
  var db = createSQLContainer();
  db.transaction(function (tx) {
                   var results = tx.executeSql(populateStatsPage)
                   for (var i = 0; i < results.rows.length; i++) { 
                     (function(){
                       var j = i;
                       fatStat.text = i18n.tr("Fat\n") + results.rows.item(j).fat + "g"
                       saturatedStat.text = i18n.tr("Saturated\n") + results.rows.item(j).saturated + "g"
                       carbornhydrates.text = i18n.tr("Carbornhydrates\n") + results.rows.item(j).carbornhydrates + "g"
                       sugarsStat.text = i18n.tr("Sugars\n") + results.rows.item(j).sugars + "g"
                       proteinStat.text = i18n.tr("Protein\n") + results.rows.item(j).protein + "g"
                       fiberStat.text = i18n.tr("Fiber\n") + results.rows.item(j).fiber + "g"
                       saltStat.text = i18n.tr("Salt\n") + results.rows.item(j).salt + "g"
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
  idUser,\
  product_name,\
  type,\
  energy_kcal_100g,\
  fat_100g,\
  saturated_fat_100g,\
  carbohydrates_100g,\
  sugars_100g,\
  fiber_100g,\
  proteins_100g,\
  salt_100g,\
  ingestionDate,\
  ingestionTime)\
  VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)';

function saveNewIngestion(product_name,type,energy_kcal_100g,fat_100g,saturated_fat_100g,carbohydrates_100g,sugars_100g,fiber_100g,proteins_100g,salt_100g){          
  var db = createSQLContainer();
  console.log("DataBase.saveNewIngestion : connected to SQL_CONTAINER");
  var validationMessage = "";
  
  
  db.transaction(function(tx) {
      var rs = tx.executeSql(saveNewIngestionStatement, [1, product_name, type, energy_kcal_100g,fat_100g,saturated_fat_100g,carbohydrates_100g,sugars_100g,fiber_100g,proteins_100g,salt_100g, currentDate, currentTime]);
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

 /*delete all data from table*/
const removeAllIngestions = 'DELETE FROM Ingestion'

 function deleteAllIngestions(){
  var db = createSQLContainer();
  var rs;
  db.transaction(function(tx) {
    rs = tx.executeSql(removeAllIngestions);
   }
 );
 return console.log(rs.rowsAffected)
}

 /*delete current day data from table*/
 const removeTodayIngestions = 'DELETE FROM Ingestion \
 WHERE Ingestion.ingestionDate == date("now")'

 function deleteTodayIngestions(){
  var db = createSQLContainer();
  var rs;
  db.transaction(function(tx) {
    rs = tx.executeSql(removeTodayIngestions);
   }
 );
 return console.log(rs.rowsAffected)
}