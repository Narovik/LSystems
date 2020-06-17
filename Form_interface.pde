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
