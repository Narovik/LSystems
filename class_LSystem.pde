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



int     default_y_offset = 400;
boolean default_draw_tips = true;
boolean tronco_inicial = false;


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
    rule = default_rule;
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
      state = new float[5];
      state[0] = 0;
      state[1] = 0;
      state[2] = 0;
      state[3] = 0;
      state[4] = 1;
      rule = default_rule;
      state_stack = new float[4096][5];
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
            tronco_inicial = false;          
            float ext_this = extension/state[4] + random(-1.0 * extension * extension_chaos, extension * extension_chaos);
            float x_delta = ext_this * sin(state[2]);
            float y_delta = -ext_this * cos(state[2]); // se pone la y negativa para que crezca hacia arriba
            float z_delta = 0;
            if (stack_size == 0){
              z_delta = 0;
            }else if(state[3] == 0){
              z_delta = ext_this * random(-PI/2, PI/2);
            }else if(state[3] > 0){
              z_delta = ext_this * random(-PI/8, PI/2);
            }else{
              z_delta = ext_this * random(-PI/2, PI/8);
            }
            
            if(pos==0){
              ext_this = 100;
              z_delta=0;
              y_delta = -ext_this * cos(state[2]);
              tronco_inicial = true;
            }
            
            PVector inicio = new PVector(state[0], state[1], state[3]);
            PVector fin = new PVector(state[0] + x_delta, state[1] + y_delta, state[3]+z_delta);
            
            
            if(pos+1 <= string.length() && string.charAt(pos+1) == ']')
              dibujarRama(inicio.x, inicio.y, inicio.z, fin.x, fin.y, fin.z, stack_size, true,tronco_inicial);
               
            else 
             dibujarRama(inicio.x, inicio.y, inicio.z, fin.x, fin.y, fin.z, stack_size, false,tronco_inicial);
            
          
            if(pos>3){
              dibujarHoja(fin.x, fin.y, fin.z); // HOJA AL FINAL DEL SEGMENTO
              dibujarHoja(inicio.x, inicio.y, inicio.z); // HOJA AL FINAL DEL SEGMENTO
             
             float dx = (fin.x-inicio.x)/numDivisiones;
             float dy = (fin.y-inicio.y)/numDivisiones;
             float dz = (fin.z-inicio.z)/numDivisiones;
             
             // DIBUJAR HOJAS
             for(int i=1; i<=numDivisiones; i++)
              {
                dibujarHoja(dx*i+inicio.x, dy*i+inicio.y, dz*i+inicio.z); // HOJA AL FINAL DEL SEGMENTO
              }
            
               
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
