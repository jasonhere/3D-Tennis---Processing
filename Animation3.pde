float radius = 50.0;
float ball_speed = 0.0;
float sun_speed = 0.0;
float racket_pos = -400.0;
float last_sec = 0.0;
int keyR_count = 0;
int[] rain_speed;
int[] rain_pos;
int cameraX = -90;
int cameraY = 0;
int cameraZ = -350;
int rotateText = 90;
int rotateView = 0;
boolean ball_change = false;
boolean keyR = false;
boolean right = true;
boolean key4 = false;
boolean keyEnter = false;
String s = "Press key\n" +
           "R: Rain + lightning\n   (enable/disable)\n" +
           "1: 1st view\n" +
           "2: 2nd view\n" +
           "3: 3rd view\n" +
           "4: 4th view\n" +
           "5: free view\n" +
           "6: top view (reset)\n";

void setup()
{
  size(1000, 700, P3D);
  background(0);
  rain_speed = new int[100];
  rain_pos = new int[100];
  for(int i = 0; i < 100; i++){
    rain_speed[i] = int(random(10,30));
    rain_pos[i] = int(random(0,100));
  }// init
}

void draw()
{
  background(126,192,238);
  rectMode(CENTER);
  textMode(SHAPE);
  lights();
  translate(width/2, height/2, cameraZ);
  rotateY(radians(cameraY));
  rotateX(radians(cameraX));
  if(key4 == true)
    rotateY(radians(frameCount)*0.5);  //free view
  
  ball_speed += 3;
  sun_speed += 1;

  if(!keyEnter){
    pushMatrix();
    rotateX(radians(90));
    textSize(70);
    fill(255);
    text("PRESS ENTER", -210, 500, 0);
    popMatrix();
  }// display press enter
  
  moveView();
  if(keyR == true)
    drawRain(); 
  drawSky();
  drawTennisCourt();
  
  //draw + change racket position
  if(racket_pos >= -400 && right == true){
    racket_pos += 5;
    if(racket_pos == 400)
      right = false;
  }
  if(right == false){
    racket_pos -= 5;
    if(racket_pos == -400)
      right = true;
  }
  pushMatrix();
  translate(racket_pos, 50, 450);
  drawRacket();
  popMatrix();
  pushMatrix();
  translate(-racket_pos, 50, -450);
  rotateZ(radians(-90)); 
  drawRacket();
  popMatrix();
  
  /*
  pushMatrix();
  noFill();
  stroke(255, 125, 125);
  strokeWeight(1);
  //bezier(0,100,400, 500,-250,350, 300,-300,-300, -300,110,-300);
  bezier(-300,110,-300, -500,0,0, 700,0,100, 0,100,400);
  popMatrix();
  */
  drawBall();
}// draw

void moveView()
{
  if(keyEnter){
    if(rotateView < 150){
      rotateX(radians(rotateView)*0.5);
      rotateView++;
    }
  }// pressed enter key

  if(rotateView == 150 && keyEnter){
    cameraX = -15;
    rotateText = 0;
    writeText();
    rotateView++;
  }// write text
  else if(rotateView > 150 && keyEnter)
    writeText();
}// move view

void writeText()
{
  pushMatrix();
  textSize(25);
  rotateX(radians(rotateText));
  fill(00);
  text(s, 500, -450, -100);
  popMatrix();
}// write text

void drawSky()
{
  //draw sun
  pushMatrix();
  //bezier(-1000,500,0, -900,-800,0, 900,-800,0, 1000,500,0);
  float skyT = (sun_speed/1000.0)%1;
  float skyX = bezierPoint(-1000, -900, 900, 1000, skyT);
  float skyY = bezierPoint(500, -800, -800, 500,skyT);
  float skyZ = bezierPoint(0, 0, 0, 0, skyT);
  
  pointLight(255, 255, 255, skyX+500, skyY, -500);
  translate(skyX, skyY, skyZ);
  noStroke();
  fill(255, 131, 0);
  sphere(50);
  popMatrix();
}// draw sky

