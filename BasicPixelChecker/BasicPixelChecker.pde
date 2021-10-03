void setup() {
  size(256, 455);
  
  color black = color(0);
  color white = color(255);
  
  for (int x = 0; x < 256; x++) {
    for (int y = 0; y < 455; y++) {
      set(x, y, (x + y) % 2 == 0 ? white : black);
    }
  }
  
  save("checker.png");
}
