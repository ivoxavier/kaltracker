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

/* KalTracker DataBase Tools */

function connectDB() {
  return LocalStorage.openDatabaseSync("kaltracker_db", "0.2", "keepsYourData", 2000000);
}

var db = connectDB();

function getTotalCalConsumed() {
    var total_cal_consumed = `SELECT SUM(i.cal) AS totalcal 
    FROM ingestions i 
    WHERE i.date == ?`;
    
    db.transaction(function(tx) {
        var results = tx.executeSql(total_cal_consumed, [logical_fields.application.date_utils.long_date]);

        if (results.rows.length > 0) {
            var rsToQML = results.rows.item(0).totalcal;
            logical_fields.user_profile.plan.cal_consumed = rsToQML || 0;
        } else {
            logical_fields.user_profile.plan.cal_consumed = 0;
        }
    });
}


function getTotalCalRemaining() {
  var total_cal_remaining = `WITH dif AS ( 
      SELECT (u.rec_cal - SUM(i.cal)) AS remaining 
      FROM ingestions i, user u 
      WHERE i.id_user = u.id AND
      i.date = ? 
  ) 
  SELECT remaining FROM dif`;

  db.transaction(function(tx) {
      var results = tx.executeSql(total_cal_remaining, [logical_fields.application.date_utils.long_date]);

      if (results.rows.length > 0) {
          var rsToQML = results.rows.item(0).remaining;
          logical_fields.user_profile.plan.cal_remaining = rsToQML || app_settings.rec_cal;
      } else {
          logical_fields.user_profile.plan.cal_remaining = app_settings.rec_cal;
      }
  });
}


function getTotalFoodsConsumed() {
  var total_foods_consumed = `SELECT COUNT(i.id) AS totalFoods
      FROM ingestions i
      WHERE i.date = ?`;

  db.transaction(function(tx) {
      var results = tx.executeSql(total_foods_consumed, [logical_fields.application.date_utils.long_date]);

      if (results.rows.length > 0) {
          var rsToQML = results.rows.item(0).totalFoods;
          logical_fields.metrics.total_foods_consumed = rsToQML || 0;
      } else {
          logical_fields.metrics.total_foods_consumed = 0;
      }
  });
}

function getBreakfastCalories() {
    var total_cal_consumed_breakfast = `SELECT SUM(i.cal) AS totalcal
        FROM ingestions i
        WHERE i.date = ? AND i.meal = 0`;

    db.transaction(function(tx) {
        var results = tx.executeSql(total_cal_consumed_breakfast, [logical_fields.application.date_utils.long_date]);

        if (results.rows.length > 0) {
            var rsToQML = results.rows.item(0).totalcal;
            logical_fields.metrics.total_cal_breakfast = rsToQML || 0;
        } else {
            logical_fields.metrics.total_cal_breakfast = 0;
        }
    });
}


function getYesterdayBreakfast() {
  filtered_meal_model.clear();
  var yesterday_breakfast = `SELECT id, name, nutriscore, cal, fat, carbo, protein
      FROM ingestions
      WHERE date = ? AND meal = 0`;

  db.transaction(function(tx) {
      var results = tx.executeSql(yesterday_breakfast, [bottom_edge.yesterday_formated_date]);

      for (var i = 0; i < results.rows.length; i++) {
          var item = results.rows.item(i);
          filtered_meal_model.append({
              "id": item.id,
              "name": item.name,
              "nutriscore": item.nutriscore,
              "cal": item.cal,
              "fat": item.fat,
              "carbo": item.carbo,
              "protein": item.protein
          });
      }
  });
}
  

