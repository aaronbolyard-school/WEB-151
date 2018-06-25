// https://studio.code.org/projects/applab/AIMPXHeokyIn1foFJOpc4WUnYU7oli32l9sS6vkjtM0

function drawDiamond() {
  drawSide();
  drawSide();
  drawSide();
  drawSide();
}

function drawSide() {
  drawStep();
  drawStep();
  drawStep();
  moveForward();
  right();
}

function drawStep() {
  moveForward();
  turnLeft();
  moveForward();
  right();
}

function right() {
  turnLeft();
  turnLeft();
  turnLeft();
}

drawDiamond();
