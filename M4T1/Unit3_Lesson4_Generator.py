"""
Final output:
https://studio.code.org/projects/applab/_OO7LgEoNMWjhp9guRSePG0APp_4NHMBReTHZGYaSv8
"""

def moveForward():
  print("moveForward();")

def turnLeft(value):
  count = 0
  if value < 0:
    count = (360 + value) // 90
  else:
    count = value // 90

  for i in range(count):
    print("turnLeft();")

SQUARE_SIZE = 3
SQUARE_SIDES = 4
def main():
  for i in range(SQUARE_SIZE):
    for j in range(SQUARE_SIZE):
      for k in range(SQUARE_SIDES):
        moveForward()
        turnLeft(-90)
      moveForward()
    
    turnLeft(-90)
    moveForward()
    
    turnLeft(-90)
    for k in range(SQUARE_SIZE):
      moveForward()
    
    if i + 1 < 3:
      turnLeft(180)

  turnLeft(-90)
  for i in range(SQUARE_SIZE):
    moveForward()
  turnLeft(-90)

if __name__ == "__main__":
  main()
