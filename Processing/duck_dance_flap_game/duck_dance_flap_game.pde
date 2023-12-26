// inspo : https://openprocessing.org/sketch/1934021

int grassColor;
int duckColor;
int beakColor;

void setup() {
  //size(1920, 1080, P3D);
  size(1440, 810, P3D);
  //size(1280, 720, P3D);
  //size(960, 540, P3D);
  //size(640, 640, P3D);
  grassColor = color(#69B867);
  duckColor = color(#FFFCA8);
  beakColor = color(#F9CB87);
}

void draw() {
  ortho(-width/2, width/2, -height/2, height/2, 0.1, 2000);
  background(grassColor);
  // move origin of duck ring to the center
  translate(width/2, height/2);
  noStroke();
  
  rotateX(-PI/4);
  
  float r = 200;
  float targetSize = 3*r;
  scale(min(width, height) / targetSize);
  
  float t = millis();
  
  // How much to offset each successive duck's walk cycle by,
  // in milliseconds. This is a big prime number so that it's
  // unlikely any two ducks will be at the same point in their
  // walk cycle.
  int tStagger = 5351;
  
  // How long it takes the ducks to walk a whole circle, in ms
  // speed of spin (1 FAST, 50 STATIC)
  int spinFactor = 20;
  int duckPeriod = spinFactor * 1000;
  float duckSpeed = TWO_PI / duckPeriod;
  
  int numDucks = 20;
  rotateY(t * duckSpeed);
  for (int i = 0; i < numDucks; i++) {
    pushMatrix();
    rotateY(i/(float)numDucks * TWO_PI);
    translate(r, 0, 0);
    duck(t + i*tStagger);
    popMatrix();
  }
}

void cylinder(float radius, float height) {
  int sides = 30;
  float[] angle = new float[sides + 1];
  float[] x = new float[sides + 1];
  float[] z = new float[sides + 1];

  for (int i = 0; i < angle.length; i++) {
    angle[i] = TWO_PI / sides * i;
    x[i] = cos(angle[i]) * radius;
    z[i] = sin(angle[i]) * radius;
  }

  // Draw the cylinder
  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i < x.length; i++) {
    vertex(x[i], 0, z[i]);
    vertex(x[i], height, z[i]);
  }
  endShape();
}

void duck(float t) {
  pushMatrix();
  fill(duckColor);
  
  // body
  pushMatrix();
  translate(
    sin(t*0.02/3)*5,
    sin(t*0.02)*3,
    0
  );
  sphere(10);
  
  // Legs
  fill(beakColor);
  for (int side : new int[]{-1, 1}) {
    pushMatrix();
    scale(side, 1, 1);
    rotateX(PI*0.1);
    translate(3, 7, 0);
    rotateX(sin(t*0.02 + side*0.5*PI)*PI*0.2);
    float legHeight = 8;
    translate(0, legHeight/2, 0);
    cylinder(1, legHeight);
    translate(0, legHeight, 0); // feet placement
    rotateX(PI/2);
    scale(1.5);
    triangle(0, 3, -2, -5, 2, -5);
    popMatrix();
  }
  
  // tail
  fill(duckColor);
  rotateX(-PI*0.1);
  translate(0, 0, 4);
  sphere(9);
  translate(0, 0, 3);
  rotateX(PI*0.1);
  scale(1, 0.8, 1.5);
  sphere(9);
  popMatrix();
  
  // head
  pushMatrix();
  // keep translate in sync with body
  translate(
    sin(t*0.02/3 - 200)*5,
    -12 + sin(t*0.02 - 200)*3,
    -8
  );
  fill(duckColor);
  sphere(8);
  
  // eyest
  fill(0);
  translate(0, 0, -8);
  for (int side : new int[]{-1, 1}) {
    pushMatrix();
    translate(side * 3, 0, 0);
    sphere(1);
    popMatrix();
  }
  popMatrix();
  
  // beak
  fill(beakColor);
  //translate(0, -8, -14);
  translate(
    sin(t*0.02/3 - 200)*5,
    -10 + sin(t*0.02 - 200)*3,
    -14
  );
  scale(1.5, 0.4, 3);
  sphere(3);
  
  popMatrix();
}
