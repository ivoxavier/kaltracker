/*
 * 2022  Ivo Fernandes <pg27165@alunos.uminho.pt>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * utFoods is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

function dBbuild(){
  try{
    Storage.dropTables()
    Storage.createTables()
    UserTable.createUserProfile(root.user_age,root.user_sex_at_birth,
    root.user_weight, root.user_height, root.user_activity_level, root.equation_recommended_calories)
    WeightTrackerTable.newWeight(root.user_weight)
    loading_circle.running = !loading_circle.running
    app_settings.water_weight_calc = root.user_weight
    app_settings.rec_cal = root.equation_recommended_calories
    app_settings.using_app_date = root.stringDate
    app_settings.is_clean_install = !app_settings.is_clean_install
}catch (err){} 
}


// Adadpated from
/*https://stackoverflow.com/questions/28507619/how-to-create-delay-function-in-qml*/
function animationState(delayMiliseconds, cb){
  timer.interval = delayMiliseconds;
  timer.triggered.connect(cb);
  timer.start();
}