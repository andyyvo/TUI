int n = 1000; // number of dots 

float[] m = new float[n]; // make a new list of floating points 
float[] x = new float[n];
float[] y = new float[n];
float[] vx = new float[n];
float[] vy = new float[n];
float[] redchannel = new float[n]; 
float[] bluechannel = new float[n];
float[] greenchannel = new float[n];
float[] shape = new float[n];
float angle = 0;

import processing.serial.*;

Serial myPort;  // Create object from Serial class
static String val;    // Data received from the serial port
int sensorVal = 0;

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

void setup() {
  fullScreen();
  fill(0,10);
  reset();// running the reset when you click. 10000 random values being plugged in 
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[6], 9600);
}

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

void draw() {
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.readStringUntil('\n'); 
  try {
   sensorVal = Integer.valueOf(val.trim());
  }
  catch(Exception e) {
  ;
  }
  println(sensorVal); // read it and store it in vals!
  }  
  noStroke();
  fill(0,30);
  rect(0, 0, width, height); //  black background 

  for (int i = 0; i < n; i++) { // runs the loop 10,000 times
    //float dx = mouseX - x[i]; // distance from the mouse 
    //float dx = random(1000) - x[i]; // rng x axis
    float dx = sin(angle)*500 - x[i] + 500; // rng x axis
    float dy = sensorVal - y[i];

    float d = sqrt(dx*dx + dy*dy); // calculating the distance between the points and pot 
    if (d < 1) d = 1; 

    float f = cos(d * 0.06) * m[i] / d*2; // decides if it gets closer or further from pot 

    vx[i] = vx[i] * 0.4 - f * dx; // changing the velocity so it moves towards the ring 
    vy[i] = vy[i] * 0.2 - f * dy;
  }

  for (int i = 0; i < n; i++) {
    x[i] += vx[i];
    y[i] += vy[i];

    if (x[i] < 0) x[i] = width;
    else if (x[i] > width) x[i] = 0;

    if (y[i] < 0) y[i] = height;
    else if (y[i] > height) y[i] = 0;

    if (m[i] < 0) fill(bluechannel[i], greenchannel[i] , 255);
    else fill(255, bluechannel[i],redchannel[i]);

      if (shape[i] > 2) fill(bluechannel[i], greenchannel[i] , 255);
    else fill(255, bluechannel[i],redchannel[i]);



    if (shape[i] > 2)  rect(x[i], y[i],10,10);
    else if (shape[i] > 1 && shape[i] <=2) rect(x[i],y[i],2,2);
    else ellipse(x[i], y[i],10,10);
  }
  
  angle += 0.02;
}

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

void reset() { // counter that counts up to n 
  for (int i = 0; i < n; i++) { // i = 0, i < 10,0000, i++ what to do after each loop. 
    m[i] = randomGaussian() * 8; // gaussian distribution is a bell curve. Distribution of the mass 
    x[i] = random(width);
    y[i] = random(height);
    bluechannel[i] = random(255);
    redchannel[i] = random(255);
    greenchannel[i] = random(255); 
    shape [i] = random(0,3); 
  }
}

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

void mousePressed() {
  reset();
}
