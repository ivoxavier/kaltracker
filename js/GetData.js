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

/* utFoods DataBase Tools */

function connectDB() {
  return LocalStorage.openDatabaseSync("kaltracker_db", "0.2", "keepsYourData", 2000000);
}

// assign to homepage property the amount of calories ingested
function getTotalCalConsumed(){
    var total_cal_consumed = 'SELECT SUM(i.cal) AS totalcal \
    FROM ingestions i \
    WHERE i.date == "which_date"'.replace("which_date", root.stringDate);
      var db = connectDB();
      var rsToQML 
      db.transaction(function (tx) {
        var results = tx.executeSql(total_cal_consumed)
        for (var i = 0; i < results.rows.length; i++) {
          rsToQML = results.rows.item(i).totalcal                 
          if(rsToQML == 0 || rsToQML == null){
              home_page.query_total_cal_consumed = 0
          } else{
            home_page.query_total_cal_consumed = rsToQML
          }
    
        }
     })
}

//assign to homepage property the calories left
function getTotalCalRemaining(){
  var total_cal_remaining = 'WITH dif AS (SELECT (user.rec_cal - SUM(i.cal)) AS remaining \
  FROM ingestions i \
  JOIN user ON i.id_user = user.id \
  WHERE i.date == "which_date") \
  SELECT remaining FROM dif'.replace("which_date",root.stringDate);
  var db = connectDB();
  db.transaction(function (tx) {
    var results = tx.executeSql(total_cal_remaining)
    for (var i = 0; i < results.rows.length; i++) {
      var rsToQML = results.rows.item(i).remaining
      if (rsToQML === null || rsToQML === 0 ){
        home_page.query_total_cal_remaining = app_settings.rec_cal
      } else {
        home_page.query_total_cal_remaining =  rsToQML
      }
    }
  }) 
}

//assign to homepage property the amount foods ingested
function getTotalFoodsConsumed(){
  var total_foods_consumed = 'SELECT COUNT(i.id) AS totalFoods \
  FROM ingestions i \
  WHERE i.date == "which_date"'.replace("which_date", root.stringDate);
    var db = connectDB();
    var rsToQML 
    db.transaction(function (tx) {
      var results = tx.executeSql(total_foods_consumed)
      for (var i = 0; i < results.rows.length; i++) {
        rsToQML = results.rows.item(i).totalFoods                
        if(rsToQML == 0 || rsToQML == null){
            home_page.query_total_foods_consumed = 0
        } else{
          home_page.query_total_foods_consumed = rsToQML
        }
      }
   })
}

