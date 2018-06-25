// Write your functions here
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

// Picks a random word from the WORDS array.
//
// Returns the word, as a string.
function pickWord() {
	return WORDS[Math.floor(Math.random() * WORDS.length)];
}

// Creates an answer array the same size as the provided word.
//
// Returns the answer array, as an array of underscore characters.
function setupAnswerArray(word) {
	var result = [];
	for (var i = 0; i < word.length; ++i) {
		result.push("_");
	}
	return result;
}

// Alerts the user, providing the current answer (an answer array).
//
// See setupAnswerArray for the format of 'answer'.
function showPlayerProgress(answer) {
	alert(answer.join(" "));
}

// Prompts the user for a guess.
//
// Returns the input, or null if the user canceled.
function getGuess() {
	return prompt("Guess a letter, or click Cancel to stop.");
}

// Updates the game state.
//
// If the user entered a correct guess that has yet to be encountered,
// returns the number of occurences of the letter. This also results in the
// letters being updated in the answer array.
function updateGameState(guess, word, answer) {
	guess = guess.toLowerCase();

	var count = 0;
	for (var i = 0; i < word.length; ++i) {
		if (word[i] === guess && answer[i] === "_") {
			answer[i] = guess;
			++count;
		}
	}

	return count;
}

function showAnswerAndCongratulatePlayer(answer) {
	var word = answer.join("");
	showPlayerProgress(answer);
	alert("Good job! The answer was " + word);
}

function play() {
	var word = pickWord();
	var answerArray = setupAnswerArray(word);
	var remainingLetters = word.length;
	while (remainingLetters > 0) {
		showPlayerProgress(answerArray);
		var guess = getGuess();
		if (guess === null) {
			break;
		}
		else if (guess.length !== 1) {
			alert("Please enter a single letter.");
		}
		else {
			var correctGuesses = updateGameState(guess, word, answerArray);
			remainingLetters -= correctGuesses;
		}
	}
	showAnswerAndCongratulatePlayer(answerArray);
}