void drawRain()
{
  //rain
  pushMatrix();
  stroke(255);
  strokeWeight(random(1,3));
  translate(0, -1000, 500);
  rotateY(radians(-45));
  rotate(PI/2.4);
  for(int i = 0; i < 100; i++){
    for(int pos = -500; pos <= 500; pos += 100)
      line(rain_pos[i], i*10, pos, rain_pos[i] + rain_speed[i]*1.5, i*10, pos);
    rain_pos[i] += rain_speed[i];
    rain_pos[i] = rain_pos[i] % width;
  }
  popMatrix();
  
  //rain drop
  pushMatrix();
  noFill();
  ellipseMode(CENTER);
  translate(0, 150, 500);
  rotateX(radians(90));
  for(int i = 0; i < 10; i++){
    ellipse(random(-500,500),random(-1000, 0), 10, 10);
    ellipse(random(-500,500),random(-1000, 0), 20, 20);
  }
  popMatrix();
  
  //lightning
  pushMatrix();
  float light = round(random(1,50));
  float light_pos = round(random(0, 1400));
  translate(0,0,light_pos);
  if(light == 5){
    background(255);
    lightning();
    lightning();
  }
  popMatrix();
}// draw rain

void lightning() {
  pushMatrix();
  translate(0,0,-1000);
  float st = random(-500, 500);
  float end = 800;
  float y = -1000;
  float y2 = -500;

  while (y2 < 500) {
    end = (st-40) + random(80);
    stroke(0);
    strokeWeight(4);
    line(st, y, end, y2);
    y = y2;
    y2 += random(80);
    st = end;

    end = (st-40) + random(80);
    line(st, y, end, y2);
    y = y2;
    y2 += random(80);
    st = end;
  }
  popMatrix();
} // lightning

void drawTennisCourt()
{
  stroke(125);
  //ground
  pushMatrix();
  fill(0, 127, 0);
  translate(0, 600, 0);
  rotateX(radians(90));
  box(900); 
  popMatrix();
  pushMatrix();
  fill(76, 165, 76);
  translate(0, 155, 0); 
  rotateX(radians(90));
  rect(0, 0, 1200, 1200);
  popMatrix();
  
  //draw field
  pushMatrix();
  noFill();
  strokeWeight(2);
  stroke(255);
  translate(0, 150, 0);
  rotateX(radians(90));
  rect(-380, 0, 120, 890);
  rect(380, 0, 120, 890);
  rect(0, 345, 640, 200);
  rect(0, -345, 640, 200);
  line(-440, 0, 440, 0); 
  line(0, -245, 0, 245);
  line(0, -430, 0, -445);
  line(0, 430, 0, 445);
  popMatrix();

  //draw net
  pushMatrix();
  stroke(0);
  translate(0, 110, 0);
  rotateX(radians(90));
  translate(-500, 0);
  drawCylinder(20, 5, 5, 90);
  translate(1000, 0);
  drawCylinder(20, 5, 5, 90);
  popMatrix();
  pushMatrix();
  stroke(255);
  fill(0);
  rect(0, 70, 1000, 10);
  stroke(0);
  strokeWeight(0.5);
  for(int i = 80; i < 150; i += 5)
    line(-500, i, 500, i);
  for(int i = -500; i < 500; i += 7)
    line(i, 80, i, 150);
  popMatrix();
} // draw tennis court

void drawRacket()
{
  noFill();
  stroke(255,0,0);
  strokeWeight(3);
 
  rotateZ(radians(-45));
  ellipse(0, 0, 70, 50);
  
  strokeWeight(1.5);
  stroke(0);
  for(int i = -20; i < 30; i += 10){
    line(i, 20, i, -20);
    line(25, i, -25, i);
  }
  
  stroke(255,0,0);
  translate(-60,0,0);
  rotateY(radians(90));
  drawCylinder(20, 5, 5, 50);
}// draw racket

