import processing.pdf.*;
import processing.serial.*;
import cc.arduino.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer song;
FFT fft;
Arduino arduino;
Serial myPort;
JSONObject json_;

// Variables qui définissent les "zones" du spectre
// Par exemple, pour les basses, on prend seulement les premières 4% du spectre total
float specLow = 0.03; // 3%
float specMid = 0.125;  // 12.5%
float specHi = 0.20;   // 20%

// Il reste donc 64% du spectre possible qui ne sera pas utilisé. 
// Ces valeurs sont généralement trop hautes pour l'oreille humaine de toute facon.

// Valeurs de score pour chaque zone
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

// Valeur précédentes, pour adoucir la reduction
float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;

// Valeur d'adoucissement
float scoreDecreaseRate = 25;

// Cubes qui apparaissent dans l'espace
int nbCubes;
Cube[] cubes;

//Lignes qui apparaissent sur les cotés
int nbMurs = 500;
Mur[] murs;

int numPins_ = 4; // UDPATE THIS TO YOUR NUMBER OF SENSORS
float[] senValues_;

color[] cols = {#FAC748, #F9E9EC, #5FBFF9, #473BF0, #171D1C};
float topL = 0;
float topR = 0;
float botL = 0;
float botR = 0;

void setup() {
  //size(500, 500);
  //size(1080, 1080);
  size(810, 810);
  //size(720, 720);
  //size(540, 540);
  background(#F5F5EE);
  
  beginRecord(PDF, "out/dance_break.pdf");
  
  // The code below will print out all your ports to your console. 
  // MAKE A NOTE of which port is the first listing for /dev/tty.usbmodem#####.
  for (int i = 0; i < Serial.list().length; i++) {
    println(Serial.list()[i]);
  }
  // CHANGE 2 TO BE WHICHEVER PORT WAS /DEV/TTY.USBMODEM#######.
  // You start counting with 0. Ours was the third listing, so we put 2.
  String portName = Serial.list()[2]; 
  myPort = new Serial(this, portName, 9600);
  senValues_ = new float[numPins_];
  for (int i = 0; i < numPins_; i++) {
    senValues_[i] = 0;
  }
  
  noStroke();
  //noLoop();
  
  //Faire afficher en 3D sur tout l'écran
  fullScreen(P3D);
 
  //Charger la librairie minim
  minim = new Minim(this);
 
  //Charger la chanson
  song = minim.loadFile("while-were-young.mp3");
  
  //Créer l'objet FFT pour analyser la chanson
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  //Un cube par bande de fréquence
  nbCubes = (int)(fft.specSize()*specHi);
  cubes = new Cube[nbCubes];
  
  //Autant de murs qu'on veux
  murs = new Mur[nbMurs];

  //Créer tous les objets
  //Créer les objets cubes
  for (int i = 0; i < nbCubes; i++) {
   cubes[i] = new Cube(); 
  }
  
  //Créer les objets murs
  //Murs gauches
  for (int i = 0; i < nbMurs; i+=4) {
   murs[i] = new Mur(0, height/2, 10, height); 
  }
  
  //Murs droits
  for (int i = 1; i < nbMurs; i+=4) {
   murs[i] = new Mur(width, height/2, 10, height); 
  }
  
  //Murs bas
  for (int i = 2; i < nbMurs; i+=4) {
   murs[i] = new Mur(width/2, height, width, 10); 
  }
  
  //Murs haut
  for (int i = 3; i < nbMurs; i+=4) {
   murs[i] = new Mur(width/2, 0, width, 10); 
  }
  
  //Fond noir
  background(0);
  
  //Commencer la chanson
  song.play(0);
}

void draw() {
  // get the image to be in the center
  translate(width/2, height/2);
  
  // image comes in as a diamond, rotate for square
  // rotate(QUARTER_PI);
  
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

boolean getData() {
  if (myPort.available() > 0) {  // If data is available,
    json_ = parseJSONObject(myPort.readString());
    println(json_); 
    if (json_ != null) {
      senValues_[0] = json_.getInt("blue"); // IF YOU HAVE MORE OR LESS SENSORS, UPDATE THIS
      senValues_[1] = json_.getInt("green");
      senValues_[2] = json_.getInt("red");
      senValues_[3] = json_.getInt("black");
      println(senValues_);
      topL = map(senValues_[0], 0, 5000, -width/4, width/4);
      topR = map(senValues_[1], 0, 5000, -width/4, width/4);
      botL = map(senValues_[2], 0, 5000, -width/4, width/4);
      botR = map(senValues_[3], 0, 5000, -width/4, width/4);
      //generate(xRand, yRand, 16);
      return true;
    }
  }
  // println("INVALID JSON"); 
  return false;
}

// native function
// DON'T CLICK CLOSE LOL — click inside screen first
void mouseClicked() {
  // use to capture image before closing
  endRecord();
}

void draw()
{
  //Faire avancer la chanson. On draw() pour chaque "frame" de la chanson...
  fft.forward(song.mix);
  
  //Calcul des "scores" (puissance) pour trois catégories de son
  //D'abord, sauvgarder les anciennes valeurs
  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;
  
  //Réinitialiser les valeurs
  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;
 
  //Calculer les nouveaux "scores"
  for(int i = 0; i < fft.specSize()*specLow; i++)
  {
    scoreLow += fft.getBand(i);
  }
  
  for(int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++)
  {
    scoreMid += fft.getBand(i);
  }
  
  for(int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++)
  {
    scoreHi += fft.getBand(i);
  }
  
  //Faire ralentir la descente.
  if (oldScoreLow > scoreLow) {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }
  
  if (oldScoreMid > scoreMid) {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }
  
  if (oldScoreHi > scoreHi) {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }
  
  //Volume pour toutes les fréquences à ce moment, avec les sons plus haut plus importants.
  //Cela permet à l'animation d'aller plus vite pour les sons plus aigus, qu'on remarque plus
  float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
  
  //Couleur subtile de background
  background(scoreLow/100, scoreMid/100, scoreHi/100);
   
  //Cube pour chaque bande de fréquence
  for(int i = 0; i < nbCubes; i++)
  {
    //Valeur de la bande de fréquence
    float bandValue = fft.getBand(i);
    
    //La couleur est représentée ainsi: rouge pour les basses, vert pour les sons moyens et bleu pour les hautes. 
    //L'opacité est déterminée par le volume de la bande et le volume global.
    cubes[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
  
  //Murs lignes, ici il faut garder la valeur de la bande précédent et la suivante pour les connecter ensemble
  float previousBandValue = fft.getBand(0);
  
  //Distance entre chaque point de ligne, négatif car sur la dimension z
  float dist = -25;
  
  //Multiplier la hauteur par cette constante
  float heightMult = 2;
  
  //Pour chaque bande
  for(int i = 1; i < fft.specSize(); i++)
  {
    //Valeur de la bande de fréquence, on multiplie les bandes plus loins pour qu'elles soient plus visibles.
    float bandValue = fft.getBand(i)*(1 + (i/50));
    
    //Selection de la couleur en fonction des forces des différents types de sons
    stroke(100+scoreLow, 100+scoreMid, 100+scoreHi, 255-i);
    strokeWeight(1 + (scoreGlobal/100));
    
    //ligne inferieure gauche
    line(0, height-(previousBandValue*heightMult), dist*(i-1), 0, height-(bandValue*heightMult), dist*i);
    line((previousBandValue*heightMult), height, dist*(i-1), (bandValue*heightMult), height, dist*i);
    line(0, height-(previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), height, dist*i);
    
    //ligne superieure gauche
    line(0, (previousBandValue*heightMult), dist*(i-1), 0, (bandValue*heightMult), dist*i);
    line((previousBandValue*heightMult), 0, dist*(i-1), (bandValue*heightMult), 0, dist*i);
    line(0, (previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), 0, dist*i);
    
    //ligne inferieure droite
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width, height-(bandValue*heightMult), dist*i);
    line(width-(previousBandValue*heightMult), height, dist*(i-1), width-(bandValue*heightMult), height, dist*i);
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), height, dist*i);
    
    //ligne superieure droite
    line(width, (previousBandValue*heightMult), dist*(i-1), width, (bandValue*heightMult), dist*i);
    line(width-(previousBandValue*heightMult), 0, dist*(i-1), width-(bandValue*heightMult), 0, dist*i);
    line(width, (previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), 0, dist*i);
    
    //Sauvegarder la valeur pour le prochain tour de boucle
    previousBandValue = bandValue;
  }
  
  //Murs rectangles
  for(int i = 0; i < nbMurs; i++)
  {
    //On assigne à chaque mur une bande, et on lui envoie sa force.
    float intensity = fft.getBand(i%((int)(fft.specSize()*specHi)));
    murs[i].display(scoreLow, scoreMid, scoreHi, intensity, scoreGlobal);
  }
}
