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


function getIdealWeight(sex_at_birth,height){
    //0 male; 1 female 
    var ideal_wt

    if (sex_at_birth > 0){
        ideal_wt = (height-100) * 1.5
    } else{
        ideal_wt = (height-100) * 0.9
    }
    
    return (Math.round(ideal_wt) * 10) / 10
}

