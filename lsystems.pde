// Camara
  float angulo = -PI/2; // angulo inicial de la camara, usado para girar alrededor del objeto
  float distancia = 1000; // distancia inicial base del objeto a la camara 
  float posicionY = -200; // posicion inicial de la camara en el espacio
  float posicionX = 0;

// Parametros del arbol
  int iteraciones_del_dibujado = 3;
  int seed;
  String default_rule;
  
// Texturas
  PImage imgHoja;
  PImage imgTronco;
  PImage imgNudo;
  PImage imgGround;
  
// L-System
  LSystem system;
  
 int niveles = 10;
 
 PShape nudos[] = new PShape[10]; // Array de uniones entre segmentos del arbol (ramas)
 PShape hoja;
 PShape ground;
int vectorPesos[] = {12,8,6,5,4,3,2,1,0}; 
  
void setup (){
  
  // Generación de la semilla para el angulo z
    seed = year()*month()*day()*hour()*minute()*second()*millis();
    
  // Regla por defecto para generar el arbol
    default_rule = "F[+F-F[-F]]F[-F-F[-F]]";
    
  // Tamaño y tipo de ventana
    size(1300, 900, P3D);
  
  // Tasa de refresco
    frameRate(60);
  
  // Dibujado en el espacio con anti-aliased
    smooth();
    
  // LSystem
    system = new LSystem();
    
  // llamada a las iteraciones
    system.iterate(iteraciones_del_dibujado);
 
    imgHoja = loadImage("Textures/leaf1.jpg");
    imgTronco = loadImage("Textures/tree.jpg");
    imgNudo = loadImage("Textures/knot.jpg");
    imgGround = loadImage("Textures/ground.jpg");
    
    for(int i = 0; i < 9; i++)
    {
      noStroke();
      nudos[i] = createShape(SPHERE, vectorPesos[i]);
      nudos[i].setTexture(imgNudo);
    }
    
   noStroke();
   hoja = createShape(QUAD, 0, 0, 4, 4, 0, random(20)+120 , -4, 3);
   hoja.setTexture(imgHoja);
   ground = createShape(BOX,500,10,500);
   ground.setTexture(imgGround);
}

void draw ()
{
  
  // Se reinicia el color de fondo
     background(240,240,240);
     
  // Establece la semilla del random
    randomSeed(seed);
    
  // Función que dibuja el arbol
    system.draw();
  
  // ground drawing
    translate(0,10,0);
    shape(ground);    
  // Actualización de la posición de la camara en función de las teclas pulsadas
    if (keyPressed) {
      if (key == 's' || key == 'S'){          
        distancia += 10;
      }else if(key == 'w' || key == 'W'){ 
        distancia -= 10;
      }else if(key == 'a' || key == 'A'){
        angulo -= PI/100;
      }else if(key == 'd' || key == 'D'){ 
        angulo += PI/100;
      }else if(key == 'r' || key == 'R'){
        angulo = PI/2;
        posicionY = 0;
        distancia = 700;
        posicionX = 0;
      }else if(key == CODED){
        if(keyCode == UP){
          posicionY -= 2;
        }else if(keyCode == DOWN){
          posicionY += 2;
        }else if(keyCode == LEFT){
          posicionX -= 2;
        }else if(keyCode == RIGHT){
          posicionX += 2;
        }
      }
    }
    
  // Camara
    camera(cos(angulo)*distancia + posicionX ,posicionY, sin(angulo)*distancia, posicionX, posicionY, 0, 0, 1, 0);
  
}

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

void dibujarRama(float x1, float y1, float z1,float x2, float y2, float z2, int nivel, boolean fin_rama)

// was called drawLine; programmed by James Carruthers

// see http://processing.org/discourse/yabb2/YaBB.pl?num=1262458611/0#9

{
  //color strokeColour = color(124,60,0);
  

  PVector p1 = new PVector(x1, y1, z1);

  PVector p2 = new PVector(x2, y2, z2);

  PVector v1 = new PVector(x2-x1, y2-y1, z2-z1);

  float rho = sqrt(pow(v1.x,2)+pow(v1.y,2)+pow(v1.z,2));

  float phi = acos(v1.z/rho);

  float the = atan2(v1.y,v1.x);

  v1.mult(0.5);

  pushMatrix();

  translate(x1,y1,z1);
  
  shape(nudos[nivel]); // Nudo en la rama
  

  translate(v1.x, v1.y, v1.z);

  rotateZ(the);

  rotateY(phi);

  noStroke();
   
  if(fin_rama) // La rama termina en una punta variable
    drawCylinder( 10, random(2), vectorPesos[nivel], p1.dist(p2));
   else
    drawCylinder( 10, vectorPesos[nivel], vectorPesos[nivel]+1, p1.dist(p2));
  
  //box(weight,weight,p1.dist(p2)*1.2);
  /*
  PShape rama = createShape(BOX, weight,weight,p1.dist(p2)*1.2);
  rama.setTexture(imgTronco);
  shape(rama);
  */
 

  popMatrix();

}


void dibujarHoja(float x1, float y1, float z1, float anchoHoja)
{
  //color strokeColour = color(124,60,0);
  
  //float x2 = x1+15;
  //float y2 = y1+15;
  //float z2 = z1+15;

  //PVector p1 = new PVector(x1, y1, z1);

  //PVector p2 = new PVector(x2, y2, z2);

  //PVector v1 = new PVector(x2-x1, y2-y1, z2-z1);

  //float rho = sqrt(pow(v1.x,2)+pow(v1.y,2)+pow(v1.z,2));

  //float phi = acos(v1.z/rho);

  //float the = atan2(v1.y,v1.x);

  //v1.mult(0.5);

  pushMatrix();

  translate(x1,y1+2,z1);
 
  shape(hoja);
  
  
  

  
  //shape(hoja);
  // normally just   translate(v1.x, v1.y, v1.z);

  //translate(v1.x, v1.y, v1.z);

  //rotateZ(the);

  //rotateY(phi);

  //noStroke();

  //fill(0,240,0);

  //box(15,15,p1.dist(p2)*1.2);
  
  //translate(0,0,z1);   
  
  //PShape hoja = createShape(ELLIPSE, x1, y1+10, anchoHoja, anchoHoja*2);
  //hoja.setTexture(imgHoja);
 
  
 

  popMatrix();

}
