clear();
pendown();

// Some useful constants.
var CIRCLE         = 360;
var HALF_CIRCLE    = 180;
var QUARTER_CIRCLE = 90;
var BYTE_CIRCLE    = 45;   // Since there's 8 bits in a byte.
var NIBBLE_CIRCLE  = 22.5; // Since a 2^4 (4 bits in a nibble) == 16.

function moveTo(x, y) {
	home();
	penup();
	fd(y);
	rt(90);
	fd(x);
	lt(90);
	pendown();
}

function drawA() {
	var SIDE_LENGTH = 100;
	var SPAN_LENGTH = 30;

	// Draw left and right side
	rt(NIBBLE_CIRCLE);
	fd(SIDE_LENGTH);
	rt(QUARTER_CIRCLE + BYTE_CIRCLE);
	fd(SIDE_LENGTH);

	// Draw inner span
	bk(60);
	rt(NIBBLE_CIRCLE + QUARTER_CIRCLE);
	fd(SPAN_LENGTH);
}

function drawB() {
	var SIDE_LENGTH = 100;
	var SEGMENTS = 16;

	// Draw left side
	fd(SIDE_LENGTH);

	// Top span
	rt(90);
	fd(SIDE_LENGTH / 4);

	function drawCurve() {
		// The diameter of a side curve is 1/4 of the length.
		// Thus the radius is 1/2 of the diameter.
		var perimeter = 2 * (SIDE_LENGTH / 8) * Math.PI;
		var length = perimeter / SEGMENTS;
		var angle = HALF_CIRCLE / SEGMENTS;

		for (var i = 0; i <= SEGMENTS; ++i) {
			fd(length);

			// Don't be over-zealous with turning; we want to be facing
			// exactly left when we're done.
			if (i != SEGMENTS) {
				rt(angle);
			}
		}
	}

	// Draw curves
	drawCurve();
	rt(180);
	drawCurve();

	// Finish the bottom span
	fd(SIDE_LENGTH / 4);
}

moveTo(-50, 0);
drawA();

moveTo(50, 0);
drawB();
