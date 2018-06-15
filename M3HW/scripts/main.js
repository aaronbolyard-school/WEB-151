var WORDS = [
	"javascript",
	"monkey",
	"amazing",
	"pancake",
	"web",
	"empire",
	"pineapple",
	"pizza",
	"disgusting",
	"handily"
];

var MAX_MISSES = 5;

var word = null;
var letters = {};
var guesses = {};
var hitCount = 0;
var missCount = 0;
var answerBoxes = null;
var isPlaying = true;

function play() {
	word = WORDS[Math.floor(Math.random() * WORDS.length)];

	var hangman = document.getElementById("hangman-image");
	var missAttribute = document.createAttribute("data-miss");
	missAttribute.value = "0";
	hangman.attributes.setNamedItem(missAttribute);

	letters = {};
	guesses = {};
	for (var i = 0; i < word.length; ++i)
	{
		letters[word[i]] = true;
	}

	hitCount = 0;
	missCount = 0;

	answerBoxes = makeAnswerBoxes(word, false);
	isPlaying = true;
}

function makeAnswerBoxes(word, fill) {
	var answerBoxes = [];

	var rootElement = document.getElementById("hangman-guesses");
	while (rootElement.firstChild) {
		rootElement.removeChild(rootElement.firstChild);
	}

	for (var i = 0; i < word.length; ++i) {
		var element = document.createElement("div");
		element.classList.add("hangman-guess");

		if (fill) {
			element.textContent = word[i];
		}
		else {
			element.textContent = "_";
		}

		rootElement.appendChild(element);

		answerBoxes.push(element);
	}

	return answerBoxes;
}

function guess(letter) {
	letter = letter.toLowerCase();

	if (letter in letters) {
		if (!(letter in guesses)) {
			for (var i = 0; i < word.length; ++i) {
				if (word[i] == letter) {
					answerBoxes[i].textContent = letter;
					hitCount += 1;
				}
			}

			guesses[letter] = true;

			if (hitCount == word.length) {
				isPlaying = false;


				setTimeout(function() {
					if (confirm("You won! Play again?")) {
						play();
					}
				}, 0);
			}
		}
	}
	else {
		missCount += 1;
		var hangman = document.getElementById("hangman-image");
		var missAttribute = document.createAttribute("data-miss");
		missAttribute.value = missCount.toString();
		hangman.attributes.setNamedItem(missAttribute);

		if (missCount > MAX_MISSES) {
			makeAnswerBoxes(word, true);

			setTimeout(function() {
				if (confirm("You lost! Play again?")) {
					play();
				}
			}, 0)
		}
	}
}

var button = document.getElementById("hangman-guess-button");
button.onclick = function() {
	if (isPlaying)
	{
		var input = document.getElementById("hangman-letter-input");
		var letter = input.value;
		input.value = "";
		guess(letter);
	}
}

play();
