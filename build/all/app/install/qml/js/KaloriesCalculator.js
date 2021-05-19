/* 

Mifflin-St Jeor equation is believed to give the most accurate result and,
is therefore what I used in this calculator. This BMR formula is as follows:

S = + 5 // for males
S = - 161 // for females
BMR = (10 * weight in kg) + (6.25 * height in cm) – (5 * age) ? S

AF = [VL = 1,3 ; L = 1,5 ; M = 1,6 ; H = 1,9]

EER = BMR * AF
*/

function mifflinStJeorEquation(age,weight,height,sex,activity){
    var inputAge = age;
    var inputWeight = weight;
    var inputHeight = height;
    var inputSex = sex;
    var inputActivity = activity;
    var af
    var bmrMen = (10 * inputWeight) + (6.25 * inputHeight) - (5 * inputAge) + 5
    var bmrWoman = (10 * inputWeight) + (6.25 * inputHeight) - (5 * inputAge) - 161
    var eer
    
    switch (inputActivity) {
        case 0:
            var af = 1.3; 
            break;
        case 1:
            var af = 1.5;
            break;
        case 2:
            var af = 1.6;
            break;
        case 3:
            var af = 1.9;
            break;
        default:
            break;
    }
    

    if(inputSex === 0){
        var bmrMen = (10 * inputWeight) + (6.25 * inputHeight) - (5 * inputAge) + 5
        var eer = bmrMen * af
    }
    else {
        var bmrWoman = (10 * inputWeight) + (6.25 * inputHeight) - (5 * inputAge) - 161
        var eer = bmrWoman * af
    }
    
    var roundEER = Math.round(eer)
    
    console.log("Real: " + eer)
    console.log("Rounded: " + roundEER)
    
    return roundEER

}