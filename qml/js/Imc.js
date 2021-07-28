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

function getImc(){

    /* 
    WEIGHT in Kg
    HEIGHT in meter

    IMC = WEIGHT / (HEIGHT)^2 
    
    */

    //convert cm into m
    var heigth_on_meters = (userSettings.userConfigsHeight / 100)


    var imc = (userSettings.userConfigsWeight / Math.pow(heigth_on_meters, 2))
    
    var imc_index = imc <= 18.5 ?
    i18n.tr('Low weigth') : imc >= 18.5 && imc <= 24.9 ?
    i18n.tr('Normal weigth') : imc === 25 ?
    i18n.tr('Weigth exceed') : imc > 25 && imc <= 29.9 ?
    i18n.tr('Pre-obesity') : i18n.tr('Obesity')
    
    return imc_index
}