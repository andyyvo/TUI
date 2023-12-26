// https://pimylifeup.com/arduino-force-sensing-resistor/

int pressureAnalogPin = 0; 
int pressureReading; 

int noPressure = 5; 
int lightPressure = 100;
int mediumPressure = 200;

void setup(void) {
  Serial.begin(9600);
}

void loop(void) {
  pressureReading = analogRead(pressureAnalogPin);

  Serial.print("Pressure Pad Reading = ");
  Serial.println(pressureReading);

  if (pressureReading < noPressure) {
    Serial.println(" - No pressure");
  } else if (pressureReading < lightPressure) {
    Serial.println(" - Light Pressure");
  } else if (pressureReading < mediumPressure) {
    Serial.println(" - Medium Pressure");
  } else{
    Serial.println(" - High Pressure");
  }
  delay(1000);
}