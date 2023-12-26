/* 
 * Serial RGB LED with Hex Code Input
 * ---------------
 * Serial commands control the brightness of R,G,B LEDs 
 *
 * Command structure is "<RR><GG><BB>", where each <..>
 * is a hex value that corresponds to its respective
 * RGB value.
 *
 * Code schematic:
 * serial monitor input -> serInString[6] ->
 * redHex, greenHex, blueHex
 *
 * E.g. FFFFFF = R255 G255 B255
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

char serInString[100];  // array that will hold the different bytes of the string

char redHex[3];   // input hex string
char greenHex[3]; // input hex string
char blueHex[3];  // input hex string

int redVal;   // red color output
int greenVal; // green color output
int blueVal;  // blue color output

int redPin   = 9;   // Red LED,   connected to digital pin 9
int greenPin = 10;  // Green LED, connected to digital pin 10
int bluePin  = 11;  // Blue LED,  connected to digital pin 11

void setup() {
  // sets the pins as output
  pinMode(redPin,   OUTPUT);
  pinMode(greenPin, OUTPUT);   
  pinMode(bluePin,  OUTPUT);

  Serial.begin(9600);
  
  // set all LEDs to 0% brightness
  analogWrite(redPin,   0);
  analogWrite(greenPin, 0);
  analogWrite(bluePin,  0);

  Serial.println("enter color command (e.g. 'ffffff'):");  
}

void loop () {
  // clear the string
  memset(serInString, 0, 6);

  //read the serial port and create a string out of what you read
  readSerialString(serInString);

  if (serInString[0] != '\0') {
    hexToRGB(serInString);
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

void hexToRGB (char *hexStr) {
  // we know the exact length of our input and output
  strncpy(redHex, hexStr, 2);
  strncpy(greenHex, hexStr+2, 2);
  strncpy(blueHex, hexStr+4, 2);

  // strtol to convert the hex string to an integer
  long redValue = strtol(redHex, NULL, 16);
  long greenValue = strtol(greenHex, NULL, 16);
  long blueValue = strtol(blueHex, NULL, 16);

  // ensure the value is within the valid RGB range (0-255)
  redValue = constrain(redValue, 0, 255);
  greenValue = constrain(greenValue, 0, 255);
  blueValue = constrain(blueValue, 0, 255);

  // convert
  redVal = static_cast<int>(redValue);
  greenVal = static_cast<int>(greenValue);
  blueVal = static_cast<int>(blueValue);

  Serial.print(">>> red hex val: ");
  Serial.println(redHex);
  Serial.print("Setting the red LED brightness to ");
  Serial.println(redVal);
  analogWrite(redPin, redVal);

  Serial.print(">>> green hex val: ");
  Serial.println(greenHex);
  Serial.print("Setting the green LED brightness to ");
  Serial.println(greenVal);
  analogWrite(greenPin, greenVal);

  Serial.print(">>> blue hex val: ");
  Serial.println(blueHex);
  Serial.print("Setting the blue LED brightness to ");
  Serial.println(blueVal);
  analogWrite(bluePin, blueVal);

  // 010101, 111111, aaaaaa, ffffff
  // ff0000, ffa500, ffc100, 98fb98, 2a52be, ccccff
  // 000000
}