void drawBall()
{
  pushMatrix();
  noFill();
  stroke(229, 229, 0);
  sphereDetail(20);
  float t = (ball_speed/500.0)%1;
  
  if(!ball_change){
    if(ball_speed > last_sec+495){
      last_sec = ball_speed;
      ball_change = true;
    }
    float x = bezierPoint(0, 500, 300, -300, t);
    float y = bezierPoint(100, -250, -300, 110,t);
    float z = bezierPoint(400, 350, -300, -300, t);
    
    if(t > 0.8 && t < 0.90){
      x = random(100, 150);
    }// crazy ball
    
    translate(x, y, z);
  } // ball 1
  else{
    pushMatrix();
    stroke(50, 50, 255);
    strokeWeight(4);
        //bezier(0,100,400, 500,-250,350, 300,-300,-300, -300,110,-300);
    bezier(-300,110,-300, -500,0,0, 700,0,100, 0,100,400);
    popMatrix();
   
    if(ball_speed > last_sec+500){
      last_sec = ball_speed;
      ball_change = false;
    }
    
    float x = bezierPoint(-300, -500, 700, 0, t);
    float y = bezierPoint(100, 0, 0, 110,t);
    float z = bezierPoint(-300, 0, 100, 400, t);

    translate(x, y, z);
  } // ball 2
  
  stroke(229, 229, 0);
  sphere(10);
  popMatrix();
}// draw ball

void drawCylinder(int sides, float r1, float r2, float h)
{
    float angle = 360 / sides;
    float halfHeight = h / 2;
    // top
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos(radians(i * angle)) * r1;
        float y = sin(radians(i * angle)) * r1;
        vertex( x, y, -halfHeight);
    }
    endShape(CLOSE);
    // bottom
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos(radians(i * angle)) * r2;
        float y = sin(radians(i * angle)) * r2;
        vertex( x, y, halfHeight);
    }
    endShape(CLOSE);
    // draw body
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < sides + 1; i++) {
        float x1 = cos(radians(i * angle))  * r1;
        float y1 = sin(radians(i * angle)) * r1;
        float x2 = cos(radians(i * angle)) * r2;
        float y2 = sin(radians(i * angle)) * r2;
        vertex( x1, y1, -halfHeight);
        vertex( x2, y2, halfHeight);
    }
    endShape(CLOSE);
}// draw cylinder

void keyPressed()
{
  if(key == 10){
    keyEnter = true;
  }
  if(keyEnter){
    if(key == 'r'){
      keyR_count++;
      if(keyR_count == 1)
        keyR = true;
      else if(keyR_count == 2){
        keyR = false;
        keyR_count = 0;    
      }
    } //rain
    if(key == '1'){
      cameraX = -15;
      cameraY = 0;
      cameraZ = -350;
      rotateText = 0;
      key4 = false;
    } // 1st view
    if(key == '2'){
      cameraX = 0;
      cameraY = 60;  
      cameraZ = -350;
      rotateText = 0;
      key4 = false;
    } // 2nd view
    if(key == '3'){
      cameraX = 0;
      cameraY = 0;   
      cameraZ = -100;
      rotateText = 0;
      key4 = false;
    } // 3nd view
    if(key == '4'){
      cameraX = 0;
      cameraY = 180;   
      cameraZ = -100;
      rotateText = 0;
      key4 = false;
    }
    if(key == '5'){
      cameraX = -15;  
      cameraZ = -350;
      rotateText = 0;
      key4 = true;
    } // free view
    if(key == '6'){
      cameraX = -90;
      cameraY = 0;   
      cameraZ = -350;
      rotateText = 90;
      key4 = false;
      keyEnter = false;
      rotateView = 0;
    } // top view
  }// enterkey pressed
}// key pressed

