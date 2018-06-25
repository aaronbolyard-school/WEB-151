clear();
pendown();

function flake(length) {
	fd(length);
	rt(60);
	fd(length);
	rt(120);
	fd(length);
	rt(60);
	fd(length);
	rt(120);
}

var FLAKE_COLORS = [
	"#55ddff",
	"#00aad4",
	"#d5f6ff",
	"#c83737"
];

console.log(FLAKE_COLORS.length);

for (var i = 0; i < FLAKE_COLORS.length; ++i) {
	color(FLAKE_COLORS[i]);

	var length = Math.abs(Math.sin(360 / 4 * (i + 1)) * 100 + 50);
	for (var j = 0; j < 8; ++j) {
		flake(length);
		rt(45);
	}

	home();
	rt((i + 1) * (360 / FLAKE_COLORS.length))
}
