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

function generalAnalysis(awareness_level){ 
switch(awareness_level){
    case 0:
        advice_text.text = i18n.tr("Your awareness level is 0. This means your current weight is under 10kg difference from your ideal weight. And your BMI is in between 18.5 and 24.9.")
        break
    case 1:
        advice_text.text = i18n.tr("Your awareness level is 1. This means your current weight is low and has a difference until 10kg from your ideal weight.")
        break
    case 2:
        advice_text.text = i18n.tr("Your awareness level is 2. This means you have excess of weight and a differenc in between 10 to 19kg from your ideal weight.")
        break
    case 3:
        advice_text.text = i18n.tr("Your awareness level is 3. This means you are in a situation of pre-obesity and you should consider professional help.")
        break
    case 4:
        advice_text.text = i18n.tr("Your awareness level is 4. Our highst value, please visit a medic.")
        break
    default:
        break
}

}