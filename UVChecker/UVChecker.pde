
void setup() {
  size(1024, 1024);
  
  PFont font;
  // The font must be located in the sketch's 
  // "data" directory to load successfully
  font = createFont("Arial", 500);
  textFont(font);
  
  int w = 1024;
  int h = 1024;
  
  color[] colors = new color[5];
  colors[0] = #B08F7F;
  colors[1] = #FFF1EB;
  colors[2] = #FCDDCE;
  colors[3] = #6DB0AB;
  colors[4] = #CFFCF9;
    
  color black = #222222;
  color white = #cccccc;
  
  int segments = 8;
  int segmentHeight = h / segments;
  
  float rw = w / 8.0f;
  float rh = h / 8.0f;
  
  int colIndex = 0;
  for (int x = 0; x < 8; x++) {
    for (int y = 0; y < 8; y++) {
      int nx = x + 1;
      int ny = y + 1;
      
      String text = Character.toString((char)('A' + x)) + "" + y;
      
      fill(colors[colIndex]);
      noStroke();
      rect(x * rw, y * rh, nx * rw, ny * rh); 

      textAlign(CENTER, CENTER);
      textSize(50);

      fill(black);
      //text(text, 2 + (x + 0.5) * rw, 2 + (y + 0.5) * rh);

      fill(black);
      text(text, (x + 0.5) * rw, (y + 0.5) * rh);

      colIndex = (colIndex + 1) % 5;
    }
    
    colIndex = (colIndex + 1) % 5;
  }
  
  save("checker.png");
}
