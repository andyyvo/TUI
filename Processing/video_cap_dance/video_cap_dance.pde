import processing.video.*;

ArrayList<Particle> particles;
PGraphics pg;
PImage img;
Capture cam;
PImage prevFrame;
float motionX = 0;
float motionY = 0;
float threshold = 50;

void setup() {
  size(600, 600, P2D);
  pg = createGraphics(width, height, P2D);
  img = loadImage("texture.png"); // Make sure you have this texture image in your sketch folder
  particles = new ArrayList<Particle>();
  for (int i = 0; i < 10000; i++) {
    particles.add(new Particle(new PVector(random(width), random(height))));
  }

  // Webcam setup
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available.");
    exit();
  } else {
    cam = new Capture(this, cameras[0]);
    cam.start();
  }
  prevFrame = createImage(cam.width, cam.height, RGB);
}

void draw() {
  if (cam.available() == true) {
    cam.read();
    detectMotion();
  }

  pg.beginDraw();
  pg.background(0);
  for (Particle p : particles) {
    p.update(new PVector(motionX, motionY)); // Update particles with motion data
    p.display();
  }
  pg.endDraw();

  image(pg, 0, 0);
  noStroke();
  fill(255);
  text("FPS: " + frameRate, 10, 20);
}
