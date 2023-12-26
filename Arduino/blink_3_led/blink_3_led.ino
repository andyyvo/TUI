/*
* Code for cross-fading 3 LEDs, red, green and blue, or one tri-color LED, using PWM
* The program cross-fades slowly from red to green, green to blue, and blue to red
* The debugging code assumes Arduino 0004, as it uses the new Serial.begin()-style functions
* Clay Shirky <clay.shirky@nyu.edu>
* 
* 09/08/2021 - Light modifications. Zeke Medley <zekemedley@berkeley.edu>
*/

// Red LED, connected to digital pin 9
const int redPin   = 9;
// Green LED, connected to digital pin 10
const int greenPin = 10;
// Blue LED,  connected to digital pin 11
const int bluePin  = 11;

// Variables to store the values to send to the pins.
// Initial values are Red full, Green and Blue off.
int redVal   = 255; 
int greenVal = 1;   
int blueVal  = 1;

// Tracks how many 'steps' into our fade we are.
unsigned i = 0;
// The number of ms to wait between steps in the fade. Smaller values will result
// In a faster fade.
const int wait = 5;
// Determines if debug information should be printed to the serial monitor.
const bool DEBUG = false;

void setup() {
  pinMode(redPin,   OUTPUT);
  pinMode(greenPin, OUTPUT);   
  pinMode(bluePin,  OUTPUT); 

  // If we are debugging open a serial connection.
  if (DEBUG) {
    Serial.begin(9600);
  }
}

void loop() {
  i += 1;
  if (i < 255) {
    redVal   -= 1; // Red down
    greenVal += 1; // Green up
    blueVal   = 1; // Blue low
  } else if (i < 509) {
    redVal    = 1; // Red low
    greenVal -= 1; // Green down
    blueVal  += 1; // Blue up
  } else if (i < 763) {
    redVal  += 1; // Red up
    greenVal = 1; // Green low
    blueVal -= 1; // Blue down
  } else {
    i = 0;
  }  

  analogWrite(redPin,   redVal);
  analogWrite(greenPin, greenVal); 
  analogWrite(bluePin,  blueVal);  

  if (DEBUG) {
    // Print debug information ~10 loops.
    // `%` here means 'modulo'.
    if (i % 10 == 0)
    {
      Serial.print(i);       // Serial commands in 0004 style
      Serial.print("\t");    // Print a tab
      Serial.print("R:");    // Indicate that output is red value
      Serial.print(redVal);  // Print red value
      Serial.print("\t");    // Print a tab
      Serial.print("G:");    // Repeat for green and blue...
      Serial.print(greenVal);
      Serial.print("\t");    
      Serial.print("B:");    
      Serial.println(blueVal); // println, to end with a new line
    }
  }

  delay(wait); // Pause for 'wait' milliseconds before resuming the loop
}