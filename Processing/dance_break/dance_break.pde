import processing.pdf.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
Serial myPort;
JSONObject json_;
//String json_;

int numPins_ = 2; // UDPATE THIS TO YOUR NUMBER OF SENSORS
float[] senValues_;
int sensor1 = 0;
int sensor2 = 1;

color[] cols = {#FAC748, #F9E9EC, #5FBFF9, #473BF0, #171D1C};
float xRand = 0;
float yRand = 0;

void setup() {
  //size(500, 500);
  //size(1080, 1080);
  size(810, 810);
  //size(720, 720);
  //size(540, 540);
  background(#F5F5EE);
  
  beginRecord(PDF, "out/dance_break.pdf");
  
  //arduino = new Arduino(this, Arduino.list()[6], 57600);
  // The code below will print out all your ports to your console. 
 // MAKE A NOTE of which port is the first listing for /dev/tty.usbmodem#####.
  for (int i = 0; i < Serial.list().length; i++) {
    println(Serial.list()[i]);
  }
  // CHANGE 2 TO BE WHICHEVER PORT WAS /DEV/TTY.USBMODEM#######.
  // You start counting with 0. Ours was the third listing, so we put 2.
  String portName = Serial.list()[6]; 
  myPort = new Serial(this, portName, 9600);
  senValues_ = new float[numPins_];
  for (int i = 0; i < numPins_; i++) {
    senValues_[i] = 0;
  }
  
  noStroke();
  //noLoop();
}

void draw() {
  // get the image to be in the center
  translate(width/2, height/2);
  
  // image comes in as a diamond, rotate for square
  //rotate(QUARTER_PI);
  
  // rand x and y based on each arm?
  
  // random
  //xRand = int(random((-1 * width)/2, width/2));
  //yRand = int(random((-1 * height)/2, height/2));
  
  // from pots
  //xRand = map(arduino.analogRead(sensor1), 0, 1023, -width/2, width/2);
  //yRand = map(arduino.analogRead(sensor2), 0, 1023, -width/2, width/2);
  
  if (getData()) {
    //println(senValues_[0]);
    generate(xRand, yRand, 160);
  }
  // if (getData()) {
  //  // Map sensor values
  //  float size = map(senValues_[0], 0, 300, 8, 20); // Change 10 and 200 to your desired min/max size
  //  int colorIndex = int(map(senValues_[1], 0, 300, 0, cols.length)); // Map to the index of the color array

  //  // Generate pattern
  //  generatePattern(size, cols[colorIndex]);
  //}
  //if (getData()) {
  //  float size = map(senValues_[0], 0, 1000, 8, 25); // Map sensor value to size
  //  int colorIndex = int(map(senValues_[1], 0, 300, 0, cols.length)); // Map sensor value to color index
  //  color selectedColor = cols[colorIndex % cols.length]; // Ensure index is within array bounds
  //  float x = map(senValues_[0], 0, 1000, -width/2, width/2);
  //  float y = map(senValues_[1], 0, 1000, -height/2, height/2);
  
  //  generatePattern(size, selectedColor, x, y); // Call the function with the mapped size and color
  //}
  
  //endRecord();
  //println(timeDelay);
  delay(500);
}

void generate(float x, float y, float radius) {
  rotate(QUARTER_PI); // remove for square blobs again
  fill(cols[(int)random(cols.length)]);
  circle(x, y, radius);

  if (radius > 8) {
    generate(x + radius/2, y, radius/2);
    generate(x - radius/2, y, radius/2);
    generate(x, y + radius/2, radius/2);
    generate(x, y - radius/2, radius/2);
  }
}

void generatePattern(float size, color col, float x, float y) {
  // Set the color for the shape
  fill(col);

  // Draw a circle (or any other shape) at the position with the given size
  circle(x, y, size);
}

// native function
// DON'T CLICK CLOSE LOL — click inside screen first
void mouseClicked() {
  // use to capture image before closing
  endRecord();
}

boolean getData() {
  if (myPort.available() > 0) {  // If data is available,
    json_ = parseJSONObject(myPort.readString());
    //json_ = myPort.readString();
    println(json_); 
    if (json_ != null) {
      senValues_[0] = json_.getInt("left"); // IF YOU HAVE MORE OR LESS SENSORS, UPDATE THIS
      senValues_[1] = json_.getInt("right");
      // println(senValues_);
      xRand = map(senValues_[0], 0, 5000, -width/4, width/4);
      yRand = map(senValues_[1], 0, 5000, -width/4, width/4);
      generate(xRand, yRand, 16);
      return true;
    }
  }
  // println("INVALID JSON"); 
  return false;
}
