/* This quotes are free for use
   author: @ivoxavier xD
*/

var quotes = [
'Get your ass on moving!',
'STOP EATING! Enough is enough',
'Do cardio, do cardio!',
'Drink water!',
'Yes, pork is pork!',
'Did you know: saltwater is whale sperm?',
'To change your body, you must first change your mind',
'What you eat in private, eventually, is what your wear in public'
];

function randomQuote(){
    var randomQuote = quotes[Math.floor(Math.random() * quotes.length)];
    var randomQuoteString = randomQuote.toString();
    return randomQuoteString
} 
