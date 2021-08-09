'''
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
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 '''




def moduleState():
    return 'Python Module Imported'


def getAdvice(bmi_QML,ideal_wt_QML,current_weight_QML):
    rate_awareness_level = 0
    weight_dif = current_weight_QML - ideal_wt_QML

    if ((bmi_QML >= 18.5 and bmi_QML <= 24.9) and weight_dif < 10):
        rate_awareness_level = 0
    elif (bmi_QML < 18.5 and weight_dif <= 10):
        rate_awareness_level = 1
    elif (bmi_QML == 25 and (weight_dif > 10 and weight_dif <= 19)):
         rate_awareness_level = 2
    elif ((bmi_QML > 25 and bmi_QML <= 29.9) and weight_dif > 30 and weight_dif <= 39):
         rate_awareness_level = 3
    else:
         rate_awareness_level = 4


    return rate_awareness_level