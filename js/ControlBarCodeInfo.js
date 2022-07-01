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

function getData() {
  var _json = openFoodFactJSON.model.get(0);

  if (typeof _json !== "undefined" && typeof _json.product_name !== "undefined" ) {
      product_name = _json.product_name
      nutriscore_grade = (typeof _json.nutriscore_grade == "undefined") ? "a" :  _json.nutriscore_grade
      energy_kcal_100g = (typeof _json.nutriments.energy_value == "undefined") ? 0 : _json.nutriments.energy_value
      fat_100g = (typeof _json.nutriments.fat_100g == "undefined") ? 0.0 : _json.nutriments.fat_100g
      protein_100g = (typeof _json.nutriments.proteins_100g == "undefined") ? 0.0 : _json.nutriments.proteins_100g
      carbohydrates_100g = (typeof _json.nutriments.carbohydrates_100g == "undefined") ? 0.0 : _json.nutriments.carbohydrates_100g
      next_button.enabled = true
      loading_circle.running = false
      loading_circle.visible = false
  }else{
      loading_circle.running = false
      loading_circle.visible = false
      enter_manually.visible = true
      is_code_empty = true
  }
}