function getLunchCalories() {
    var total_cal_consumed_lunch = `SELECT SUM(i.cal) AS totalcal
      FROM ingestions i
      WHERE i.date = ? AND i.meal = 1`;

    var tx = db.transaction(function(tx) {
      var results = tx.executeSql(total_cal_consumed_lunch, [logical_fields.application.date_utils.long_date]);
      var totalCalLunch = 0;
      for (var i = 0; i < results.rows.length; i++) {
        totalCalLunch = results.rows.item(i).totalcal;
      }
      logical_fields.metrics.total_cal_lunch = totalCalLunch || 0;
    });
  }
  

  function getYesterdayLunch() {
    filtered_meal_model.clear()
    var yesterday_lunch = `SELECT id, name, nutriscore, cal, fat, carbo, protein
      FROM ingestions
      WHERE date = ? AND meal = 1`;
  
    db.transaction(function (tx) {
      var results = tx.executeSql(yesterday_lunch, [bottom_edge.yesterday_formated_date]);
      for (var i = 0; i < results.rows.length; i++) {
        var item = results.rows.item(i);
        filtered_meal_model.append({
          "id" : item.id,
          "name" : item.name,
          "nutriscore" : item.nutriscore,
          "cal" : item.cal,
          "fat" : item.fat,
          "carbo" : item.carbo,
          "protein" : item.protein
        });
      }
    });
  }
  


function getDinnerCalories() {
  var total_cal_consumed_dinner = `SELECT SUM(i.cal) AS totalcal 
    FROM ingestions i
    WHERE i.date = ? AND i.meal = 2`;

  var tx = db.transaction(function(tx) {
    var results = tx.executeSql(total_cal_consumed_dinner, [logical_fields.application.date_utils.long_date]);
    var totalCalDinner = 0;
    for (var i = 0; i < results.rows.length; i++) {
      totalCalDinner = results.rows.item(i).totalcal;
    }
    logical_fields.metrics.total_cal_dinner = totalCalDinner || 0;
  });
}
  

function getYesterdayDinner() {
  filtered_meal_model.clear();

  var yesterday_dinner = `SELECT id, name, nutriscore, cal, fat, carbo, protein
    FROM ingestions
    WHERE date = ? AND meal = 2`;

  db.transaction(function (tx) {
    var results = tx.executeSql(yesterday_dinner, [bottom_edge.yesterday_formated_date]);
    for (var i = 0; i < results.rows.length; i++) {
      var item = results.rows.item(i);
      filtered_meal_model.append({
        "id": item.id,
        "name": item.name,
        "nutriscore": item.nutriscore,
        "cal": item.cal,
        "fat": item.fat,
        "carbo": item.carbo,
        "protein": item.protein
      });
    }
  });
}



function getSnacksCalories() {
  var total_cal_consumed_snacks = `SELECT SUM(i.cal) AS totalcal
    FROM ingestions i 
    WHERE i.date = ? AND i.meal = 3`;

  var tx = db.transaction(function(tx) {
    var results = tx.executeSql(total_cal_consumed_snacks, [logical_fields.application.date_utils.long_date]);
    var totalCalSnacks = 0;
    for (var i = 0; i < results.rows.length; i++) {
      totalCalSnacks = results.rows.item(i).totalcal;
    }
    logical_fields.metrics.total_cal_snacks = totalCalSnacks || 0;
  });
}
  

function getYesterdaySnacks() {
  filtered_meal_model.clear();

  var yesterday_snacks = `SELECT id, name, nutriscore, cal, fat, carbo, protein
    FROM ingestions
    WHERE date = ? AND meal = 3`;

  db.transaction(function (tx) {
    var results = tx.executeSql(yesterday_snacks, [bottom_edge.yesterday_formated_date]);
    for (var i = 0; i < results.rows.length; i++) {
      var item = results.rows.item(i);
      filtered_meal_model.append({
        "id": item.id,
        "name": item.name,
        "nutriscore": item.nutriscore,
        "cal": item.cal,
        "fat": item.fat,
        "carbo": item.carbo,
        "protein": item.protein
      });
    }
  });
}


function getCups() {
  var water_cups = `SELECT COUNT(cups) AS cups 
    FROM water_tracker 
    WHERE date = ?`;
  
  var tx = db.transaction(function(tx) {
    var results = tx.executeSql(water_cups, [logical_fields.application.date_utils.long_date]);
    var totalWaterCups = 0;
    for (var i = 0; i < results.rows.length; i++) {
      totalWaterCups = results.rows.item(i).cups;
    }
    logical_fields.metrics.total_water_cups = totalWaterCups || 0;
  });
}


