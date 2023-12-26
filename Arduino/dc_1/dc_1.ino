/* DC Motor with potentiometer control
 * Theory and Practice of Tangible User Interfaces
 * Fall 2021
 */
 
int motorPin = 9;
int potPin = A0;

int potVal = 0;
int motorCtrlVal = 0;

void setup() {
  pinMode(potPin, INPUT);
  pinMode(motorPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  potVal = analogRead(potPin);
  Serial.print("potVal: ");Serial.println(potVal);
  motorCtrlVal = map(potVal, 0, 1024, 0, 255);
  Serial.print("motorCtrlVal: ");
  Serial.println(motorCtrlVal);
  analogWrite(motorPin, motorCtrlVal);
}
