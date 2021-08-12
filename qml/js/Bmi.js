/*
 * 2021  Ivo Xavier
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

var heigth_on_meters = (root.userHeight / 100)


var bmi = Math.round((root.userWeight / Math.pow(heigth_on_meters, 2)) * 10) / 10

function getBmiIndex(){
   
    var bmi_index = bmi < 18.5 ?
    i18n.tr('Low weigth') : bmi >= 18.5 && bmi <= 24.9 ?
    i18n.tr('Normal weigth') : bmi === 25 ?
    i18n.tr('Weigth exceed') : bmi > 25 && bmi <= 29.9 ?
    i18n.tr('Pre-obesity') : i18n.tr('Obesity')
    
    return bmi_index
}

function getBmi(){
    return bmi
}