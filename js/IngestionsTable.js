/*
 * 2022-2026  Ivo Xavier 
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

var insert_foods_statement = 'INSERT INTO ingestions (\
    id_user,\
    name,\
    nutriscore,\
    cal,\
    fat,\
    carbo,\
    protein,\
    meal,\
    date)\
    VALUES (?,?,?,?,?,?,?,?,?)';

function saveIngestion(name, nutriscore, cal, fat, carbo, protein, meal) {
    ctrl_smph.setSemaphore(streams_smph, "user_event");
    var db = connectDB();

    db.transaction(function(tx) {
      
        if (typeof name === 'object' && name !== null) {
            for (var i in name) {
                tx.executeSql(insert_foods_statement, [
                    1,
                    name[i].product_name,
                    name[i].nutriscore_grade,
                    name[i].energy_kcal_100g,
                    name[i].fat_100g,
                    name[i].carbohydrates_100g,
                    name[i].proteins_100g,
                    logical_fields.ingestion.meal_type,
                    logical_fields.application.date_utils.long_date
                ]);
            }
        } else {
          
            tx.executeSql(insert_foods_statement, [
                1,
                name,
                nutriscore,
                cal,
                fat,
                carbo,
                protein,
                meal,
                logical_fields.application.date_utils.long_date
            ]);
        }
    });

    ctrl_smph.defaultSemaphore(streams_smph);
}

var remove_all_ingestions = 'DELETE FROM ingestions';

function deleteAllIngestions() {
    ctrl_smph.setSemaphore(streams_smph, "user_event");
    var db = connectDB();
    db.transaction(function(tx) {
        tx.executeSql(remove_all_ingestions);
    });
    ctrl_smph.defaultSemaphore(streams_smph);
}

var remove_today_ingestions = "DELETE FROM ingestions WHERE ingestions.date = date('now')";

function deleteTodayIngestions() {
    ctrl_smph.setSemaphore(streams_smph, "user_event");
    var db = connectDB();
    db.transaction(function(tx) {
        tx.executeSql(remove_today_ingestions);
    });
    ctrl_smph.defaultSemaphore(streams_smph);
}

function deleteMonthYearIngestion(month, year) {
    ctrl_smph.setSemaphore(streams_smph, "user_event");
    var statement = "DELETE FROM ingestions WHERE strftime('%m', date) = ? AND strftime('%Y', date) = ?";
    var db = connectDB();
    db.transaction(function(tx) {
        tx.executeSql(statement, [String(month), String(year)]);
    });
    ctrl_smph.defaultSemaphore(streams_smph);
    console.log("Ingestions removed from option month_year");
}

function deleteIngestion(id) {
    ctrl_smph.setSemaphore(streams_smph, "user_event");
    var statement = "DELETE FROM ingestions WHERE id = ?";
    var db = connectDB();
    db.transaction(function(tx) {
        tx.executeSql(statement, [id]);
    });
    ctrl_smph.defaultSemaphore(streams_smph);
}

var check_old_ingestions = "SELECT COUNT(*) AS oldest FROM ingestions WHERE ingestions.date < strftime('%Y', date('now'))";

function checkOldest() {
    var db = connectDB();
    var rsToQML = 0;
    db.transaction(function(tx) {
        var results = tx.executeSql(check_old_ingestions);
        if (results.rows.length > 0) {
            rsToQML = results.rows.item(0).oldest;
        }
    });
    return rsToQML;
}

var auto_clean = "DELETE FROM ingestions WHERE ingestions.date < strftime('%Y', date('now'))";

function autoClean() {
    ctrl_smph.setSemaphore(streams_smph, "user_event");
    var db = connectDB();
    db.transaction(function(tx) {
        tx.executeSql(auto_clean);
    });
    ctrl_smph.defaultSemaphore(streams_smph);
}

function deleteSpecificTodayIngestion(id) {
    ctrl_smph.setSemaphore(streams_smph, "user_event");
    var remove_today_specific_ingestion = "DELETE FROM ingestions WHERE ingestions.id = ?";
    var db = connectDB();
    db.transaction(function(tx) {
        tx.executeSql(remove_today_specific_ingestion, [id]);
    });
    ctrl_smph.defaultSemaphore(streams_smph);
}