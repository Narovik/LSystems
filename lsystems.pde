/*

    Implementation of Lindenmayer Systems:
    emulates plant growth via a simple formal grammar.

    Copyright (c) Daniel Jones 2007.
    http://www.erase.net/
   
    ----------------------------------------------------------------------

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

 */

int seed;
String default_rule = "F[+F]F[-F]";

int    default_iterations = 5;
float  default_angle = PI / 10;
float  default_angle_chaos = 0.5;
float  default_extension = 10;
float  default_extension_chaos = 0.5;

int     default_y_offset = 400;
boolean default_draw_tips = true;

String  default_filename = "iterations-0.pdf";
  float zoom, desp;

LSystem system;

float angle = default_angle;
float angle_chaos = default_angle_chaos;
float extension = default_extension;
float extension_chaos = default_extension_chaos;

class LSystem
{
  String axiom,
         string;
  String [] rules;
  String rule;
  float [] state;
  float [][] state_stack;
  int stack_size = 0;
  int pos = 0;
  color col;
  

  
 
  LSystem ()
  {
    axiom = "F";
    string = "F";
    state = new float[4];
    state[0] = 0;
    state[1] = 0;
    state[2] = 0;
    state[3] = 0;
    col = color(0, 0, 0);
    rule = default_rule;
    state_stack = new float[4096][4];
  }
  
  void iterate ()
  {
    this.iterate(1);
  }
  
  void iterate (int count)
  {
    for (int i = 0; i < count; i++)
    {
      String string_next = "";
      
      for (int j = 0; j < string.length(); j++)
      {
        char c = string.charAt(j);
        if (c == 'F')
        {
          string_next = string_next + rule;
        } else {
          string_next = string_next + c;
        } 
      }
      string = string_next;
    } 
  }


  
  void draw()
  {
     // beginRecord(PDF, default_filename);
      translate(100, default_y_offset);
      rotate(1.5 * PI);
      
      strokeWeight(0.5);

      for (int i = 0; i < string.length(); i++)
      {
        this.drawSegment();
      }
     //camera(mouseX, mouseY, zoom, desp, height/2, -PI/6, 0, 1, 0);
      endRecord();
  }
  
  void drawSegment ()
  {
    if (pos >= string.length())
       { return; }
    
    char c = string.charAt(pos);
    switch (c)
    {
          case 'F':
            float ext_this = extension + random(-1.0 * extension * extension_chaos, extension * extension_chaos);
            float x_delta = ext_this * sin(state[2]);
            float y_delta = ext_this * cos(state[2]);
            float z_delta = ext_this * random(-PI/4, PI/4);


            stroke(col);
            strokeWeight(1);
            //stroke(random(255), random(255), random(255), 230);

            line(state[0], state[1], state[3], state[0] + x_delta, state[1] + y_delta, state[3]+z_delta);
            state[0] += x_delta;
            state[1] += y_delta;
            state[3] += z_delta;
            /*
            if (default_draw_tips)
            {
                strokeWeight(0.5);
                line(state[0], state[1], state[3], state[0] + 0.1, state[1] + 0.1, state[3]+z_delta);
            }
*/
            break;
          case '-':
            state[2] -= (angle + random(-1 * angle * angle_chaos, angle * angle_chaos));
            break;
          case '+':
            state[2] += (angle + random(-1 * angle * angle_chaos, angle * angle_chaos));
            break;
          case '[':
            arraycopy(state, state_stack[stack_size++]);
            break;
          case ']':
            arraycopy(state_stack[--stack_size], state);
            break;
    }
    
    pos++;
  }
} //CLASS LSYSTEM

void setup ()
{
  int iterations = default_iterations;
  seed = year()*month()*day()*hour()*minute()*second()*millis();

  size(1300, 900, P3D);
  background(250);
  frameRate(50);
  smooth();
  system = new LSystem();
  system.iterate(iterations);
  
          zoom = height/2;
        desp = width/2;
  
  //translate(width/2,0);

  //system.draw();
}

void draw ()
{
  randomSeed(seed);
  int iterations = default_iterations;
  system = new LSystem();
  system.iterate(iterations);
  
  // To draw segment by segment, rename this routine to draw()
  // and remove system.draw() from setup().

  background(240,240,240);
  sphere(100);
  
  translate(100, height);
  rotate(1.5 * PI);

  system.draw();
  for (int i = 0; i < random(10, 50); i++)
  {
    //system.drawSegment();
  }

  //Camara

       if (keyPressed) {
          println("Tecla pulsada "+key);
        if (key == 's'){
          zoom += 10;
        }
        else if(key == 'w') 
          zoom -= 10;
        else if(key == 'a') 
          desp -= 10;
        else if(key == 'd') 
          desp += 10;
    
       }

    camera(mouseX, mouseY, zoom, desp, height/2, -PI/6, 0, 1, 0);

  
}