//assign to homepage property the amount calories ingested in breakfast
function getBreakfastCalories(){
  var total_cal_consumed_breakfast = 'SELECT SUM(i.cal) AS totalcal \
  FROM ingestions i \
  WHERE i.date == "which_date" AND i.meal = 0'.replace("which_date", root.stringDate);
  var db = connectDB();
  var rsToQML        
  db.transaction(function (tx) {
    var results = tx.executeSql(total_cal_consumed_breakfast)
    for (var i = 0; i < results.rows.length; i++) {
      rsToQML = results.rows.item(i).totalcal                             
      if(rsToQML == 0 || rsToQML == null){
        home_page.query_total_cal_breakfast = 0
      } else{
        home_page.query_total_cal_breakfast = rsToQML
      }
    }
  })
  }

  function getYesterdayBreakfast(){
    filtered_meal_model.clear()
    var yesterday_breakfast = 'SELECT id AS id, name AS name, nutriscore AS nutriscore, cal AS cal, fat AS fat, carbo AS carbo, protein AS protein \
    FROM ingestions i \
    WHERE i.date == "which_date" AND i.meal = 0'.replace("which_date", bottom_edge.yesterday_formated_date);
    var db = connectDB();  
    db.transaction(function (tx) {
      var results = tx.executeSql(yesterday_breakfast)
      for (var i = 0; i < results.rows.length; i++) {
        filtered_meal_model.append({
          "id" : results.rows.item(i).id,
          "name" : results.rows.item(i).name,
          "nutriscore" : results.rows.item(i).nutriscore,
          "cal" : results.rows.item(i).cal,
          "fat" : results.rows.item(i).fat,
          "carbo" : results.rows.item(i).carbo,
          "protein" : results.rows.item(i).protein
        })
      }
    })
    }

  //assign to homepage property the amount calories ingested in lunch
  function getLunchCalories(){
    var total_cal_consumed_lunch = 'SELECT SUM(i.cal) AS totalcal \
    FROM ingestions i \
    WHERE i.date == "which_date" AND i.meal = 1'.replace("which_date", root.stringDate);
    var db = connectDB();
    var rsToQML          
    db.transaction(function (tx) {
      var results = tx.executeSql(total_cal_consumed_lunch)
      for (var i = 0; i < results.rows.length; i++) {
        rsToQML = results.rows.item(i).totalcal                              
        if(rsToQML == 0 || rsToQML == null){
          home_page.query_total_cal_lunch = 0
        } else{
          home_page.query_total_cal_lunch = rsToQML
        }
      }
    })
  }

  function getYesterdayLunch(){
    filtered_meal_model.clear()
    var yesterday_lunch = 'SELECT id AS id, name AS name, nutriscore AS nutriscore, cal AS cal, fat AS fat, carbo AS carbo, protein AS protein \
    FROM ingestions i \
    WHERE i.date == "which_date" AND i.meal = 1'.replace("which_date", bottom_edge.yesterday_formated_date);
    var db = connectDB();  
    db.transaction(function (tx) {
      var results = tx.executeSql(yesterday_lunch)
      for (var i = 0; i < results.rows.length; i++) {
        filtered_meal_model.append({
          "id" : results.rows.item(i).id,
          "name" : results.rows.item(i).name,
          "nutriscore" : results.rows.item(i).nutriscore,
          "cal" : results.rows.item(i).cal,
          "fat" : results.rows.item(i).fat,
          "carbo" : results.rows.item(i).carbo,
          "protein" : results.rows.item(i).protein
        })
      }
    })
    }

  //assign to homepage property the amount calories ingested in dinner
  function getDinnerCalories(){
    var total_cal_consumed_dinner = 'SELECT SUM(i.cal) AS totalcal \
    FROM ingestions i \
    WHERE i.date == "which_date" AND i.meal = 2'.replace("which_date", root.stringDate);
    var db = connectDB();
    var rsToQML
    db.transaction(function (tx) {
      var results = tx.executeSql(total_cal_consumed_dinner)
      for (var i = 0; i < results.rows.length; i++) {
        rsToQML = results.rows.item(i).totalcal
        if(rsToQML == 0 ||  rsToQML == null){
          home_page.query_total_cal_dinner = 0
        } else{
          home_page.query_total_cal_dinner = rsToQML
        }
      }
  })
  }

  function getYesterdayDinner(){
    filtered_meal_model.clear()
    var yesterday_dinner = 'SELECT id AS id, name AS name, nutriscore AS nutriscore, cal AS cal, fat AS fat, carbo AS carbo, protein AS protein \
    FROM ingestions i \
    WHERE i.date == "which_date" AND i.meal = 2'.replace("which_date", bottom_edge.yesterday_formated_date);
    var db = connectDB();  
    db.transaction(function (tx) {
      var results = tx.executeSql(yesterday_dinner)
      for (var i = 0; i < results.rows.length; i++) {
        filtered_meal_model.append({
          "id" : results.rows.item(i).id,
          "name" : results.rows.item(i).name,
          "nutriscore" : results.rows.item(i).nutriscore,
          "cal" : results.rows.item(i).cal,
          "fat" : results.rows.item(i).fat,
          "carbo" : results.rows.item(i).carbo,
          "protein" : results.rows.item(i).protein
        })
      }
    })
    }

  //assign to homepage property the amount calories ingested in snacks
  function getSnacksCalories(){
    var total_cal_consumed_snacks = 'SELECT SUM(i.cal) AS totalcal \
    FROM ingestions i \
    WHERE i.date == "which_date" AND i.meal = 3'.replace("which_date", root.stringDate);
    var db = connectDB();
    var rsToQML
    db.transaction(function (tx) {
      var results = tx.executeSql(total_cal_consumed_snacks)
      for (var i = 0; i < results.rows.length; i++) {
        rsToQML = results.rows.item(i).totalcal
        if(rsToQML == 0 || rsToQML == null){
          home_page.query_total_cal_snacks = 0
        } else{
          home_page.query_total_cal_snacks = rsToQML
        }
      }
  })
  }

  function getYesterdaySnacks(){
    filtered_meal_model.clear()
    var yesterday_snacks = 'SELECT id AS id, name AS name, nutriscore AS nutriscore, cal AS cal, fat AS fat, carbo AS carbo, protein AS protein \
    FROM ingestions i \
    WHERE i.date == "which_date" AND i.meal = 3'.replace("which_date", bottom_edge.yesterday_formated_date);
    var db = connectDB();  
    db.transaction(function (tx) {
      var results = tx.executeSql(yesterday_snacks)
      for (var i = 0; i < results.rows.length; i++) {
        filtered_meal_model.append({
          "id" : results.rows.item(i).id,
          "name" : results.rows.item(i).name,
          "nutriscore" : results.rows.item(i).nutriscore,
          "cal" : results.rows.item(i).cal,
          "fat" : results.rows.item(i).fat,
          "carbo" : results.rows.item(i).carbo,
          "protein" : results.rows.item(i).protein
        })
      }
    })
    }

  //get cups
  function getCups(){
    var water_cups = 'SELECT COUNT(cups) AS cups \
    FROM water_tracker \
    WHERE date == "which_date"'.replace("which_date", root.stringDate);
    var db = connectDB();
    var rsToQML
    db.transaction(function (tx) {
      var results = tx.executeSql(water_cups)
      for (var i = 0; i < results.rows.length; i++) {
        rsToQML = results.rows.item(i).cups
        if(rsToQML == 0 || rsToQML == null ){
          home_page.query_total_water_cups = 0
        } else{
          home_page.query_total_water_cups = rsToQML
        }
        
      }
})
}

  var today_ingestions = 'SELECT i.id AS id, \
  i.date AS date, \
  i.name AS name, \
  i.cal AS cal \
  FROM ingestions i \
  WHERE i.date == date("now")';
  
  function getTodayIngestions(){
    var db = connectDB();
    db.transaction(function (tx) {
      var results = tx.executeSql(today_ingestions)
      for (var i = 0; i < results.rows.length; i++) { 
        (function(){
          var j = i;
          all_today_ingestions.append({"id": results.rows.item(j).id,"cal": results.rows.item(j).cal, "name": results.rows.item(j).name, "date": results.rows.item(j).date})
        })()
      }
   }) 
  }

