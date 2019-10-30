class Datos {

  String[] valores;
  String[] linea;
  String[][] data;

  String [] provincias = {"caba-big", "buenos-aires", "catamarca", "chaco", 
    "chubut", "cordoba", "corrientes", "entre-rios", 
    "formosa", "jujuy", "la-pampa", "la-rioja", 
    "mendoza", "misiones", "neuquen", "rio-negro", 
    "salta", "san-juan", "san-luis", "santa-cruz", 
    "santa-fe", "santiago-del-estero", "tierra-del-fuego", 
    "tucuman"};
    
  float[] poblacion;

  float maxPoblacion; //= 15625084; //BsAs.
  float minPoblacion; //= 127205; // Tierra del Fuego
  
  int cantDatosNuevos = 0;
  int cantDatosEco = 9;

  Datos(String s) {
    linea = loadStrings(s);
    agregarArchivo();
    crearDatos();
    poblacion = new float[data.length-1];
  }
  
  void agregarArchivo() {
    String archivo2 = "nuevosdatos.csv";
    String[] l = loadStrings(archivo2);
    cantDatosNuevos = l.length;
   for (int i = 0; i < cantDatosNuevos; i++) {
      valores = split (l[i], ';');
      for (int j = 0; j < valores.length; j++) {
        linea[j] = linea[j]+';'+valores[j]; 
      }
    }
  }
  
  void renovarDatos(int SELECCION) {
    getPoblacion(SELECCION);
    //getMaximo();
    //getMinimo();
  }

  void crearDatos() {
    valores = split (linea[0], ';');
    
    data = new String[linea.length][valores.length];

    //Cantidad de filas encontradas en el archivo
    for (int i = 0; i < linea.length; i++) {
      valores = split (linea[i], ';');

      //Cantidad de columnas que tiene el archivo
      for (int j = 0; j < valores.length; j++) {
        data[i][j] = valores[j];
      }
    }
  }
  
  void getPoblacion(int SELECCION) {
    for (int i = 1; i < data.length; i++) {
      //println(data[i][SELECCION]);
      String s = data[i][SELECCION].replace(",", ".");
      //println(i, s);
      poblacion[i-1] = float(s); 
    }
    //print(data[1][SELECCION]);
  }
  
  void setMaximo(int seleccion) {
    float segundoMax = 0;
    float acum = 0;
    switch (seleccion) {
      
      case 0: //Valor por defecto donde maximo equivale a la provincia con dato maximo
      for (int i = 0; i < poblacion.length; i++) {
        if (i == 0 || maxPoblacion < poblacion[i]) {
          maxPoblacion = poblacion[i];
        }
      }
      break;
      
      case 1: //Donde la provincia maxima es igual al segundo maximo
      segundoMax = minPoblacion;
      for (int i = 0; i < poblacion.length; i++) {
        if (maxPoblacion != poblacion[i] && segundoMax < poblacion[i] ) {
          segundoMax = poblacion[i];
        }
      }
      maxPoblacion = segundoMax;
      break;
      
      case 2: 

      for (int i = 0; i < poblacion.length; i++) {
        acum += poblacion[i];
      }
      acum = acum / poblacion.length;
      maxPoblacion = acum;
      break;
      
      default:
      break;
    }

  }
  
  void setMinimo(int selector) {
    switch (selector) {
      case 0:
      for (int i = 0; i < poblacion.length; i++) {
        if (i == 0 || minPoblacion > poblacion[i]) {
          minPoblacion = poblacion[i];
        }
      }
      break;
      
      case 1:
      break;
      
      case 2: 
        minPoblacion = 0;
      break;
      
      default:
      
      break;
    }
  }

  void getMaximo() {
    for (int i = 0; i < poblacion.length; i++) {
      if (i == 0 || maxPoblacion < poblacion[i]) {
        maxPoblacion = poblacion[i];
      }
    }
  }

  void getMinimo() {
    for (int i = 0; i < poblacion.length; i++) {
      if (i == 0 || minPoblacion > poblacion[i]) {
        minPoblacion = poblacion[i];
      }
    }
  }
}