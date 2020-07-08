/*
Ryan Oakley
ICS 3U1
Assignment 4 - Space Invaders
Here I'm creating a Space Invaders game where you play as a ship shooting at aliens in the sky to prevent them from landing on earth.
This project was inspired from the old retro game "Space Invaders" from 1978.
Use arrow keys to move and the space bar to shoot.
*/

PFont retro;
PImage alien;
PImage ship;
PImage coinPoints;

boolean shipRight, shipLeft;
int shipX;
int shipY;
int[] alienX = {70,140,210,280,350,420,490,70,140,210,280,350,420,490,70,140,210,280,350,420,490}; //21 aliens (counter: 0-20)
int[] alienY = {100,100,100,100,100,100,100,150,150,150,150,150,150,150,200,200,200,200,200,200,200};
boolean[] alienAlive = {true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true};
float alienSpeed;
int direction = 1; //When this is positive, the aliens will be moving right, when it's negative, the aliens will be moving left

boolean alienReady = true;
boolean alienReady2;
int millisMinus = 0;
int millisAlien = 0;
boolean alienMoving;

int shipSkinNumber = 0; //Tells you what kind of ship you are using (what colour ship)
int shipLaserX;
int shipLaserY;
boolean shipLaser = true;
boolean shipLaserActive;

int EquipType = 0;
boolean GotGreen = false;
boolean GotClearBlue = false;
boolean GotBlack = false;
boolean GotJem = false;
int savedGreen = 0; //When it's 1, then that means you have already bought the type of ship and it's saved on the computer
int savedClearBlue = 0;
int savedBlack = 0;
int savedJem = 0;
String shipTxt = "savedShip1.txt";
String[] shipString = null;

int TravalLineSpeed = 5; //For the shop's moving lines look
int xLine0 = 25,xLine1 =130,xLine2 = 236,xLine3 = 330;
int yLine0 = 455,yLine1 = 373,yLine2 = 251,yLine3 = 139;

int costGreen = 50000;
int costBlack = 70000;
int costClearBlue = 95000;
int costJem = 100000;

int points = 0;
String pointsTxt = "points1.txt";
String[] pointsString = null;
int round = 1;
int[] titleLaserY = {0,100,200,300,400,500,600,700,800,900}; //Y cords for lasers moving in title screen
int[] titleLaser2Y = {0,100,200,300,400,500,600,700,800,900}; //Y cords for lasers moving in title screen
int laserSpeed = 5;
boolean titleScreen = true;
boolean shop = false;
boolean inGame = false;
boolean winScreen = false;
boolean loseScreen = false;

