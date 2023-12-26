import processing.pdf.*;
color[] cols = {#FAC748, #F9E9EC, #5FBFF9, #473BF0, #171D1C};

void setup() {
  size(500, 500);
  background(#F5F5EE);
  
  beginRecord(PDF, "Output/test.pdf");

  noStroke();
  noLoop();
}

void draw() {
  // get the image to be in the center
  translate(width/2, height/2);
  
  // image comes in as a diamond, rotate for square
  rotate(QUARTER_PI);
  
  
  generate(0, 0, width/1.5);
  
  endRecord();
}

void generate(float x, float y, float radius) {
  fill(cols[(int)random(cols.length)]);
  circle(x, y, radius);

  if (radius > 8) {
    generate(x + radius/2, y, radius/2);
    generate(x - radius/2, y, radius/2);
    generate(x, y + radius/2, radius/2);
    generate(x, y - radius/2, radius/2);
  }
}
