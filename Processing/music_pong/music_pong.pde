import processing.sound.*;
import cc.arduino.*;
import processing.serial.*;

SoundFile korok;
SoundFile xyla;
SoundFile coin;
Arduino arduino;

//int ledpin = 11;
int photopin_g = 0;
int photopin_p = 1;
int photopin_v = 2;
int potpin = 5;
float volume = 0;
int threshold = 700;
int threshold_k = 850;
int threshold_c = 800;


void setup(){
  size(800, 600);
  
  arduino = new Arduino(this, "/dev/tty.usbmodem11201", 57600);
  korok = new SoundFile(this, "c_piano.wav");
  xyla = new SoundFile(this, "d_piano.wav");
  coin = new SoundFile(this, "e_piano.wav");
  arduino.pinMode(photopin_g, Arduino.INPUT);
  arduino.pinMode(photopin_p, Arduino.INPUT);
  arduino.pinMode(photopin_v, Arduino.INPUT);
}

void draw() {
  background(0, 0, 0);
  int photoValkorok = arduino.analogRead(photopin_g);
  int photoValxyla = arduino.analogRead(photopin_p);
  int photoValcoin = arduino.analogRead(photopin_v);
  int potVal = arduino.analogRead(potpin);
  //println(potVal);
  volume = map(potVal, 0, 1023, 0, 100);
  float volumeF = volume/100.0;
  println(volumeF);
  fill(250, 232, 40);
  ellipse(width/4, height/4, 100000/photoValkorok, 100000/photoValkorok);
  fill(250, 145, 40);
  ellipse((width/2), (height/2), 100000/photoValxyla, 100000/photoValxyla);
  fill(250, 78, 40);
  ellipse((width*3/4), (height*3/4), 100000/photoValcoin, 100000/photoValcoin);
  
  println(photoValkorok);
  if (photoValkorok < threshold_k) {
    if (!korok.isPlaying()) {
      korok.amp(volumeF);
      korok.play();
    }
  }
  //print(photoValxyla);
  if (photoValxyla < threshold) {
    if (!xyla.isPlaying()) {
      xyla.amp(volumeF - 0.9);
       xyla.play();
    }
  }
  //println(photoValcoin);
  if (photoValcoin < threshold_c) {
    if (!coin.isPlaying()) {
      coin.amp(volumeF);
      coin.play();
    }
  }
  
}
