/* 

Mifflin-St Jeor equation is believed to give the most accurate result and,
is therefore what I used in this calculator. This BMR formula is as follows:

S = + 5 // for males
S = - 161 // for females
BMR = (10 * weight in kg) + (6.25 * height in cm) – (5 * age) ? S

AF = [VL = 1,3 ; L = 1,5 ; M = 1,6 ; H = 1,9]

EER = BMR * AF
*/


function equation(age, weight, height, sex, activity) {
  var af;
  var bmr;
  
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
      af = 1.3; // Valor padrão para atividade desconhecida
      break;
  }
  
  if (sex === 0) {
    bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
  } else {
    bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
  }
  
  var eer = Math.round(bmr * af);
  return eer;
}