function getTodayIngestions() {
  var today_ingestions = `SELECT i.id AS id, i.date AS date, i.name AS name, i.cal AS cal
  FROM ingestions i 
  WHERE i.date = ?`;

  db.transaction(function (tx) {
    var results = tx.executeSql(today_ingestions, [date("now")]);
    for (var i = 0; i < results.rows.length; i++) {
      var item = results.rows.item(i);
      all_today_ingestions.append({
        "id": item.id,
        "cal": item.cal,
        "name": item.name,
        "date": item.date
      });
    }
  });
}


function getCarboConsumed() {
  var total_carbo_consumed = `SELECT SUM(i.carbo) as carbo 
    FROM ingestions i, user u 
    WHERE i.id_user = u.id AND
    i.date = ?`;
    
  var tx = db.transaction(function(tx) {
    var results = tx.executeSql(total_carbo_consumed, [logical_fields.application.date_utils.long_date]);
    var totalCarboConsumed = results.rows.item(0).carbo || 0;
    logical_fields.metrics.total_carbo_consumed = totalCarboConsumed;
  });
}


function getFatConsumed() {
  var total_fat_consumed = `SELECT SUM(i.fat) as fat
    FROM ingestions i, user u 
    WHERE i.id_user = u.id AND
    i.date = ?`;

  var tx = db.transaction(function(tx) {
    var results = tx.executeSql(total_fat_consumed, [logical_fields.application.date_utils.long_date]);
    var totalFatConsumed = results.rows.item(0).fat || 0;
    logical_fields.metrics.total_fat_consumed = totalFatConsumed;
  });
}


function getProteinConsumed() {
  var total_protein_consumed = `SELECT SUM(i.protein) as protein
    FROM ingestions i, user u 
    WHERE i.id_user = u.id AND
    i.date = ?`;

  var tx = db.transaction(function(tx) {
    var results = tx.executeSql(total_protein_consumed, [logical_fields.application.date_utils.long_date]);
    var totalProteinConsumed = results.rows.item(0).protein || 0;
    logical_fields.metrics.total_protein_consumed = totalProteinConsumed;
  });
}


function getAverageCalories() {
  var average_calories_month = `SELECT strftime("%m", i.date) AS month, AVG(i.cal) AS average
    FROM ingestions i
    WHERE strftime("%Y", i.date) = ?
    GROUP BY month
    ORDER BY month DESC`;

  var tx = db.transaction(function(tx) {
    var currentYear = new Date().getFullYear().toString();
    var results = tx.executeSql(average_calories_month, [currentYear]);
    for (var i = 0; i < results.rows.length; i++) {
      var item = results.rows.item(i);
      avg_month_calories.append({
        "month": item.month,
        "average": item.average
      });
    }
  });
}


function getAllFoodsMonth(month_requested) {
  var month_ingestions = `SELECT i.date AS date, i.name AS name, i.cal AS cal
    FROM ingestions i
    WHERE strftime("%m", date) = ?`;

  var tx = db.transaction(function(tx) {
    var results = tx.executeSql(month_ingestions, [month_requested]);
    for (var i = 0; i < results.rows.length; i++) {
      var item = results.rows.item(i);
      all_month_ingestions.append({
        "date": item.date,
        "name": item.name,
        "cal": item.cal
      });
    }
  });
}


function getNotes() {
  var all_notes = 'SELECT id, note, date FROM notes ORDER BY id DESC';

  db.transaction(function (tx) {
    var results = tx.executeSql(all_notes);
    for (var i = 0; i < results.rows.length; i++) {
      var item = results.rows.item(i);
      notes_list_model.append({
        "id": item.id,
        "note": item.note,
        "date": item.date
      });
    }
  });
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
    fillColor : app_style.chart.line.weight.fillColor,
    strokeColor : app_style.chart.line.weight.strokeColor,
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
      fillColor : app_style.chart.bar.nutriscore.fillColor,
      strokeColor : app_style.chart.bar.nutriscore.strokeColor,
      pointColor : "rgba(220,220,220,1)",
      pointStrokeColor : "#90ee90",
      pointHighlightFill : "#90ee90",
      pointHighlightStroke : "rgba(144,238,144,0.2)",
      data : getYNutriscore()
  }]
  }
  return ChartBarData;
  }
