int pitchPin = A0;
int pitchVal;
int speakerPin = 3;
int soundVal;

// try changing the noteDuration to hear how that changes the sound
int noteDuration = 50; // ms

void setup(){
  pinMode(speakerPin, OUTPUT);
  Serial.begin(9600);
}

void loop(){
  pitchVal = analogRead(pitchPin);
  pitchVal = map(pitchVal, 0, 1023, 0, 1000);
  Serial.println(pitchVal);

  // play the tone
  soundVal = pitchVal * 3;
  tone(speakerPin, soundVal, noteDuration); 

  // to distinguish the notes, set a minimum time between them.
  // the note's duration + 30% seems to work well:
  // try changing the pauseBetweenNotes to hear how that changes the sound
  int pauseBetweenNotes = noteDuration * 1.3;
  delay(pauseBetweenNotes);
  // stop the tone playing:
  noTone(8);

  delay(50);
}