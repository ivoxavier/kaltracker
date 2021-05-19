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


function hasValue(objectProperty1,objectProperty2,objectProperty3){

    var inputProperty1 = objectProperty1
    var inputProperty2 = objectProperty2
    var inputProperty3 = objectProperty3

    var iterateOnInput = [inputProperty1,inputProperty2,inputProperty3]
    var passTest = 0
    var checkState

    for(var i = 0; i < 3; i++){

        if (iterateOnInput[i] === undefined || iterateOnInput[i] <= 0){
            checkState = false
        }
          else if (iterateOnInput[i] !== undefined || iterateOnInput[i] > 0){
              passTest++
          }
          else if (passTest === 3) {
              checkState = true
          }
        

        console.log(checkState)

        return checkState   
    }
}


/*
    Various utility functions for input validation
*/

    /* Check if the provided value is empty. Return true if empty */
    function isEmptyValue(valueToCheck)
    {
        if (valueToCheck.length <= 0 )
           return true
        else
           return false;
    }