function getCarboConsumed(){
    var total_carbo_consumed = 'SELECT SUM(carbo) as carbo \
    FROM ingestions i \
    JOIN user ON i.id_user = user.id \
    WHERE i.date == "which_date"'.replace("which_date",root.stringDate);
    var db = connectDB();
    db.transaction(function (tx) {
      var results = tx.executeSql(total_carbo_consumed)
      for (var i = 0; i < results.rows.length; i++) {
        var rsToQML = results.rows.item(i).carbo
        if (rsToQML === null || rsToQML == 0.0){
          home_page.query_total_carbo_consumed = 0
        } else {
        home_page.query_total_carbo_consumed = rsToQML
        }
      }
    }) 
  }

  function getFatConsumed(){
    var total_fat_consumed = 'SELECT SUM(fat) as fat \
    FROM ingestions i \
    JOIN user ON i.id_user = user.id \
    WHERE i.date == "which_date"'.replace("which_date",root.stringDate);
    var db = connectDB();
    db.transaction(function (tx) {
      var results = tx.executeSql(total_fat_consumed)
      for (var i = 0; i < results.rows.length; i++) {
        var rsToQML = results.rows.item(i).fat
        if (rsToQML === null || rsToQML == 0.0){
          home_page.query_total_fat_consumed = 0
        } else {
        home_page.query_total_fat_consumed = rsToQML
        }
      }
    }) 
  }

  function getProteinConsumed(){
    var total_protein_consumed = 'SELECT SUM(protein) as protein \
    FROM ingestions i \
    JOIN user ON i.id_user = user.id \
    WHERE i.date == "which_date"'.replace("which_date",root.stringDate);
    var db = connectDB();
    db.transaction(function (tx) {
      var results = tx.executeSql(total_protein_consumed)
      for (var i = 0; i < results.rows.length; i++) {
        var rsToQML = results.rows.item(i).protein
        if (rsToQML === null || rsToQML == 0.0){
          home_page.query_total_protein_consumed = 0
        } else {
        home_page.query_total_protein_consumed = rsToQML
        }
      }
    }) 
  }

  var average_calories_month = 'SELECT strftime("%m", i.date) AS month,\
AVG(i.cal) AS average \
FROM ingestions i \
WHERE strftime("%Y", i.date) == strftime("%Y", date()) \
GROUP BY month \
ORDER BY month DESC'


function getAverageCalories(){
  var db = connectDB();
  db.transaction(function (tx) {
    var results = tx.executeSql(average_calories_month)
    for (var i = 0; i < results.rows.length; i++) { 
      (function(){
        var j = i;
        avg_month_calories.append({"month": results.rows.item(j).month, "average": results.rows.item(j).average})
      })()
    }
 }) 
}

