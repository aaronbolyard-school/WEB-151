for (var i = 0; i < 3; ++i)
{
  for (var j = 0; j < 3; ++j)
  {
    for (var k = 0; k < 4; ++k)
    {
      moveForward();
      turnLeft(-90);
    }
    
    moveForward();
  }
  
  turnLeft(-90);
  moveForward();
  
  turnLeft(-90);
  for (var k = 0; k < 3; ++k)
  {
    moveForward();
  }
  
  if (i + 1 < 3)
  {
    turnLeft(180);
  }
}

turnLeft(-90);

for (var i = 0; i < 3; ++i)
{
  moveForward();
}
turnLeft(-90);