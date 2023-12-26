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

// Change this pin number to match where you actually have an LED in your
// circuit
int ledPin = 9;

// Change this pin number to match where you actually have a pot in your
// circuit. Note that pin 0 is the same as pin A0, pin 1 is same as A1, etc.
int potPin = 0;

void setup() {
  size(500, 500);

  // Prints out the available serial ports.
  println(Arduino.list());
  
  // Modify this line, by changing the "0" to the index of the serial
  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  arduino = new Arduino(this, Arduino.list()[6], 57600);
  
  // Alternatively, use the name of the serial port corresponding to your
  // Arduino (in double-quotes), as in the following line.
  //arduino = new Arduino(this, "/dev/tty.usbmodem1411", 57600);
  
  arduino.pinMode(ledPin, Arduino.OUTPUT);
}

void draw() {  
  // We can control the Arduino from Processing
  int potVal = arduino.analogRead(potPin);
  int ledBrightness = int(map(potVal, 0, 1023, 0, 255));
  arduino.analogWrite(ledPin, ledBrightness);
  
  // We can also draw to the Processing window
  // setting the background to black (red = 0, green = 0, blue = 0)
  background(0,0,0); 
  // pick up the white paintbrush (red = 255, green = 255, blue = 255)
  // the next shape we draw will have white color fill
  fill(255, 255, 255);
  // Draw a circle at the center of the window, whose size changes with the potVal
  ellipse(width/2, height/2, potVal/3, potVal/3);
}
