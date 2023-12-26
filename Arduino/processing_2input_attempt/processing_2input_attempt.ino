void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  for (int thisSensor = 0; thisSensor < 2; thisSensor++) {
    int sensorVal = analogRead(thisSensor);
    Serial.print(sensorVal);

    // if first sensor, print comma
    if (thisSensor == 0) {
      Serial.print(',');
    // otherwise new line
    } else {
      Serial.println();
    }
  }
  delay(100);
}
