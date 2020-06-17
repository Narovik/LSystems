import uibooster.*;
import uibooster.components.*;
import uibooster.model.*;
import uibooster.model.formelements.*;
import uibooster.utils.*;


// Camara
  float angulo = -PI/2; // angulo inicial de la camara, usado para girar alrededor del objeto
  float distancia = 1000; // distancia inicial base del objeto a la camara 
  float posicionY = -200; // posicion inicial de la camara en el espacio
  float posicionX = 0;

// Parametros del arbol
  int iteraciones_del_dibujado = 3;
  int seed;
  

  float  default_angle = PI / 8;
  float  default_extension = 35;
  float  default_extension_chaos = 0.5;
  float angle = default_angle;
  float extension = default_extension;
  float extension_chaos = default_extension_chaos;
  
  int numDivisiones=3; // Divisones del segmento para pintar hojas
      
  // Regla por defecto para generar el arbol
   String default_rule = "F[+F-F[-F]]F[-F-F[-F]]";
// Texturas
  PImage imgHoja;
  PImage imgTronco;
  PImage imgNudo;
  PImage imgGround;
  
// L-System
  LSystem system;
  
 int niveles = 11;
 
 int vectorPesos[] = {14,8,6,5,5,4,4,3,2,1,0}; 
 
 PShape nudos[] = new PShape[vectorPesos.length]; // Array de uniones entre segmentos del arbol (ramas)
 PShape hoja;
 PShape ground;


// Interfaz

UiBooster GUI;

void interfaz()
{
   // Interfaz
    new UiBooster().createForm("Parámetros")
       
    .addSlider("Iteraciones", 1, 5, 3, 1, 5)
    
     .addSlider("Extension", 0, 70, 35, 10, 70)
     
     .addSlider("Extension chaos", 0, 100, 50, 10, 100)
     
     .addSlider("Ángulo", 0, 360, 22, 60, 360)
     
     .addSlider("Población hojas", 2, 10, 3, 2, 10)
    
    .addSelection("Modelos propuestos", "F[+F-F[-F]]F[-F-F[-F]]", "F[-FF-F]F[+FF+F]", "FF[+F-F]F[-F+F]")
    
    .addButton("Reiniciar",new Runnable(){ public void run(){ extension=default_extension; extension_chaos=default_extension_chaos; angle=default_angle; iteraciones_del_dibujado=3; default_rule="F[+F-F[-F]]F[-F-F[-F]]"; } })
    
    .addButton("Dibujar",new Runnable(){ public void run(){ system=new LSystem(); system.iterate(iteraciones_del_dibujado); } })
    
    .setChangeListener(new FormElementChangeListener() {

      public void onChange(FormElement element, Object value) {

        if(element.getLabel().equals("Iteraciones")) {
          iteraciones_del_dibujado = element.asInt();
          println(iteraciones_del_dibujado);
        }
        
        if(element.getLabel().equals("Extension")) {
          extension = element.asInt();
          println("Extension cambiada a " + extension);
        }
                
        if(element.getLabel().equals("Extension chaos")) {
          extension_chaos = element.asInt() / 100.0;
          println("Extension chaos cambiado a " + extension_chaos);
        }
        
        if(element.getLabel().equals("Ángulo")) {
          angle = element.asInt();
          println("Ángulo cambiado a " + angle);
        }
        
        if(element.getLabel().equals("Población hojas")) {
          numDivisiones = element.asInt();
          println("Num divisiones cambiado a " + numDivisiones);
        }
        
        if(element.getLabel().equals("Modelos propuestos")) {
          default_rule=element.asString();
          // system=new LSystem(); system.iterate(iteraciones_del_dibujado);
          println("Regla de produccion cambiada a " + element.asString());
        }
        
      }
    })
    
    .run();
  
}
  
  
void setup (){
  surface.setTitle("LSystems - Victor M. Rodriguez - Ihar Myshkevich");
  surface.setLocation(0, 0);
  interfaz();
  
  // Generación de la semilla para el angulo z
    seed = year()*month()*day()*hour()*minute()*second()*millis();

    
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
    
    for(int i = 0; i < vectorPesos.length; i++)
    {
      noStroke();
      nudos[i] = createShape(SPHERE, vectorPesos[i]);
      nudos[i].setTexture(imgNudo);
    }
    
   noStroke();
   hoja = createShape(QUAD, 0, 0, 2, 4, 0, random(20)+120 , -2, 3);
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


void dibujarHoja(float x1, float y1, float z1)
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
  // Posicionar la hoja
  translate(x1,y1+2,z1);
  rotateY(random(2*PI));
  
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
