/* Theremin
 * --------
 *
 * Created 24 October 2006
 * copyleft 2006 Tod E. Kurt tod@todbot.com
 * http://todbot.com/
 *
 * Adapted by Noura Howell, 2 October 2017
 * http://nourahowell.com/
 */

int pitchPin = 0;
int tempoPin = 1;
int speakerPin = 3;

int pitchVal = 0;
int soundVal;
int tempoVal = 0;
int speedVal; // ms

// try changing the noteDuration to hear how that changes the sound
int noteDuration = 500; // ms

void setup() {
  pinMode(speakerPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {  
  // read the value from the sensor
  pitchVal = analogRead(pitchPin);
  Serial.print("pitchVal: ");Serial.println(pitchVal);
  // tempoVal = analogRead(tempoPin);
  // Serial.print("tempoVal: ");Serial.println(tempoVal);
  
  // decide what tone to play based on the sensor value
  // try changing this calculation to hear how that changes the sound
  soundVal = pitchVal * 3;
  // speedVal = int(map(tempoVal, 0, 1023, 0, 1000));
   
  // play the tone
  tone(speakerPin, soundVal, noteDuration); 
  // to distinguish the notes, set a minimum time between them.
  // the note's duration + 30% seems to work well:
  // try changing the pauseBetweenNotes to hear how that changes the sound
  int pauseBetweenNotes = noteDuration * 1.3;
  delay(pauseBetweenNotes);
  // stop the tone playing:
  noTone(8);
}