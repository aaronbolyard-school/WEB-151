var OBJECTS = [
	"app",
	"game",
	"computer",
	"phone",
	"dial-up modem"
];

var PHRASES = [
	"is slower",
	"has more ads",
	"is more unbalanced",
	"has more pay-to-win whales",
	"has less content",
	"is more unoptimized",
	"has more bugs",
	"has fewer features",
	"has 1000% more toxic players"
];

var GAMES = [
	"RuneScape",
	"Candy Crush",
	"Player Unknown Battlegrounds",
	"Fortnite",
	"Flappy Bird",
	"Fruit Ninja",
	"Clash of Clans",
	"Super Smash Bros",
	"Mario Kart",
	"2048",
	"World of Goo",
	"knock-off Android games",
	"any Unity game"
];

function selectRandom(array) {
	return array[Math.floor(Math.random() * array.length)];
}

function getInsultText() {
	var object = selectRandom(OBJECTS);
	var phrase = selectRandom(PHRASES);
	var game = selectRandom(GAMES);

	return "Your" + " " + object + " " + phrase + " " + "than" + " " + game + "!";
}

function makeInsult() {
	document.getElementById("insult-content").textContent = getInsultText();
}

makeInsult();

var button = document.getElementById("insult-button");
button.onclick = function() {
	makeInsult();
}
