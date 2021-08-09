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

var wt = userSettings.userConfigsWeight
var ht = userSettings.userConfigsHeight
var sex = userSettings.userConfigsSex
var ideal_wt

function idealWT(){

    if (sex != 'Men'){
        ideal_wt = (ht-100) * 1.5
    } else{
        ideal_wt = (ht-100) * 0.9
    }
    
    return (Math.round(ideal_wt) * 10) / 10
}

function wtDif(){
    return (wt - idealWT())
}