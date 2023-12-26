/* Servo Sweep

 just makes the servo sweep back and forth repeatedly

 by Scott Fitzgerald
 http://www.arduino.cc/en/Tutorial/Sweep
*/

#include <Servo.h>

int servoPin1 = 7; // pin for the servo motor
int servoPin2 = 8; // pin for the servo motor

Servo servo1;  // create servo object to control a servo
Servo servo2;  // create servo object to control a servo
// twelve servo objects can be created on most boards

int pos = 0;    // variable to store the servo position

void setup() {
  servo1.attach(servoPin1); // attaches the servo on pin servoPin to the servo object
  servo2.attach(servoPin2); // attaches the servo on pin servoPin to the servo object
}

void loop() {
  // servo1.write(0); // comment out for reset
  // servo2.write(0);
  for (pos = 0; pos <= 180; pos += 1) { // goes from 0 degrees to 90 degrees
    // in steps of 1 degree
    servo1.write(pos);              // tell servo to go to position in variable 'pos'
    servo2.write(abs(pos-180));              // tell servo to go to position in variable 'pos'
    delay(15);                       // waits 15ms for the servo to reach the position
  }
  for (pos = 180; pos >= 0; pos -= 1) { // goes from 90 degrees to 0 degrees
    servo1.write(pos);              // tell servo to go to position in variable 'pos'
    servo2.write(abs(pos-180));              // tell servo to go to position in variable 'pos'
    delay(15);                       // waits 15ms for the servo to reach the position
  }
}