/*
 * Servo Control by Serial
 * entering 1-9 on the serial monitor will move the servo
 * motor to corresponding positions between 0 and 180 degrees
 * 
 * brief history of edits:
 * 
 * modified for TUI Fall 2017
 *
 * modified for TUI October 2007
 *
 * Created 18 October 2006
 * copyleft 2006 Tod E. Kurt 
 * http://todbot.com/
 *
 * adapted from "http://itp.nyu.edu/physcomp/Labs/Servo"
 */
 
#include <Servo.h>

int servoPin = 7; // pin for the servo motor

Servo myservo;    // create servo object to control a servo
int pos;     // the position we want to move the servo to

int val;          // variable used to store data from serial port

void setup() {
  myservo.attach(servoPin); // attaches the servo on pin servoPin to the servo object
  Serial.begin(9600);
  Serial.println("Servo control program ready");
}

void loop() {
  while (Serial.available()) {
    val = Serial.read();
    if (val >= '1' && val <= '9' ) {
      Serial.println();Serial.println();
      // interpret the user's input to get a number from 1 to 9
      val = val - '0'; // convert val from character variable to number variable
                       // (see http://forum.arduino.cc/index.php?topic=103511.0 for a forum discussing more about this)
      Serial.print("val = ");Serial.println(val);
      
      // calculate the position that we should move the servo to
      pos = map(val, 1, 9, 0, 180); // (see https://www.arduino.cc/en/Reference/Map)    
      Serial.print("pos = ");Serial.println(pos);

      // tell the servo to go to the position
      myservo.write(pos);
      // wait a few milliseconds so we don't overload the servo with too many commands all at once
      delay(15);
    }
  }

}