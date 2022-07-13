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