import processing.pdf.*; 
import java.util.Map; 

HashMap<String, Float> countries_hm = new HashMap<String, Float>();

Table table; 
float diam; 
int r, p; 
boolean darkMode = true;
float back = 0.1; 
float line = 1.0; 

PVector [] data_points; 
String [] data_point_names;
float [] data_point_size;

PFont helvetica;

public void settings() {
  size(1000, 700);
  //size(1000, 700, PDF, "GLOBAL-EMISSIONS_1993-2012.pdf");
}

void setup() {

  table = loadTable("fossil-fuel-co2-emissions-by-nation.csv", "header");

  println(table.getRowCount() + " total rows in table."); 

  for (TableRow row : table.rows()) {
    float year = row.getFloat("Year"); 
    if (year >= 1993 && year <= 2012) {
      r++;
    }
  }
  println("Total rows: " + r);
  int number_of_points = r; // 4313
  data_points = new PVector [number_of_points]; 
  data_point_names = new String[number_of_points];
  data_point_size = new float[number_of_points];

  for (TableRow row : table.rows()) {
    int year = row.getInt("Year"); 
    String country = row.getString("Country"); 
    int emission = row.getInt("Total");
    if (year >= 1993 && year <= 2012) {

      String c = country;
      //println (c);
      if (!countries_hm.containsKey(c)) {
        countries_hm.put(c, random(1.0));
      }

      float y = map(year, 1993, 2012, height-60, 80); 
      float yDraw = random(y-10, y+10);
      float x = random(75, width-60);
      diam = map(emission, 0, 3000000, 3, 100); 

      data_points[p] = new PVector(x, yDraw);
      data_point_names[p] = country + ", " + emission + " MMT";
      data_point_size[p] = diam;

      p++;
    } 
    colorMode(HSB, 1.0);
  }
  
  println("Total countries: " + countries_hm.size());

  helvetica = createFont("Helvetica-Bold", 12);
  textFont(helvetica);
}


void draw() {
  background(back);
  noStroke();

  PVector mouse_loc = new PVector(mouseX, mouseY);

  for (int i = 0; i < data_points.length; i++) {    
    // ASSIGN HSB VALUE TO COUNTRY
    for (Map.Entry m : countries_hm.entrySet()) {
      String s = (String)m.getKey(); 
      if (data_point_names[i].contains(s)) {
        float h = (float)m.getValue();
        fill(h, 1, 1, 1);
      }
    }
    
    // DRAW POINT
    ellipse(data_points[i].x, data_points[i].y, data_point_size[i], data_point_size[i]);
    
    // HIGHLIGHT RISK COUNTRY
    if (data_point_names[i].contains("HONDURAS") || data_point_names[i].contains("MYANMAR") || 
      data_point_names[i].contains("HAITI") || data_point_names[i].contains("NICARAGUA") || 
      data_point_names[i].contains("BANGLADESH") || data_point_names[i].contains("VIET NAM")
      || data_point_names[i].contains("PHILIPPINES") || data_point_names[i].contains("DOMINICAN REPUBLIC") 
      || data_point_names[i].contains("MONGOLIA") || data_point_names[i].contains("THAILAND")
      || data_point_names[i].contains("GUATEMALA")) {
      stroke(line);
      noFill();
      rect(data_points[i].x - (data_point_size[i]/2)-1, data_points[i].y - (data_point_size[i]/2)-1, data_point_size[i]+2, data_point_size[i]+2);
    }
    
    // KEY RECTANGLE
    stroke(line);
    noFill();
    rect(50, 55, 5, 5);

    noStroke();
    textAlign(RIGHT);
    textSize(12);
    if (mouse_loc.dist(data_points[i]) < diam) {
      // COUNTRY TEXT
      text(data_point_names[i], width-500, height-40, 450, 100);
    }
  }

  textAlign(LEFT);
  
  // TITLE TEXT
  String title = "GLOBAL C02 EMISSIONS";
  text(title,50,40);
  
  textSize(8);
  for (int i = 1993; i <= 2012; i++) {
    float y = map(i, 1993, 2012, height-60, 80); 
    // Y AXIS TEXT
    text(i, 50, y);
    
    // KEY TEXT
    String key_risk = "= MOST IMPACTED";
    text(key_risk, 60, 60);
  }
  
  //println("DRAW LOOP FINISHED");
  //exit();
}

void mouseClicked(){
  darkMode = !darkMode; 
  if(!darkMode){
    back = 1.0; 
    line = 0.0; 
  }
  else{
    back = 0.1; 
    line = 1.0; 
  }
}
