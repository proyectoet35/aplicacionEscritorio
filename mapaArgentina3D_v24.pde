import processing.dxf.*;
import peasy.*;
import peasy.PeasyCam;
import processing.opengl.PGL;
import processing.opengl.PGraphics3D;
import processing.opengl.PJOGL;

//Arreglar datos textoMapa
//Texto del boton Ordenar (flecha abajo, flecha arriba, , a-z)

//--- listo --- Agregar boton para ocultar lista de datos (al lado del boton de ordenar)
//--- listo --- Boton para la rotacion automatica (rotacion auto ?)
//--- listo --- Arreglar busqueda y darle un mejor lugar (Hacer la lista menos larga en Y y porner la busqueda abajo de todo)
//Arreglar letra de la interfaz
//Definir proporciones del tamaño de la interfaz


Datos datos;
Mapa[] mapas = new Mapa[2];

int cantMapas = 1;
int separacion = 2;
String archivo_de_referencia = "datos.csv";
PFont f;

PeasyCam c;
String[] sett;

PGraphics icong;
boolean piramide =false;
boolean rect = false;
boolean proyec= true;
boolean record = false;

void settings() {
  fullScreen(P3D);
  //size(1280, 720, P3D); // 3D
  PJOGL.setIcon("C3D.png");
  smooth();
}

void setup() {
  surface.setResizable(true);
  camaraInterfaz();
  instanciarDatos();
  instanciarFuente();
  pushStyle();
  colorMode(HSB);
  instanciarMapas();
  popStyle();
  setupGUI();
}

void draw() {
  noStroke();
  limpiarPantalla();

  //Grabar
  if (record) {
    String nombreOutput = datos.data[0][mapas[0].SELECTOR].replace("(", "").replace(")", "").replace("%", "");
    mapas[0].map.scale(-1, 1, 1);
    mapas[0].map.rotate(-90);
    beginRaw(DXF, nombreOutput+".dxf");
  }

  desactivarCamara();
  dibujarPrograma();

  //Dejar de grabar
  if (record) {
    endRaw();
    record = false;
    mapas[0].map.scale(-1, 1, 1);
    mapas[0].map.rotate(-90);
  }
}

void arreglarCam() {
  c.setViewport(0, 0, width, height);
  PGraphics3D pg = (PGraphics3D) this.g;
  PJOGL pgl = (PJOGL) pg.beginPGL();
  pg.endPGL();
  pgl.enable(PGL.SCISSOR_TEST);
  pgl.scissor (0, 0, width, height);
  pgl.viewport(0, 0, width, height);
  c.feed();
  perspective(60 * PI/180, width/(float)height, 1, 5000);
}

void mouseReleased() {
  if (mostrarTut) {
    mostrarTut = false;
    lista_datos.open();
  }
}

void camaraInterfaz() {
  c = new PeasyCam(this, 0);
  arreglarCam();
  c.setActive(false);
}

void instanciarDatos() {
  if (datos == null) {
    datos = new Datos(archivo_de_referencia);
  }
}

void instanciarFuente() {
  f = createFont("georgia.ttf", 48, true);
}

void instanciarMapas() {
  String ruta = "argentina_map_simple_expandido_V1.svg";
  for (int i = 0; i < cantMapas; i++) {
    if (mapas[i] == null) {
      mapas[i] = new Mapa(ruta, this, i * (separacion+width/2), 0, (width / cantMapas - (separacion * (i))), height);
      if (mapas[i] == mapas[1]) {
        mapas[1].cambiarDatos(ruta);
      }
      else {
        mapas[i].poblacion = datos.poblacion;
      }
    } else {
      mapas[i].setCam(i * (separacion+width/2), 0, (width / cantMapas - (separacion * (i))), height);
      //mapas[i].renovarDatos();
      mapas[i].cambiarDatos(ruta);

    }
  }
}

void limpiarPantalla() {
  setGLGraphicsViewport(0, 0, width, height);
  background(0);
}

void dibujarPrograma() {
  for (int i = 0; i < cantMapas; i++) {
    pushMatrix();
    mapas[i].dibujar();
    arreglarCam();
    dibujarInterfaz();
    popMatrix();
  }
}

void desactivarCamara() {
  if (cp5.isMouseOver()) {
    for (int i = 0; i < cantMapas; i++) {
      mapas[i].cam.setActive(false);
    }
  } else {
    for (int i = 0; i < cantMapas; i++) {
      mapas[i].cam.setActive(true);
    }
  }
  if (cantMapas == 2) {
    if (mouseX <= mapas[0].dimensionCamX) {
      mapas[1].cam.setActive(false);
      mapas[0].cam.setActive(true);
      //println("cam1 activa");
    }
    else {
      mapas[1].cam.setActive(true);
      mapas[0].cam.setActive(false);
      //println("cam2 activa");
    }
  }
  /*
  else if (cantMapas == 1 && !mapas[0].cam.isActive()) {
    mapas[0].cam.setActive(true);
    //println("cam1 activa");
  }
  */
}

void setGLGraphicsViewport(int x, int y, int w, int h) {
  PGraphics3D pg = (PGraphics3D) this.g;
  PJOGL pgl = (PJOGL) pg.beginPGL();
  pg.endPGL();
  pgl.enable(PGL.SCISSOR_TEST);
  pgl.scissor (x, y, w, h);
  pgl.viewport(x, y, w, h);
}