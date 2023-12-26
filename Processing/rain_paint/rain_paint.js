let img;
//let canvasTexture 
var mic;

function setup() {
  createCanvas(windowWidth,windowHeight);
  //canvasTexture = loadImage("wall.jpeg");
  
  //mic = new p5.AudioIn();
  //mic.start();
  
  capture=createCapture(VIDEO)
  capture.size(windowWidth,windowHeight)
  cacheGraphics=createGraphics(windowWidth,windowHeight)
  cacheGraphics.translate(windowWidth,0)
  cacheGraphics.scale(-1,1)
  capture.hide()
  
  img = capture;
  //imageMode(CENTER);
  noStroke();
  //background(255,2);
  
  //background(0,2);
  //frameRate(12);
  
  // drawingContext.shadowOffsetX = 0;
  // drawingContext.shadowOffsetY = 0;
  // drawingContext.shadowBlur = 15;
  // drawingContext.shadowColor = "#00000010"
}

function draw() { 
  noStroke();
  //fill(255,2);
  //fill(0,2);
  //rect(0,0,width,height);
  
  let x = random(img.width);
  let y = random(img.height);
  colorpix = img.get(x, y);
  R = random(-100,0);
  W = map(R, 0, -100, 25, 0);
  M = map(R, 0, -100, 15, 0);
  K = map(mic.getLevel(), 0, 0.1, 0, 100);
  
  //let a = map(mic.getLevel(), 0, 0.2, 5, 100);
  //M = a;
  
  noStroke();
  fill(colorpix, 10);
  ellipse(x, y, W, W);
  ellipse(x, y, W*2, W*2);
  ellipse(x+random(-2*W,2*W),y+random(-2*W,2*W),W,random(W*0.9,W*1.1));
  ellipse(x+random(-2*W,2*W),y+random(-2*W,2*W),W/3,random(W/3*0.9,W/3*1.1));
  ellipse(x+random(-2*W,2*W),y+random(-2*W,2*W),W/5,random(W/5*0.9,W/5*1.1));
  
  //ellipse(x, y, W, W);
  //ellipse(x, y, W*2, W*2);
  //ellipse(x+random(-2*W,2*W),y+random(-2*W,2*W),W,random(W*0.9,W*1.1));
  //ellipse(x+random(-2*W,2*W),y+random(-2*W,2*W),W/3,random(W/3*0.9,W/3*1.1));
  //ellipse(x+random(-2*W,2*W),y+random(-2*W,2*W),W/5,random(W/5*0.9,W/5*1.1));
  
  ellipse(x, y, M, M);
  ellipse(x, y, M*2, M*2);
  ellipse(x+random(-2*M,2*M),y+random(-2*M,2*M),M,random(M*0.9,M*1.1));
  ellipse(x+random(-2*M,2*M),y+random(-2*M,2*M),M/3,random(M/3*0.9,M/3*1.1));
  ellipse(x+random(-2*M,2*M),y+random(-2*M,2*M),M/5,random(M/5*0.9,M/5*1.1));
  
  ellipse(x, y, K, K);
  ellipse(x, y, K*2, K*2);
  ellipse(x+random(-2*K,2*K),y+random(-2*K,2*K),K,random(K*0.9,K*1.1));
  ellipse(x+random(-2*K,2*K),y+random(-2*K,2*K),K/3,random(K/3*0.9,K/3*1.1));
  ellipse(x+random(-2*K,2*K),y+random(-2*K,2*K),K/5,random(K/5*0.9,K/5*1.1));
  
  strokeWeight(W/7);
  stroke(colorpix,10);
  line(x, y, x+R/2, y+R);
  strokeWeight(W/5);
  point(random(0,width),random(0,height));
  //fill(255,50);
  //noStroke();
  //ellipse(mouseX, mouseY, 5*W, 5*W);
  //push()
  //  blendMode(SCREEN)
  //  image(canvasTexture,0,0,windowWidth,windowHeight)
  //pop()
}
