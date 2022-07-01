/* 

Mifflin-St Jeor equation is believed to give the most accurate result and,
is therefore what I used in this calculator. This BMR formula is as follows:

S = + 5 // for males
S = - 161 // for females
BMR = (10 * weight in kg) + (6.25 * height in cm) – (5 * age) ? S

AF = [VL = 1,3 ; L = 1,5 ; M = 1,6 ; H = 1,9]

EER = BMR * AF
*/

function equation(age,weight,height,sex,activity){
    var af
    var bmr_Men
    var bmr_Woman
    var eer
    
    switch (activity) {
        case 0:
            af = 1.3; 
            break;
        case 1:
            af = 1.5;
            break;
        case 2:
            af = 1.6;
            break;
        case 3:
            af = 1.9;
            break;
        default:
            break;
    }
    

    if(sex === 0){
        bmr_Men = (10 * weight) + (6.25 * height) - (5 * age) + 5
        eer = bmr_Men * af
    }
    else {
        bmr_Woman = (10 * weight) + (6.25 * height) - (5 * age) - 161
        eer = bmr_Woman * af
    }
    var roundEER = Math.round(eer)    
    return roundEER
}