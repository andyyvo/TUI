/* Sound Serial (aka Keyboard Serial)
 * ------------
 * Program to play tones depending on input from the serial port.
 *
 * Noura Howell, 2 October 2017
 * http://nourahowell.com/
 */

#include "pitches.h"

int speakerPin = 8;

// the keyboard input to specify notes
char noteNames[] = { 'c', 'd', 'e', 'f', 'g', 'a', 'b', 'C' };

// the corresponding notes are defined in pitches.h
unsigned int tones[] = { NOTE_C4, NOTE_D4, NOTE_E4, NOTE_F4, NOTE_G4, NOTE_A4, NOTE_B4, NOTE_C5 };

int noteDuration = 100; // ms

// the note the user wants to play that we read from serial
char serNote;

void setup() {
  pinMode(speakerPin, OUTPUT);
  Serial.begin(9600);
  Serial.println("enter a note to play (e.g., 'c') :");
}

void loop() {
  while ( Serial.available() ) {
    // hopefully this char matches an element in noteNames
    serNote = Serial.read();
    Serial.print("We just got some input from serial: ");
    Serial.println(serNote);
    
    // we'll check every element of noteNames to try to find a match
    // note that 8 is a 'magic' number for the length of noteNames array
    for (int i = 0; i < 8; i++) {
      if ( serNote == noteNames[i] ) { // found a match
        Serial.print(serNote);
        Serial.println(" is a note we can play.");
        
        // play the note
        tone(speakerPin, tones[i], noteDuration); 
        // to distinguish the notes, set a minimum time between them.
        // the note's duration + 30% seems to work well:
        int pauseBetweenNotes = noteDuration * 1.3;
        delay(pauseBetweenNotes);
        // stop the tone playing:
        noTone(8);
      } 
    }
  }
}