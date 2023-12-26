/*
arduino_input

Demonstrates the reading of digital and analog pins of an Arduino board
running the StandardFirmata firmware.

To use:
* Using the Arduino software, upload the StandardFirmata example (located
  in Examples > Firmata > StandardFirmata) to your Arduino board.
* Run this sketch and look at the list of serial ports printed in the
  message area below. Note the index of the port corresponding to your
  Arduino board (the numbering starts at 0).  (Unless your Arduino board
  happens to be at index 0 in the list, the sketch probably won't work.
  Stop it and proceed with the instructions.)
* Modify the "arduino = new Arduino(...)" line below, changing the number
  in Arduino.list()[0] to the number corresponding to the serial port of
  your Arduino board.  Alternatively, you can replace Arduino.list()[0]
  with the name of the serial port, in double quotes, e.g. "COM5" on Windows
  or "/dev/tty.usbmodem621" on Mac.
* Run this sketch. The squares show the values of the digital inputs (HIGH
  pins are filled, LOW pins are not). The circles show the values of the
  analog inputs (the bigger the circle, the higher the reading on the
  corresponding analog input pin). The pins are laid out as if the Arduino
  were held with the logo upright (i.e. pin 13 is at the upper left). Note
  that the readings from unconnected pins will fluctuate randomly. 
  
For more information, see: http://playground.arduino.cc/Interfacing/Processing
*/

import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

int BLUE_PIN = 9;
int fsrPin = 0;
int potPin = 1;

void setup() {
  size(640, 360, P3D);
  noStroke();

  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[6], 57600);

  arduino.pinMode(BLUE_PIN, Arduino.OUTPUT);
}

void draw() {  
  lights();
  background(0);
  // We can control the Arduino from Processing
  int fsrVal = arduino.analogRead(fsrPin);
  int ledBrightness = int(map(fsrVal, 0, 1023, 0, 255));
  arduino.analogWrite(BLUE_PIN, ledBrightness);
  int potVal = arduino.analogRead(potPin);
  
  float cameraY = height/2.0;
  float fov = (fsrVal/4)/float(width) * PI/2;
  float cameraZ = cameraY / tan(fov / 2.0);
  float aspect = float(width)/float(height);
  perspective(fov, aspect, cameraZ/10.0, cameraZ*10.0);
  
  translate(width/2+30, height/2, 0);
  rotateX(-PI/6 + potVal/float(width) * PI);
  rotateY(PI/3 + fsrVal/float(height) * PI);
  box(45);
  translate(0, 0, -50);
  box(30);
}
