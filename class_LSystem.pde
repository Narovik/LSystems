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

float  default_angle = PI / 8;
float  default_extension = 20;
float  default_extension_chaos = 0.5;

int     default_y_offset = 400;
boolean default_draw_tips = true;

float angle = default_angle;
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
      pos = 0;
      state = new float[4];
      state[0] = 0;
      state[1] = 0;
      state[2] = 0;
      state[3] = 0;
      rule = default_rule;
      state_stack = new float[4096][4];
      for (int i = 0; i < string.length(); i++)
      {
        this.drawSegment();
      }
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
            float y_delta = -ext_this * cos(state[2]); // se pone la y negativa para que crezca hacia arriba
            float z_delta = ext_this * random(-PI/4, PI/4);
            
            if(pos==0){
              ext_this = 100;
              z_delta=0;
              y_delta = -ext_this * cos(state[2]);
              
            }
            
            PVector inicio = new PVector(state[0], state[1], state[3]);
            PVector fin = new PVector(state[0] + x_delta, state[1] + y_delta, state[3]+z_delta);
            float ancho = 2;
            if(pos==0) ancho = 4;
            
            color marron = color(124,60,0);
            color verde = color(10,240,20);
            int anchoHoja = 10;
            
            dibujarRama(inicio.x, inicio.y, inicio.z, fin.x, fin.y, fin.z, ancho);
            
            
            if(pos>3){
              dibujarHoja(fin.x, fin.y, fin.z, anchoHoja); // HOJA AL FINAL DEL SEGMENTO
              dibujarHoja(inicio.x, inicio.y, inicio.z, anchoHoja); // HOJA AL FINAL DEL SEGMENTO
              dibujarHoja((inicio.x+fin.x)/2, (inicio.y+fin.y)/2, (inicio.z+fin.z)/2, anchoHoja); // HOJA AL FINAL DEL SEGMENTO
               
            }
            
            state[0] += x_delta;
            state[1] += y_delta;
            state[3] += z_delta;
            
            break;
          case '-':
            state[2] -= (angle + random(1 * angle, angle));
            break;
          case '+':
            state[2] += (angle + random(1 * angle, angle));
            break;
          case '[':
            arrayCopy(state, state_stack[stack_size++]);
            break;
          case ']':
            arrayCopy(state_stack[--stack_size], state);
            break;
    }
    
    pos++;
  }
}
