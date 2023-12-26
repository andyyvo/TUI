/* 
 * Serial RGB LED with Hex Code Input
 * ---------------
 * Serial commands control the brightness of R,G,B LEDs 
 *
 * Command structure is "<RR><GG><BB>", where each <..>
 * is a hex value that corresponds to its respective
 * RGB value.
 *
 * E.g. FFFFFF = R255 G255 B255
 *
 * Created 06 September 2023
 * By Andy Vo
 * INFO C262
 */

char serInString[100];  // array that will hold the different bytes of the string. 100=100characters;
                        // -> you must state how long the array will be else it won't work properly

char hexVal;  // input hex string

int redVal;   // red color output
int greenVal; // green color output
int blueVal;  // blue color output

int redPin   = 9;   // Red LED,   connected to digital pin 9
int greenPin = 10;  // Green LED, connected to digital pin 10
int bluePin  = 11;  // Blue LED,  connected to digital pin 11

void setup() {
  pinMode(redPin,   OUTPUT);   // sets the pins as output
  pinMode(greenPin, OUTPUT);   
  pinMode(bluePin,  OUTPUT);
  Serial.begin(9600);
  analogWrite(redPin,   64);   // set them all to quarter brightness
  analogWrite(greenPin, 64);   // set them all to quarter brightness
  analogWrite(bluePin,  64);   // set them all to quarter brightness
  Serial.println("enter color command (e.g. '7F7F7F'):");  
}

void loop () {
  // clear the string
  memset(serInString, 0, 100);
  //read the serial port and create a string out of what you read
  readSerialString(serInString);
    
  colorCode = serInString[0];
  if( colorCode == 'r' || colorCode == 'g' || colorCode == 'b' ) {
    colorVal = atoi(serInString+1);
    Serial.print("setting color ");
    Serial.print(colorCode);
    Serial.print(" to ");
    Serial.print(colorVal);
    Serial.println();
    serInString[0] = 0;                   // indicates we've used this string
    if(colorCode == 'r') 
      analogWrite(redPin, colorVal);
    else if(colorCode == 'g')
      analogWrite(greenPin, colorVal);
    else if(colorCode == 'b')
      analogWrite(bluePin, colorVal);
  }
  
  delay(100);  // wait a bit, for serial data
}

//read a string from the serial and store it in an array
//you must supply the array variable
void readSerialString (char *strArray) {
  int i = 0;
  if(!Serial.available()) {
    return;
  }
  while (Serial.available()) {
    strArray[i] = Serial.read();
    i++;
  }
}