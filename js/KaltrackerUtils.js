/*
 * 2023  Ivo Xavier
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

//calc the blood pressure
function getIndex(ap_hi,ap_lo){
  var blood_pressure_index
  if (ap_hi < 120 && ap_lo < 80){
    //normal
    blood_pressure_index = 0;
}
     
else if (ap_hi >= 120 && ap_hi < 129 && ap_lo < 80){
  //Elevated
  blood_pressure_index = 1;
}

else if(ap_hi >= 130 && ap_hi < 139 || ap_lo >= 80 && ap_lo < 89){
  //High Blood Pressure Stage I
  blood_pressure_index = 2;
}
else if (ap_hi >= 140 || ap_lo >= 90){
  //High Blood Pressure Stage II
  blood_pressure_index = 3
} else {
  //Hypertensive Crisis
  blood_pressure_index =4;
}
return blood_pressure_index
}

function getBmi(height, weight){
    var heigth_on_meters = (height / 100)
    var bmi = Math.round((weight / Math.pow(heigth_on_meters, 2)) * 10) / 10
    return bmi
}


function getIndex(bmi){
   
    var bmi_index = bmi < 18.5 ?
    1 : bmi >= 18.5 && bmi <= 24.9 ?
    2 : bmi === 25 ?
    3 : bmi > 25 && bmi <= 29.9 ?
    4 : 5
    
    return bmi_index
}

function getIdealWeight(sex_at_birth, height) {
  var multiplier = (sex_at_birth > 0) ? 1.5 : 0.9;
  var ideal_wt = (height - 100) * multiplier;
  return Math.round(ideal_wt * 10) / 10;
}


 var weight = app_settings.water_weight_calc
 var liters_to_drink = weight / 30
 var glass_ml = 0.250
 var how_many_water_glass = Math.round((liters_to_drink / glass_ml) * 10 ) / 10

function litersToDrink(){
  return liters_to_drink
}

function howManyWaterGlass(){
  return how_many_water_glass
}
