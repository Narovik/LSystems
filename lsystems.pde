import uibooster.*;
import uibooster.components.*;
import uibooster.model.*;
import uibooster.model.formelements.*;
import uibooster.utils.*;

// Camara
  float angulo = -PI/2; // angulo inicial de la camara, usado para girar alrededor del objeto
  float distancia = 1000; // distancia inicial base del objeto a la camara 
  // posicion inicial de la camara en el espacio
    float posicionY = -200;
    float posicionX = 0;
  
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
  int iteraciones_del_dibujado = 3;
  int seed;
  int numDivisiones=3; // Divisones del segmento para pintar hojas
  String default_rule = "F[+F-F[-F]]F[-F-F[-F]]"; // Regla por defecto para generar el arbol
  float  default_angle = PI / 8;
  float  default_extension = 35;
  float  default_extension_chaos = 0.5;
  float angle = default_angle;
  float extension = default_extension;
  float extension_chaos = default_extension_chaos;
  
void setup (){
  // Ventana de processing
    surface.setTitle("LSystems - Victor M. Rodriguez - Ihar Myshkevich");
    surface.setLocation(0, 0);
    
  // Interfaz de modificación
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
 
  // Carga de texturas
    imgHoja = loadImage("Textures/leaf1.jpg");
    imgTronco = loadImage("Textures/tree.jpg");
    imgNudo = loadImage("Textures/knot.jpg");
    imgGround = loadImage("Textures/ground.jpg");
    
  // Inicialización de los PShapes
    noStroke();
    for(int i = 0; i < vectorPesos.length; i++)
    {
      noStroke();
      nudos[i] = createShape(SPHERE, vectorPesos[i]);
      nudos[i].setTexture(imgNudo);
    }
    
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
  
  // Suelo
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
