// Camara
  float angulo = 0; // angulo inicial de la camara, usado para girar alrededor del objeto
  float distancia = 700; // distancia inicial base del objeto a la camara 
  float posicionY = 0; // posicion inicial de la camara en el espacio
  float posicionX = 0;

// Parametros del arbol
  int iteraciones_del_dibujado = 2;
  int seed;
  String default_rule;
  
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
}

void draw ()
{
  // Se reinicia el color de fondo
     background(240,240,240);
  
  // Establece la semilla del random
    randomSeed(seed);
    
  // Generación de una nueva clase de LSystem
    system = new LSystem();
  
  // Se llama a la función que generara los datos encesarios para dibujar el arbol
    system.iterate(iteraciones_del_dibujado);
  
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
