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

function getTimeUsage(){
    var shutdown = new Date()
    var shutdown_hours = shutdown.getHours()
    var shutdown_minutes = shutdown.getMinutes()
    var shutdown_seconds = shutdown.getSeconds()

    var hours = shutdown_hours - root.boot_hours
    var minutes = shutdown_minutes - root.boot_minutes
    var seconds = shutdown_seconds - root.boot_seconds

    var amount_time_spent = (seconds + (minutes * 60) + (hours * 60 * 60))
    
    if(amount_time_spent < 60){
        return amount_time_spent

    } else{
        var min = (parseInt(amount_time_spent / 60))
        var sec = (amount_time_spent % 60)
        var min_sec = `${min}${":"}${sec}`
        return min_sec
    }   
}
