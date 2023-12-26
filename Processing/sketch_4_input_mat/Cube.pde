//Classe pour les cubes qui flottent dans l'espace
class Cube {
  //Position Z de "spawn" et position Z maximale
  float startingZ = -10000;
  float maxZ = 1000;
  
  //Valeurs de positions
  float x, y, z;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;
  
  //Constructeur
  Cube() {
    //Faire apparaitre le cube à un endroit aléatoire
    x = random(0, width);
    y = random(0, height);
    z = random(startingZ, maxZ);
    
    //Donner au cube une rotation aléatoire
    rotX = random(0, 1);
    rotY = random(0, 1);
    rotZ = random(0, 1);
  }
  
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    //Sélection de la couleur, opacité déterminée par l'intensité (volume de la bande)
    color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, intensity*5);
    fill(displayColor, 255);
    
    //Couleur lignes, elles disparaissent avec l'intensité individuelle du cube
    color strokeColor = color(255, 150-(20*intensity));
    stroke(strokeColor);
    strokeWeight(1 + (scoreGlobal/300));
    
    //Création d'une matrice de transformation pour effectuer des rotations, agrandissements
    pushMatrix();
    
    //Déplacement
    translate(x, y, z);
    
    //Calcul de la rotation en fonction de l'intensité pour le cube
    sumRotX += intensity*(rotX/1000);
    sumRotY += intensity*(rotY/1000);
    sumRotZ += intensity*(rotZ/1000);
    
    //Application de la rotation
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
    
    //Création de la boite, taille variable en fonction de l'intensité pour le cube
    box(100+(intensity/2));
    
    //Application de la matrice
    popMatrix();
    
    //Déplacement Z
    z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));
    
    //Replacer la boite à l'arrière lorsqu'elle n'est plus visible
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = startingZ;
    }
  }
}
