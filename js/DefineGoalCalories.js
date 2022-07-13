/*

Considering 1kg of adipose tissue has a stock energy of 7700 calories
see: https://emais.estadao.com.br/blogs/vigilante-da-causa-magra/quer-perder-peso-nutricionista-explica-media-de-reducao-de-calorias-por-dia/

*/

var adipose_tissue_1kg = 7700;


function periodOne(){
    var daily_ref = adipose_tissue_1kg * 0.5
    var how_many_calories = daily_ref / 7
    return how_many_calories
}

function periodTwo(){
    var daily_ref = adipose_tissue_1kg * 1.0
    var how_many_calories = daily_ref / 7
    return how_many_calories
}

function periodThree(){
    var daily_ref = adipose_tissue_1kg * 3.0
    var how_many_calories = daily_ref / 30
    return how_many_calories
}

function periodFour(){
    var daily_ref = adipose_tissue_1kg * 4.0
    var how_many_calories = daily_ref / 30
    return how_many_calories
}