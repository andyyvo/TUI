#include <CapacitiveSensor.h>
/*
 * Makes the built in LED next to pin 13 blink when the capacitive sensor
 * reaches the threshold value
 * Noura Howell 2018
 */
const int redPin   = 4;
CapacitiveSensor   cs_4_2 = CapacitiveSensor(4,2);        // 10M resistor between pins 4 & 2, pin 2 is sensor pin, add a wire and or foil if desired

// You may need to adjust this value to work for your particular sensor.
// Use the capacitive sensing test sketch to get a sense of the range of values
// coming from your capacitive sensor.
int threshold = 10000;

void setup()                    
{
  cs_4_2.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(redPin, OUTPUT);
  Serial.begin(9600);
}

void loop()                    
{
  long capVal =  cs_4_2.capacitiveSensor(30);
  Serial.println(capVal);

  // if (capVal > threshold) {
  //   digitalWrite(LED_BUILTIN, HIGH);
  //   digitalWrite(redPin, HIGH);
  // } else {
  //   digitalWrite(LED_BUILTIN, LOW);
  //   digitalWrite(redPin, LOW);
  // }

  delay(2);
}