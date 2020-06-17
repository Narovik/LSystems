void dibujarRama(float x1, float y1, float z1,float x2, float y2, float z2, int nivel, boolean fin_rama, boolean tronco_inicial){
  PVector p1 = new PVector(x1, y1, z1);

  PVector p2 = new PVector(x2, y2, z2);

  PVector v1 = new PVector(x2-x1, y2-y1, z2-z1);

  float rho = sqrt(pow(v1.x,2)+pow(v1.y,2)+pow(v1.z,2));

  float phi = acos(v1.z/rho);

  float the = atan2(v1.y,v1.x);

  v1.mult(0.5);

  pushMatrix();

  translate(x1,y1,z1);
  
  // Dibujado del nudo
     shape(nudos[nivel]);
  
  translate(v1.x, v1.y, v1.z);

  rotateZ(the);

  rotateY(phi);

  noStroke();
   
  if(fin_rama) // La rama termina en una punta variable
    drawCylinder( 10, random(2), vectorPesos[nivel], p1.dist(p2));
   else
    if(!tronco_inicial) // Si es el tronco inicial, se dibuja con un grosor superior
      drawCylinder( 10, vectorPesos[nivel], vectorPesos[nivel]+1, p1.dist(p2));
    else
      drawCylinder( 10, vectorPesos[nivel], 20, p1.dist(p2));
  popMatrix();

}


void dibujarHoja(float x1, float y1, float z1)
{
  pushMatrix();
  // Posicionar la hoja
    translate(x1,y1+2,z1);
    rotateY(random(2*PI));
    shape(hoja);
  popMatrix();
}

// dibujado de un cilindro
void drawCylinder( int sides, float r1, float r2, float h)
{
 
    textureMode(IMAGE);
    float angle = 360 / sides;
    float halfHeight = h / 2;
    // top
    noStroke();
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r1;
        float y = sin( radians( i * angle ) ) * r1;
        texture(imgTronco);
        vertex( x, -y, halfHeight, i*25, 0);
    }
    endShape(CLOSE);
    // bottom
    beginShape();
    for (int i = 0; i < sides; i++) {
        //translate(fin.x,fin.y,fin.z);
        float x = cos( radians( i * angle ) ) * r2;
        float y = sin( radians( i * angle ) ) * r2;
        texture(imgTronco);
        vertex( x, -y, -halfHeight, i*25, 100);
    }
    endShape(CLOSE);
    // draw body
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < sides + 1; i++) {
        float x1 = cos( radians( i * angle ) ) * r1;
        float y1 = sin( radians( i * angle ) ) * r1;
        float x2 = cos( radians( i * angle ) ) * r2;
        float y2 = sin( radians( i * angle ) ) * r2;
        texture(imgTronco);
        vertex( x1, -y1, halfHeight, i*25, 0);
        vertex( x2, -y2, -halfHeight, i*25, 100);
    }
    endShape(CLOSE);
}
