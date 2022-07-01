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