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