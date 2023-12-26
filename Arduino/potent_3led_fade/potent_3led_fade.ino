int RED_PIN = 3;  // the PWM pin the LED is attached to
int BLU_PIN = 5;  // the PWM pin the LED is attached to
int GRN_PIN = 9;  // the PWM pin the LED is attached to

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);

  // declare respective LED pin to be an output:
  pinMode(RED_PIN, OUTPUT);
  pinMode(BLU_PIN, OUTPUT);
  pinMode(GRN_PIN, OUTPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  // reads the input on analog pin A0-2 (value between 0 and 1023)
  int analogValue1 = analogRead(A0);
  int analogValue2 = analogRead(A1);
  int analogValue3 = analogRead(A2);

  // scales it to brightness (value between 0 and 255)
  int brightness1 = map(analogValue1, 0, 1023, 0, 255);
  int brightness2 = map(analogValue2, 0, 1023, 0, 255);
  int brightness3 = map(analogValue3, 0, 1023, 0, 255);

  // sets the brightness LED that connects
  analogWrite(RED_PIN, brightness2);
  analogWrite(BLU_PIN, brightness3);
  analogWrite(GRN_PIN, brightness1);

  delay(100);
}