#include <CapacitiveSensor.h>

/*
 * This sketch outputs the values of two capacitive sensors to the serial monitor.
 */

// Initialize two capacitive sensors
// 10M resistor between pins 4 & 2, pin 2 is sensor pin for the first sensor
// 10M resistor between pins 5 & 3, pin 3 is sensor pin for the second sensor
CapacitiveSensor cs_4_2 = CapacitiveSensor(4,2);
CapacitiveSensor cs_5_3 = CapacitiveSensor(5,3);        
CapacitiveSensor cs_9_8 = CapacitiveSensor(9,8);
CapacitiveSensor cs_13_12 = CapacitiveSensor(13,12);        

void setup() {                 
  cs_4_2.set_CS_AutocaL_Millis(0xFFFFFFFF); // Turn off auto-calibration for the first sensor
  cs_5_3.set_CS_AutocaL_Millis(0xFFFFFFFF); // Turn off auto-calibration for the second sensor
  Serial.begin(9600); // Start serial communication at 9600 baud
}

void loop() {                   
  long sensorValue1 = cs_4_2.capacitiveSensor(30); // Take 30 samples for accuracy from the first sensor
  long sensorValue2 = cs_5_3.capacitiveSensor(30); // Take 30 samples for accuracy from the second sensor
  long sensorValue3 = cs_9_8.capacitiveSensor(30); // Take 30 samples for accuracy from the first sensor
  long sensorValue4 = cs_13_12.capacitiveSensor(30); // Take 30 samples for accuracy from the second sensor

  // Serial.print("Sensor 1: ");
  // Serial.print(sensorValue1); // Print the first sensor value to the Serial Monitor
  // Serial.print("\tSensor 2: ");
  // Serial.println(sensorValue2); // Print the second sensor value to the Serial Monitor

  // JSON is a way to structure data that is easy to work with in
  // Processing.
  // String json;
  // String send;
  int send1 = 0;

  // I assigned a lowercase letter to each touch sensor. 
  // In our case, we had 6 sensors that I named a-f. We read
  // from each sensor and then assemble the JSON from concatenated 
  // strings. The JSON for this example looks like: 
  // {a:1000,b:1,c:1200,d:3000,e:4000,f:2000}
  // json = "{\"blue\":";
  // json = json + sensorValue1;
  // json = json + ",\"green\":";
  // json = json + sensorValue2;
  // json = json + ",\"red\":";
  // json = json + sensorValue3;
  // json = json + ",\"black\":";
  // json = json + sensorValue4;
  // json = json + "}";

  // send = "";
  // send = send + sensorValue1;
  // send = send + ",";
  // send = send + sensorValue2;
  // send = send + ",";
  // send = send + sensorValue3;
  // send = send + ",";
  // send = send + sensorValue4;

  send1 = sensorValue1;

  // This gets printed to Serial, which Processing will read.
  Serial.println(send1);
  Serial.flush();

  delay(100); // Short delay for stability and data readability
}