void setup() {
  retro = createFont("Retro Gaming.ttf", 50);
  alien = loadImage("alien.png");
  ship = loadImage("ship.png");
  coinPoints = loadImage("coin.png");
  pointsString = loadStrings(pointsTxt);
  points = int(pointsString[0]);
  shipString = loadStrings(shipTxt);
  size(800,1000);
  background(#000033);
  imageMode(CENTER);
  shipX = width/2;
  shipY = height-100;
}

void draw() {
  background(#000033);
  if (titleScreen == true) {
    title();
    savedShip(); //gets the player the ships they have already purchased before
  }
  if (shop == true) {
    shop();
  }
  if (inGame == true) {
    shipLaser();
    alienModel();
    shipModel();
    shipMovement();
    alienMovement();
    alienHitDetection();
    checkAliens();
  }
  if (winScreen == true) {
    win();
  }
  if (loseScreen == true) {
    lose();
  }
}

void alienModel() {
  alien.resize(40,40);
  for (int i = 0; i < alienX.length; i++) {
    if (alienAlive[i] == true) {
      tint(#FFFFFF);
      image(alien,alienX[i],alienY[i]); 
    }
  }
}

void shipModel() {
  if (EquipType == 0) {
    tint(#FFFFFF);
  }
  if (EquipType == 1) {
    tint(#9c9c00); //Green
  }
  if (EquipType == 2) {
    tint(#e810c0); //Clear Blue
  }
  if (EquipType == 3) {
    tint(100,0,0); //Black
  }
  if (EquipType == 4) {
    tint(#ffb547); //Jem
  }
  ship.resize(50,50);
  image(ship,shipX,shipY);
}

void keyPressed() {
  if (key == CODED) {
     if (keyCode == RIGHT) {
       shipRight = true;
     }
     if (keyCode == LEFT) {
       shipLeft = true;
     }
  }
}

void keyReleased() {
  if (key == CODED) {
     if (keyCode == RIGHT) {
       shipRight = false;
     }
     if (keyCode == LEFT) {
       shipLeft = false;
     }
  }
}

void shipMovement() {
  if (shipRight == true) {
    shipX += 5;
  }
  if (shipLeft == true) {
    shipX -= 5;
  }
  
  if (shipX < 25) { shipX = 25; } //Retrictions
  if (shipX > width-25) { shipX = width-25; }
}

void alienMovement() {
  if (alienReady == true) {
    millisMinus = millis();
    alienReady2 = true;
    alienReady = false;
  }
  
  if (alienReady2 == true) {
  millisAlien = (millis() - millisMinus)/10;
    if (millisAlien > alienSpeed && alienMoving == false) { //0.5 second timer
      alienMoving = true;
    }
    if (millisAlien > alienSpeed+50) {//1 second timer
      alienMoving = false;
      alienReady2 = false;
      alienReady = true;
    }
  }
  
  if (alienMoving == true) { //Movement of aliens left and right
    for (int i = 0; i < alienAlive.length; i++) {
      alienX[i] += direction*2;
    }
  }
  
  if (alienX[6] > width) { //Movement down hitting right wall
    for (int i = 0; i < alienAlive.length; i++) {
      alienY[i] += 40; //Amount the aliens jump downwards after hitting the wall
      alienX[i] -= 5;
      if (i == 20) {
        direction = -1;
      }
    }
  }
  if (alienX[0] < 0) { //Movement down hitting left wall
    for (int i = 0; i < alienAlive.length; i++) {
      alienY[i] += 40; //Amount the aliens jump downwards after hitting the wall
      alienX[i] += 5;
      if (i == 20) {
        direction = 1;
      }
    }
  }
}

void shipLaser() {
  if (shipLaser == true && keyPressed && key == 32) { //If the space key is pressed..
    shipLaserActive = true;
    shipLaserX = shipX;
    shipLaserY = shipY - 60;
    shipLaser = false;
  }
  
  if (shipLaserActive == true) {
    rectMode(CENTER);
    noStroke();
    fill(#6600CC);
    rect(shipLaserX,shipLaserY+15,5,30);
    
    shipLaserY -= 25; //Speed of laser
    
    if (shipLaserY < 0) { //If laser misses...
      shipLaser = true;
      shipLaserActive = false;
    }
  }
}

void alienHitDetection() {
  for (int i = 0; i < alienAlive.length; i++) {
    if (alienAlive[i] == true) {
      if (shipLaserX > alienX[i]-20 && shipLaserX < alienX[i]+20 && shipLaserY > alienY[i]-20 && shipLaserY < alienY[i]+20) { //If laser hits...
        shipLaserY = shipY;
        points+=100; //Adds 100 points for every alien killed
        pointsString[0] = str(points);
        saveStrings(pointsTxt, pointsString); //Records the points into the text file
        alienAlive[i] = false; //That alien that gets shot will apear dead
        shipLaser = true;
        shipLaserActive = false;
      }
    }
  }
}

void title() {
  int playButtonX = width-300;
  int playButtonY = height-750;
  int playButtonS = 200; //Button size
  int instructionsButtonX = width-500;
  int instructionsButtonY = height-500;
  int instructionsButtonS = 200; //Button size
  int quitButtonX = width-300;
  int quitButtonY = height-250;
  int quitButtonS = 200; //Button Size
  int shopButtonX = width-500;
  int shopButtonY = height-750;
  int shopButtonS = 150; //Button Size
  int a = 1;
  int b = 0;
  
  textAlign(CENTER,CENTER);
  textFont(retro);
  fill(#FFFFFF);
  text("SPACE INVADERS", width/2, 80);
  
  fill(#FFFFFF);
  if (detectCircle(playButtonX,playButtonY,playButtonS,mouseX,mouseY)) { //Play button
    laserSpeed = -5;
    fill(#FF33AA);
    textSize(40);
    if (mousePressed) {
      round = 1;
      alienSpeed = 50;
      inGame = true;
      titleScreen = false;
      
      for (int i = 0; i < alienAlive.length; i++) { //This brings the aliens to it's start position
      if (i == 7 || i == 14) {
        a = 1;
        b += 50;
      }
      alienX[i] = 70*a;
      alienY[i] = 100 + b;
      a++; 
      }
      for (int i = 0; i < alienAlive.length; i++) {
        alienAlive[i] = true;
      }
    }
  }
  ellipse(playButtonX,playButtonY,playButtonS,playButtonS); //Play button
  fill(0);
  text("PLAY",playButtonX,playButtonY);
  fill(#FFFFFF);
  
  textSize(30);
  if (detectCircle(shopButtonX,shopButtonY,shopButtonS,mouseX,mouseY)) { //Shop button
    laserSpeed = -5;
    fill(#FF33AA);
    textSize(25);
    if (mousePressed) {
      shop = true;
      titleScreen = false;
    }
  }
  ellipse(shopButtonX,shopButtonY,shopButtonS,shopButtonS); //Shop button
  fill(0);
  text("SHOP",shopButtonX,shopButtonY);
  fill(#FFFFFF);
  
  textSize(20);
  if (detectCircle(instructionsButtonX,instructionsButtonY,instructionsButtonS,mouseX,mouseY)) { //Instructions button
    laserSpeed = -5;
    fill(#FF33AA);
    text("Use arrows keys to move the ship, and space bar to shoot.", width-250, height-500, 300, 200);
    textSize(15);
  }
  ellipse(instructionsButtonX,instructionsButtonY,instructionsButtonS,instructionsButtonS); //Instructions button
  fill(0);
  text("INSTRUCTIONS",instructionsButtonX,instructionsButtonY);
  fill(#FFFFFF);
  
  textSize(50);
  if (detectCircle(quitButtonX,quitButtonY,quitButtonS,mouseX,mouseY)) { //Quit button
    laserSpeed = -5;
    fill(#FF33AA);
    textSize(40);
    if (mousePressed) {
      exit(); 
    }
  }
  ellipse(quitButtonX,quitButtonY,quitButtonS,quitButtonS); //Quit button
  fill(0);
  text("QUIT",quitButtonX,quitButtonY);
  fill(#FFFFFF);
  
  if (!detectCircle(playButtonX,playButtonY,playButtonS,mouseX,mouseY) && !detectCircle(instructionsButtonX,instructionsButtonY,instructionsButtonS,mouseX,mouseY) && !detectCircle(quitButtonX,quitButtonY,quitButtonS,mouseX,mouseY) && !detectCircle(shopButtonX,shopButtonY,shopButtonS,mouseX,mouseY)) {
    laserSpeed = 5; //If the mouse is not hovering over any button, then the lasers will go up
  }
  
  // Title Laser animation
  rectMode(CENTER);
  noStroke();
  fill(#6600CC);
  for (int i = 0; i < titleLaserY.length; i++) {
    rect(50,titleLaserY[i],5,30);
    titleLaserY[i] -= laserSpeed;
  }
  for (int i = 0; i < titleLaserY.length; i++) {
    if (titleLaserY[i] < 0) {
      titleLaserY[i] = height; 
    }
    if (titleLaserY[i] > height) {
      titleLaserY[i] = 0; 
    }
  }
  
  for (int i = 0; i < titleLaser2Y.length; i++) {
    rect(width-50,titleLaser2Y[i],5,30);
    titleLaser2Y[i] -= laserSpeed;
  }
  for (int i = 0; i < titleLaser2Y.length; i++) {
    if (titleLaser2Y[i] < 0) {
      titleLaser2Y[i] = height; 
    }
    if (titleLaser2Y[i] > height) {
      titleLaser2Y[i] = 0; 
    }
  }
}

boolean detectCircle(float x, float y, float s, float xx, float yy) { //Formula for circle detection, first three floats will be button values, last two floats will be mouse values
  float distance = dist(x, y, xx, yy);
  float radiusSum = (s)*0.5;
  return radiusSum > distance;
}

void savedShip() {
  savedGreen = int(shipString[0]);
  savedClearBlue = int(shipString[1]);
  savedBlack = int(shipString[2]);
  savedJem = int(shipString[3]);
  
  if (savedGreen == 1) {
    GotGreen = true;
  }
  if (savedClearBlue == 1) {
    GotClearBlue = true;
  }
  if (savedBlack == 1) {
    GotBlack = true;
  }
  if (savedJem == 1) {
    GotJem = true;
  }
}

void coinDisplay() {//       Coin image for points you have and cost of ship tint
  coinPoints.resize(20*scale,20*scale);
  tint(255,255,0);
  image(coinPoints,225*scale,100*scale);
  image(coinPoints,35*scale,235*scale);
  image(coinPoints,35*scale,410*scale);
  image(coinPoints,235*scale,235*scale);
  image(coinPoints,235*scale,410*scale);
}

void shipModelGreen() {//ship tint Green
  ship.resize(50*scale,50*scale);
  tint(#9c9c00);
  image(ship,38*scale,160*scale);   
 
}
void shipModelClearBlue() {//ship tint Clear Blue
  ship.resize(50*scale,50*scale);
  tint(#e810c0);
  image(ship,38*scale,335*scale);
}

void shipModelBlack() {//ship tint Black
  ship.resize(50*scale,50*scale);
  tint(100,0,0);
  image(ship,238*scale,160*scale);
}

void shipModelJem() {//ship tint Jem
  ship.resize(50*scale,50*scale);
  tint(#ffb547);
  image(ship,238*scale,335*scale);
  tint(#FFFFFF);
}

int scale = 2; //This is for multiplying all the cords by 2 to fit the 800x1000 window screen (some of this code was made using a 400x500 window)
void shop() {  
  if (mousePressed) {
    if((mouseY<(100)) && (mouseY>(10)))  {// Back button
      if((mouseX<(340)) && (mouseX>(40)))  {
        titleScreen = true;
        shop = false; 
      } 
    }
    
    if((mouseY<(100)) && (mouseY>(10)))  {//    Button opperation to set back to Defult Skin
      if((mouseX<(730)) && (mouseX>(440)))  {
        if(EquipType == 1||EquipType == 2||EquipType == 3||EquipType == 4)  {
          EquipType = 0;
        }
      } 
    }
  
    if((mouseY<(600)) && (mouseY>(400))) {//    Button opperation to equip Green tint
      if((mouseX<(280)) && (mouseX>(100))) {
        if (GotGreen == true)  {
          EquipType = 1;
        }
      }
    }
    
    if((mouseY<(600)) && (mouseY>(400)))  {//    Button opperation to Buy the Green tint
      if((mouseX<(280)) && (mouseX>(100)))  {
        if(points >= costGreen) {
          if(GotGreen == false) {
            points -= costGreen;
            pointsString[0] = str(points);
            saveStrings(pointsTxt, pointsString); //Records the points into the text file
            shipString[0] = str(1);
            saveStrings(shipTxt, shipString); //Records the ship into the text file
            GotGreen = true;
          }
        }
      }
    }
  
    if((mouseY<(940)) && (mouseY>(860)))  {//    Button opperation to equip Clear Blue tint
      if((mouseX<(280)) && (mouseX>(100)))  {
        if (GotClearBlue == true)  {
          EquipType = 2;
        }
      }
    }
    
    if((mouseY<(940)) && (mouseY>(860)))  {//    Button opperation to Buy the Clear Blue tint
      if((mouseX<(280)) && (mouseX>(100)))  {
        if(points >= costClearBlue)  {
          if(GotClearBlue == false)  {
            points -= costClearBlue;
            pointsString[0] = str(points);
            saveStrings(pointsTxt, pointsString); //Records the points into the text file
            shipString[1] = str(1);
            saveStrings(shipTxt, shipString); //Records the ship into the text file
            GotClearBlue = true;
          }
        }
      }
    }

    if((mouseY<(620)) && (mouseY>(500)))  {//    Button opperation to equip Black tint
      if((mouseX<(680)) && (mouseX>(520)))  {
        if (GotBlack == true)  {
          EquipType = 3;
        }
      }
    }
    
    if((mouseY<(620)) && (mouseY>(540)))  {//    Button opperation to Buy the Black tint
      if((mouseX<(680)) && (mouseX>(520)))  {
        if(points >= costBlack)  {
          if(GotBlack == false)  {
            points -= costBlack;
            pointsString[0] = str(points);
            saveStrings(pointsTxt, pointsString); //Records the points into the text file
            shipString[2] = str(1);
            saveStrings(shipTxt, shipString); //Records the ship into the text file
            GotBlack = true;
          }
        }
      }
    }
  
    if((mouseY<(940)) && (mouseY>(860)))  {//    Button opperation to equip Jem tint
      if((mouseX<(680)) && (mouseX>(520)))  {
        if (GotJem == true)  {
          EquipType = 4;
        }
      }
    }
    
    if((mouseY<(940)) && (mouseY>(860)))  {//    Button opperation to Buy the Jem tint
      if((mouseX<(680)) && (mouseX>(520)))  {
        if(points >= costJem)  {
          if(GotJem == false)  {
            points -= costJem;
            pointsString[0] = str(points);
            saveStrings(pointsTxt, pointsString); //Records the points into the text file
            shipString[3] = str(1);
            saveStrings(shipTxt, shipString); //Records the ship into the text file
            GotJem = true;
          }
        }
      }
    }
  } //End of mousePressed
  rectMode(CORNER);
  imageMode(CORNER);
  textAlign(LEFT);
  background(150,50,75);
  fill(150,85,127);
  //noStroke();
  stroke(0);
  rect(0,120,400,150);//store box       
  fill(0);
  textSize(60);
  text("SHOP",35,214); //Store txt black
  fill(219,198,9);
  text("SHOP",46,210);//store txt yellow
  
  fill(0);
  text(str(points),510,236);//shows the ammount of points you have on the screen
  
  fill(150,85,127);
  rect(25*scale,150*scale,150*scale,150*scale);//first skin Green
  rect(25*scale,325*scale,150*scale,150*scale);//second skin (under first skin) Clear Blue
  rect(225*scale,150*scale,150*scale,150*scale);//third skin Black
  rect(225*scale,325*scale,150*scale,150*scale);//fourth skin (under third skin) Jem
  
  fill(230,148,48);
  stroke(207,117,43);
  rect(25*scale,150*scale,75*scale,75*scale);//the folloing are the orange boxes for ship skin display
  rect(25*scale,325*scale,75*scale,75*scale);
  rect(225*scale,150*scale,75*scale,75*scale);
  rect(225*scale,325*scale,75*scale,75*scale);
  shipModelGreen();//green ship display 
  shipModelClearBlue();//Clear Blue ship display
  shipModelBlack();//black ship display
  shipModelJem();//Jem ship display

  textSize(30);
  fill(#2e8f07);
  text("GREEN",110*scale,193*scale);
  fill(0);//                Green txt for Ship skin
  text("GREEN",109*scale,195*scale);
  
  fill(#ffffff);
  text("BLACK",310*scale,193*scale);
  fill(0);//                Black txt for Ship skin
  text("BLACK",309*scale,195*scale);
  
  fill(#112ff2);
  text("CLEAR",110*scale,353*scale);
  fill(0);
  text("CLEAR",109*scale,355*scale);
  //                        Clear Blue txt for Ship skin
  fill(#112ff2);
  text("BLUE",110*scale,373*scale);
  fill(0);
  text("BLUE",109*scale,375*scale);
  
  fill(#f2c511);
  text("JEM",320*scale,353*scale);
  fill(0);//                Jem txt for Ship skin
  text("JEM",319*scale,355*scale);
  
  noFill();
  coinDisplay();//Coin shows on screen
  
  text(str(costGreen),60*scale,252*scale);
  text(str(costBlack),260*scale,252*scale);
  text(str(costClearBlue),60*scale,426*scale);
  text(str(costJem),260*scale,426*scale);
  
  //line animation
  fill(150);
  noStroke();
  rect(194*scale,yLine0*scale,6*scale,20*scale);
  rect(194*scale,yLine1*scale,6*scale,20*scale);
  rect(194*scale,yLine2*scale,6*scale,20*scale);
  rect(194*scale,yLine3*scale,6*scale,20*scale);
  
  rect(xLine0*scale,310*scale,20*scale,6*scale);
  rect(xLine1*scale,310*scale,20*scale,6*scale);
  rect(xLine2*scale,310*scale,20*scale,6*scale);
  rect(xLine3*scale,310*scale,20*scale,6*scale);
  
  xLine0 += TravalLineSpeed;
  xLine1 += TravalLineSpeed;
  xLine2 += TravalLineSpeed;
  xLine3 += TravalLineSpeed;
  
  yLine0 -= TravalLineSpeed;
  yLine1 -= TravalLineSpeed;
  yLine2 -= TravalLineSpeed;
  yLine3 -= TravalLineSpeed;
  
  if(xLine0>380*scale)  {
    xLine0 = 0;
  } 
  if(xLine1>380*scale)  {
    xLine1 = 0;
  }
  if(xLine2>380*scale)  {
    xLine2 = 0;
  }  
  if(xLine3>380*scale)  {
    xLine3 = 0;
  }  
  if(yLine0<280/scale)  {
    yLine0 = 455*scale;
  }
  if(yLine1<280/scale)  {
    yLine1 = 455*scale;
  } 
  if(yLine2<280/scale)  {
    yLine2 = 455*scale;
  }  
  if(yLine3<280/scale)  {
    yLine3 = 455*scale;
  }
  
  fill(#FFFFFF);
  stroke(0);
  ellipse(95*scale,30*scale,150*scale,50*scale);
  fill(0);
  text("BACK",68*scale,38*scale);
  
  if(GotGreen == false)  { //    Button resultants for Green tint
    fill(#300b61);
    stroke(0);
    ellipse(98*scale,275*scale,80*scale,36*scale);
    fill(#cf8e1f);
    text("BUY",80*scale,283*scale);
    
  }    
  if (EquipType!=1);{//   SET DEFULT BUTON FOR ALL TINTS
    fill(#300b61);
    stroke(0);
    ellipse(295*scale,30*scale,150*scale,50*scale);
    fill(#cf8e1f);
    text("Set Defult",248*scale,38*scale);
  }
  
  if(EquipType==1)  {
    fill(#e63d0e);
    fill(0);
    text("Equiped...",51*scale,283*scale);       
  }
      
  if(GotGreen == true)  {
    if(EquipType != 1)  {
      fill(#59700d);
      stroke(0);
      ellipse(98*scale,275*scale,80*scale,36*scale);
      fill(255);
      text("Equip",71*scale,283*scale);
    }
  }
 
  if(GotClearBlue == false)  { //    Button resultants for Clear Blue tint
    fill(#300b61);
    stroke(0);
    ellipse(98*scale,450*scale,80*scale,36*scale);
    fill(#cf8e1f);
    text("BUY",80*scale,458*scale);
  }
       
  if(EquipType==2)  {
    fill(#e63d0e);
    fill(0);
    text("Equiped...",51*scale,458*scale);    
  }
    
  if(GotClearBlue == true)  {
    if(EquipType != 2)  {
      fill(#59700d);
      stroke(0);
      ellipse(98*scale,450*scale,80*scale,36*scale);
      fill(255);
      text("Equip",71*scale,458*scale);
    }
  }

  if(GotBlack == false)  { //    Button resultants for Black tint
    fill(#300b61);
    stroke(0);
    ellipse(298*scale,275*scale,80*scale,36*scale);
    fill(#cf8e1f);
    text("BUY",280*scale,283*scale);
  }
        
  if(EquipType==3)  {
    fill(#e63d0e);
    fill(0);
    text("Equiped...",251*scale,283*scale);       
  }

  if(GotBlack == true)  {
    if(EquipType != 3)  {
      fill(#59700d);
      stroke(0);
      ellipse(298*scale,275*scale,80*scale,36*scale);
      fill(255);
      text("Equip",271*scale,283*scale);
    }
  }
  
  if(GotJem == false)  {   //            Buton Resultants for Jem
    fill(#300b61);
    stroke(0);
    ellipse(298*scale,450*scale,80*scale,36*scale);
    fill(#cf8e1f);
    text("BUY",280*scale,458*scale);    
  }
  
  if(EquipType==4)  {
    fill(#e63d0e);
    fill(0);
    text("Equiped...",251*scale,458*scale); 
  }
  
  if(GotJem == true)  {
    if(EquipType != 4)  {
      fill(#59700d);
      stroke(0);
      ellipse(298*scale,450*scale,80*scale,36*scale);
      fill(255);
      text("Equip",271*scale,458*scale);
    }
  }
}

void checkAliens() { //This checks if you win or lose
  boolean aliensRemaining = false;
  int a = 1;
  int b = 0;
  
  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER,CENTER);
  textSize(50);
  fill(#6600CC);
  text("ROUND " + round, width/2, 40); //round display
  textSize(20);
  fill(#FFFFFF);
  text("POINTS: " + points, 150, 40); //points display
  for (int i = 0; i < alienAlive.length; i++) {
    if (alienAlive[i] == true) {
      aliensRemaining = true;
    }
  }
  if (aliensRemaining == false) { //When all the aliens are dead, next round
    round += 1; //Round changes
    alienSpeed /= 2; //Speeds up the aliens
    for (int i = 0; i < alienAlive.length; i++) { //This brings the aliens to it's start position
      if (i == 7 || i == 14) {
        a = 1;
        b += 50;
      }
      alienX[i] = 70*a;
      alienY[i] = 100 + b;
      a++; 
    }
    for (int i = 0; i < alienAlive.length; i++) {
      alienAlive[i] = true;
    }
    
  }
  if (alienY[alienX.length-1] > height-150) { //When all the aliens reach close to the ship you lose
    loseScreen = true;
    inGame = false;
  }
  if (round > 3) { //When you beat round 3 you win
    winScreen = true;
    inGame = false;
  }
}

void win() {
  int playAgainButtonX = width-100;
  int playAgainButtonY = height-100;
  int playAgainButtonS = 100;
  
  textSize(50);
  fill(#6600CC);
  text("YOU WIN!", width/2, height/2);
  textSize(15);
  if (detectCircle(playAgainButtonX,playAgainButtonY,playAgainButtonS,mouseX,mouseY)) { //Play again button
    fill(#FF33AA);
    textSize(13);
    if (mousePressed) {
      winScreen = false;
      titleScreen = true;
    }
  }
  ellipse(playAgainButtonX,playAgainButtonY,playAgainButtonS,playAgainButtonS);
  fill(0);
  text("PLAY AGAIN?",playAgainButtonX,playAgainButtonY,70,50);
  fill(#FFFFFF);
}

void lose() {
  int playAgainButtonX = width-100;
  int playAgainButtonY = height-100;
  int playAgainButtonS = 100;
  
  textSize(50);
  text("GAME OVER", width/2, height/2);
  textSize(15);
  if (detectCircle(playAgainButtonX,playAgainButtonY,playAgainButtonS,mouseX,mouseY)) { //Play again button
    fill(#FF33AA);
    textSize(13);
    if (mousePressed) {
      loseScreen = false;
      titleScreen = true;
    }
  }
  ellipse(playAgainButtonX,playAgainButtonY,playAgainButtonS,playAgainButtonS);
  fill(0);
  text("PLAY AGAIN?",playAgainButtonX,playAgainButtonY,70,50);
  fill(#FFFFFF);
}
