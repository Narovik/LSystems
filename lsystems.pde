// Camara
  float angulo = 0; // angulo inicial de la camara, usado para girar alrededor del objeto
  float distancia = 400; // distancia inicial base del objeto a la camara 
  float posicionY = -50; // posicion inicial de la camara en el espacio
  float posicionX = 0;

// Parametros del arbol
  int iteraciones_del_dibujado = 2;
  int seed;
  String default_rule;
  
// Texturas
  PImage imgHoja;
  PImage imgTronco;
  
// L-System
  LSystem system;
  
void setup (){
  
  // Generación de la semilla para el angulo z
    seed = year()*month()*day()*hour()*minute()*second()*millis();
    
  // Regla por defecto para generar el arbol
    default_rule = "F[+F-F]F[-F+F]";
    
  // Tamaño y tipo de ventana
    size(1300, 900, P3D);
  
  // Tasa de refresco
    frameRate(50);
  
  // Dibujado en el espacio con anti-aliased
    smooth();
    
  // LSystem
    system = new LSystem();
    
  // llamada a las iteraciones
    system.iterate(iteraciones_del_dibujado);
 
    imgHoja = loadImage("Textures/leaf.jpg");
    imgTronco = loadImage("Textures/tree.jpg");
}

void draw ()
{
  // Se reinicia el color de fondo
     background(240,240,240);
  
  // Establece la semilla del random
    randomSeed(seed);
  
  // Función que dibuja el arbol
    system.draw();
    
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
    float angle = 360 / sides;
    float halfHeight = h / 2;
    // top
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r1;
        float y = sin( radians( i * angle ) ) * r1;
        vertex( x, -y, halfHeight);
    }
    endShape(CLOSE);
    // bottom
    beginShape();
    for (int i = 0; i < sides; i++) {
        //translate(fin.x,fin.y,fin.z);
        float x = cos( radians( i * angle ) ) * r2;
        float y = sin( radians( i * angle ) ) * r2;
        vertex( x, -y, -halfHeight);
    }
    endShape(CLOSE);
    // draw body
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < sides + 1; i++) {
        float x1 = cos( radians( i * angle ) ) * r1;
        float y1 = sin( radians( i * angle ) ) * r1;
        float x2 = cos( radians( i * angle ) ) * r2;
        float y2 = sin( radians( i * angle ) ) * r2;
        vertex( x1, -y1, halfHeight);
        vertex( x2, -y2, -halfHeight);
    }
    endShape(CLOSE);
}

void dibujarRama(float x1, float y1, float z1,float x2, float y2, float z2,float weight)

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

  // normally just   translate(v1.x, v1.y, v1.z);

  translate(v1.x, v1.y, v1.z);

  rotateZ(the);

  rotateY(phi);

  noStroke();

  fill(139,69,19);
  drawCylinder( 10, 2, 5, p1.dist(p2)*1.2);
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
  
  //float x2 = x1+weight;
  //float y2 = y1+weight;
  //float z2 = z1+weight;

  //PVector p1 = new PVector(x1, y1, z1);

  //PVector p2 = new PVector(x2, y2, z2);

  //PVector v1 = new PVector(x2-x1, y2-y1, z2-z1);

  //float rho = sqrt(pow(v1.x,2)+pow(v1.y,2)+pow(v1.z,2));

  //float phi = acos(v1.z/rho);

  //float the = atan2(v1.y,v1.x);

  //v1.mult(0.5);

 

  pushMatrix();

  //translate(x1,y1,z1);

  // normally just   translate(v1.x, v1.y, v1.z);

  //translate(v1.x, v1.y, v1.z);

  //rotateZ(the);

  //rotateY(phi);

  noStroke();

  //fill(strokeColour);

  // box(weight,weight,p1.dist(p2)*1.2);
  
  //translate(0,0,z1);   
  //ellipse(x1,y1+10,30,30);
  //PShape hoja = createShape(ELLIPSE, x1, y1+10, anchoHoja, anchoHoja*2);
  //hoja.setTexture(imgHoja);
  //shape(hoja);
  
 

  popMatrix();

}
