void setup() {
  size(1080, 1080);
  smooth(8);
  strokeWeight(4);
  
  buildControlGui();
  
  colorMode(HSB, 255);
}

void draw() {
  clear();
  background(255);
}
