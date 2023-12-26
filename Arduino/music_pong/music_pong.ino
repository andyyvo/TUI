// initialization of values
// int pPin1 = A0;
// int pVal1 = 0;
int pot = 4;
int vol = 0;

float mapfloat(float x, float in_min, float in_max, float out_min, float out_max)
{
 return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  // pVal1 = analogRead(pPin1); // read photocell val
  // Serial.println(pVal1); // send to MaxMSP

  float potVal = analogRead(pot);
  vol = map(potVal, 0, 1023, 0, 100);
  float volFloat = vol/100.0;
  Serial.println(volFloat);
  
  delay(100);
}
