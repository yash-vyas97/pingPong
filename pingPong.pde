/*
 
 To play: Control the left paddle with the UP and DOWN keys.
 Control the right paddle with the left and right mouse buttons.
 First to 11 points wins.
*/

final float PADDLE_WIDTH = 10.0; //paddle size
final float PADDLE_HEIGHT = 50.0;
final float PADDLE_DISTANCE = 20.0; //distance from edge of screen
final float BALL_DIAMETER = 10.0;

final float PADDLE_SPEED = 3.0; //pixels per frame
final float MAX_SPEED = 4.0;
final float MIN_SPEED = 2.0;

float keyPaddleY; //centre of the paddle controlled by the keyboard
float mousePaddleY; //centre of the paddle controlled by the mouse
float ballX, ballY; //location of centre of ball
float direction; //direction of ball, in radians
float ballSpeed = 3.0;
float xSpeed, ySpeed; //speed of ball, in pixels per frame

int keyScore, mouseScore;
boolean gameOver = false;

void setup() {
  size(600, 500);
  initializeGame();
}

void draw() {
  drawGame();
  
  if (!gameOver){
    moveKeyPaddle();
    moveMousePaddle();
    moveBall();
    testScored();
  }
}

void initializeGame() {
  resetPaddles();
  resetBall();
  keyScore = 0;
  mouseScore = 0;
}

void resetPaddles() {
  keyPaddleY = height/2;
  mousePaddleY = height/2;
}

void resetBall() {
  ballX = width/2;
  ballY = height/2;
  direction = random(2*PI);

  //if ball would bounce up and down, set direction
  if (direction > PI/4 && direction < 3*PI/4)
    direction = 3*PI/4;
  else if (direction > 5*PI/4 && direction < 7*PI/4)
    direction = 7*PI/4;

  calcBallSpeedXandY();

}

void calcBallSpeedXandY() {
  xSpeed = ballSpeed * cos(direction);
  ySpeed = ballSpeed * sin(direction);
}

void drawGame() {
  background(0, 0, 100); //dark blue

  //draw paddles
  noStroke();
  fill(0, 0, 255);
  rect(PADDLE_DISTANCE-PADDLE_WIDTH/2, keyPaddleY-PADDLE_HEIGHT/2, PADDLE_WIDTH, PADDLE_HEIGHT);
  rect(width-PADDLE_DISTANCE-PADDLE_WIDTH/2, mousePaddleY-PADDLE_HEIGHT/2, PADDLE_WIDTH, PADDLE_HEIGHT);

  //draw ball
  fill(255);
  ellipse(ballX, ballY, BALL_DIAMETER, BALL_DIAMETER);

  drawScore();
}

void drawScore() {
  textSize(20);
  String toPrint = "Keyboard: "+keyScore;
  text(toPrint, width/4-textWidth(toPrint)/2, 50);
  toPrint = "Mouse: "+mouseScore;
  text(toPrint, width*3/4-textWidth(toPrint)/2, 50);
}

void moveKeyPaddle() {
  if (keyPressed) {
    if (keyCode == UP) {
      keyPaddleY = max(keyPaddleY-PADDLE_SPEED, PADDLE_HEIGHT/2);
      //alternate:
      //if (keyPaddleY > PADDLE_HEIGHT/2)
      //  keyPaddleY -= PADDLE_SPEED;
    } else if (keyCode == DOWN) {
      keyPaddleY = min(keyPaddleY+PADDLE_SPEED, height-PADDLE_HEIGHT/2);
      //alternate:
      //if (keyPaddleY < height-PADDLE_HEIGHT/2)
      //  keyPaddleY += PADDLE_SPEED;
    }
  }
}

void moveMousePaddle() {
  if (mousePressed) {
    if (mouseButton == RIGHT) { //move paddle up
      mousePaddleY = max(mousePaddleY-PADDLE_SPEED, PADDLE_HEIGHT/2);
      //alternate:
      //if (mousePaddleY > PADDLE_HEIGHT/2)
      //  mousePaddleY -= PADDLE_SPEED;
    } else if (mouseButton == LEFT) { //move paddle down
      mousePaddleY = min(mousePaddleY+PADDLE_SPEED, height-PADDLE_HEIGHT/2);
      //alternate:
      //if (mousePaddleY < height-PADDLE_HEIGHT/2)
      //  mousePaddleY += PADDLE_SPEED;
    }
  }
}

void moveBall() {
  ballX += xSpeed;
  ballY += ySpeed;

  //rebound from top & bottom of screen
  if (ballY < BALL_DIAMETER/2 || ballY > height-BALL_DIAMETER/2) {
    ySpeed *= -1;
  }  
  //rebound from the left paddle
  else if (ballX > PADDLE_DISTANCE && ballX < PADDLE_DISTANCE+PADDLE_WIDTH 
    && ballY > keyPaddleY-PADDLE_HEIGHT/2 && ballY < keyPaddleY+PADDLE_HEIGHT/2) {

    //xSpeed *= -1;

    //choose a new direction
    direction = random(7*PI/4, 9*PI/4);

    //find distance from centre of paddle to ball
    float distance = abs(ballY - keyPaddleY);

    //scale distance to a new ball speed
    ballSpeed = MIN_SPEED + distance*(MAX_SPEED-MIN_SPEED)/(PADDLE_HEIGHT/2);

    //calculate new x and y components of speed
    calcBallSpeedXandY();
  }
  //rebound from the right paddle
  else if (ballX > width-PADDLE_DISTANCE-PADDLE_WIDTH && ballX < width-PADDLE_DISTANCE
    && ballY > mousePaddleY-PADDLE_HEIGHT/2 && ballY < mousePaddleY+PADDLE_HEIGHT/2) {

    //xSpeed *= -1;

    //choose a new direction
    direction = random(3*PI/4, 5*PI/4);

    //find distance from centre of paddle to ball
    float distance = abs(ballY - mousePaddleY);

    //scale distance to a new ball speed
    ballSpeed = MIN_SPEED + distance*(MAX_SPEED-MIN_SPEED)/(PADDLE_HEIGHT/2);

    //calculate new x and y components of speed
    calcBallSpeedXandY();
  }
}   

//test if a player has scored, and if so, increase score and generate a new ball
void testScored() {
  if (ballX < 0) {
    mouseScore++;
    resetBall();
  } else if (ballX > width) {
    keyScore++;
    resetBall();
  }
  
  if (mouseScore == 11 || keyScore == 11)
    gameOver = true;
  
}