function getAllFoodsMonth(month_requested){
  
  var month_ingestions = 'SELECT i.date AS date,\
  i.name AS name,\
  i.cal AS cal \
  FROM ingestions i \
  WHERE strftime("%m", date) == "which_month"'.replace("which_month", month_requested)
    
    var db = connectDB();
    db.transaction(function (tx) {
      var results = tx.executeSql(month_ingestions)
      for (var i = 0; i < results.rows.length; i++) { 
        (function(){
          var j = i;
          all_month_ingestions.append({"date": results.rows.item(j).date,"name": results.rows.item(j).name, "cal": results.rows.item(j).cal})
        })()
      }
   }) 
  }

  function getNotes(){

    var all_notes = 'SELECT id AS id,note AS note, date AS date \
    FROM notes \
    ORDER BY id DESC'
  
    var db = connectDB();
    var rsToQML
  
    db.transaction(function (tx) {
      var results = tx.executeSql(all_notes)
      for (var i = 0; i < results.rows.length; i++) {
        notes_list_model.append({
          "id": results.rows.item(i).id,
          "note": results.rows.item(i).note,
          "date": results.rows.item(i).date})
      }
  })
   //return rsToQML
  }

  /*Charts*/

  /*Axis: for Weight Tracker  --start--*/

function getYWeightTracker(date_from, date_to){
  var get_y_weight_table = 'SELECT weight FROM weight_tracker wt \
  WHERE date(wt.date) <= date("which_date_to") AND date(wt.date) >= date("which_date_from") \
  ORDER BY wt.date ASC'.replace("which_date_to", date_to).replace("which_date_from", date_from)
  var db = connectDB();
  var rs = "";
  db.transaction(function(tx) {
    rs = tx.executeSql(get_y_weight_table);
  });
  
  var weight_values = [];
  for(var i =0;i < rs.rows.length;i++) {
    weight_values.push(rs.rows.item(i).weight);
  }
  
  return weight_values;
}


  /*X axis: measurement dates*/
function getXWeightTracker(date_from, date_to){
  var get_x_weight_table = 'SELECT date FROM weight_tracker wt \
  WHERE date(wt.date) <= date("which_date_to") AND date(wt.date) >= date("which_date_from") \
  ORDER BY wt.date ASC'.replace("which_date_to", date_to).replace("which_date_from", date_from)
  var db = connectDB();
  
  var rs = "";
  db.transaction(function(tx) {
    rs = tx.executeSql(get_x_weight_table);
  });

  /* build the array */
  var date_registered = [];
  for(var i =0;i < rs.rows.length;i++) {
    date_registered.push(rs.rows.item(i).date);
  }
return date_registered;
}
/* Axis: for Weight Tracker  --end--*/

//populate chartLine
function getChartLineData(date_from, date_to){  

var ChartLineData = {
  labels: getXWeightTracker(date_from, date_to),
datasets: [{
    fillColor : graphs_page.theme_applied === 0 ? "rgba(119,33,11,0.2)"  : "rgba(144,238,144,0.2)",
    strokeColor : graphs_page.theme_applied === 0 ? "rgba(119,33,11,1)"  : "rgba(144,238,144,1)",
    pointColor : "rgba(220,220,220,1)",
    pointStrokeColor : "#fff",
    pointHighlightFill : "#90ee90",
    pointHighlightStroke : "rgba(220,220,220,1)",
    data : getYWeightTracker(date_from, date_to)
}]
}
return ChartLineData;
}

 /*Axis: for Weight Tracker  --start--*/

 function getYNutriscore(){
  var get_y_nutriscores_values = 'SELECT COUNT(nutriscore) AS nutriscore \
   FROM ingestions \
   GROUP BY nutriscore \
   ORDER BY 1 ASC'
  var db = connectDB();
  var rs = "";
  db.transaction(function(tx) {
    rs = tx.executeSql(get_y_nutriscores_values);
  });
  
  var nutriscore_count = [];
  for(var i =0;i < rs.rows.length;i++) {
    nutriscore_count.push(rs.rows.item(i).nutriscore);
  }
  return nutriscore_count;
}

/* Axis: for Weight Tracker  --end--*/

function getChartBarData(){  

  var ChartBarData = {
    labels: ["a","b","c","d","e"],
  datasets: [{
      fillColor : graphs_page.theme_applied === 0 ? "rgba(119,33,11,0.2)"  : "rgba(144,238,144,0.2)",
      strokeColor : graphs_page.theme_applied === 0 ? "rgba(119,33,11,1)"  : "rgba(144,238,144,1)",
      pointColor : "rgba(220,220,220,1)",
      pointStrokeColor : "#90ee90",
      pointHighlightFill : "#90ee90",
      pointHighlightStroke : "rgba(144,238,144,0.2)",
      data : getYNutriscore()
  }]
  }
  return ChartBarData;
  }