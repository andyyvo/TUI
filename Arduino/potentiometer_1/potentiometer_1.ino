const int analogPin = A0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  int val = analogRead(analogPin);
  Serial.println(val);
}