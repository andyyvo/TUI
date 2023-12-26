/* 
 * Serial RGB LED with Hex Code Input
 * ---------------
 * Serial commands control the brightness of R,G,B LEDs 
 *
 * Command structure is "r...rrrrrrrrrr", where each input
 * is an r | g | b -only string where each instance of a letter
 * indicates a 10% brightness percentage.
 * Ex: r = 10% red = 25.5; ggggggg = 70% green = 178.5; bbb = 30% blue = 76.5
 *
 * Limitations:
 * - Cannot represent 0% brightness since entering no letter does not specify color
 * - This is because I will be using 25.5 as the value to represent each letter
 *
 * Created 06 September 2023
 * By Andy Vo
 * INFO C262
 *
 * Resources:
 * https://cplusplus.com/reference/cstdio/sscanf/
 * https://stackoverflow.com/questions/3420629/what-is-the-difference-between-sscanf-or-atoi-to-convert-a-string-to-an-integer
 * https://cplusplus.com/reference/cstring/strncpy/
 */

char serInString[100];              // array that will hold the different bytes of the string

int numChars;                       // number of chars in serInString
char colorCode;                     // which color?
float colorVal;                     // color brightness?
float BRIGHTNESS_MULTIPLIER = 25.5; // brightness multiplier constant

int redPin   = 9;   // Red LED,   connected to digital pin 9
int greenPin = 10;  // Green LED, connected to digital pin 10
int bluePin  = 11;  // Blue LED,  connected to digital pin 11

void setup() {
  // sets the pins as output
  pinMode(redPin,   OUTPUT);
  pinMode(greenPin, OUTPUT);   
  pinMode(bluePin,  OUTPUT);

  Serial.begin(9600);

  // set LEDs to 0% brightness
  analogWrite(redPin,   0);
  analogWrite(greenPin, 0);
  analogWrite(bluePin,  0);

  Serial.println("enter color command (e.g. 'rrr'):");  
}

void loop () {
  // clear the string
  memset(serInString, 0, 100);

  //read the serial port and create a string out of what you read
  readSerialString(serInString);

  numChars = charArrLen(serInString);

  colorCode = serInString[0];
  colorVal = (int)BRIGHTNESS_MULTIPLIER * numChars;

  if (colorVal > 255) {
    colorVal = 255;
  } else if (colorVal < 0) {
    colorVal = 0;
  }

  if (colorCode == 'r') {
    Serial.print(">>> red val: ");
    Serial.println(colorVal);
    Serial.print("Setting the red LED brightness to ");
    Serial.print(numChars*10);
    Serial.println("%");
    analogWrite(redPin, colorVal);

  } else if (colorCode == 'g') {
    Serial.print(">>> green val: ");
    Serial.println(colorVal);
    Serial.print("Setting the green LED brightness to ");
    Serial.print(numChars*10);
    Serial.println("%");
    analogWrite(greenPin, colorVal);

  } else if (colorCode == 'b') {
    Serial.print(">>> blue val: ");
    Serial.println(colorVal);
    Serial.print("Setting the blue LED brightness to ");
    Serial.print(numChars*10);
    Serial.println("%");
    analogWrite(bluePin, colorVal);
  }
  
  delay(1000);  // wait a bit, for serial data
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

// get length of input
int charArrLen(char* charArr) {
  int iter = 0;
  while (charArr[iter] != '\0' && ((charArr[iter] == 'r') || (charArr[iter] == 'g') || (charArr[iter] == 'b'))) {
    iter++;
  }
  return iter;
}
