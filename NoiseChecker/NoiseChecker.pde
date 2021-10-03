Random rand = new Random();

float f() {
  return rand.nextFloat();
}


void setup() {
  size(512, 1024);
  
  int w = 512;
  int h = 1024;
  
  color black = color(0);
  color white = color(255);
  
  int segments = 8;
  int segmentHeight = h / segments;
  
  
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      int segment = y / segmentHeight;
      
      float val;
      switch (segment) {
        case 0:
          val = f();
          break;
        
        case 1:
          val = f() - f();
          break;
        
        case 2:
          val = 0.5f * (f() + f());
          break;

        case 3:
          val = (float) Math.pow(f(), f());
          break;

        case 4:
          val = (float) Math.pow(f(), f());
          val = (float) Math.pow(val, f());
          break;

        case 5:
          set(x, y, color(randomToTheRandomToTheRandom(x, y) * 255));
          break;
          
        case 6:
          
          break;

        case 7:
          set(x, y, color(oneMinusRandomToTheRandom(x, y) * 255));
          break;

      }
      
      set(x, y, color(val));
    }
  }
  
  save("checker.png");
}
