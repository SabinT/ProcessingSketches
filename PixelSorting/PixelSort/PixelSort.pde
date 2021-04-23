PImage image;

int w = 800;
int h = 800;

void setup(){
  size(800, 800, P2D);
  
  image = loadImage("galaxy.jpeg");
}

void draw() {
  // Make sure that pixels[] has data
  image.loadPixels();
    
  // Horribly inefficient O(n^2) sort, but makes for a nice animation
  for (int i = 0; i < image.width; i++) {
    for (int j = 0; j < image.height - 1; j++) {
      color c = image.pixels[j * image.width + i];
      
      int nj = j + 1;
      color nc = image.pixels[nj * image.width + i];
      
      float bc = brightness(c);
      float bnc = brightness(nc);
      
      // Do not sort pixels based on a brightness threshold
      // Add some noise to the threshold
      float t = 80 - noise(i,j) * 10;
      
      if (bc > t && bc > t && bc < bnc) {
        // Swap pixels
        image.pixels[j * image.width + i] = nc;
        image.pixels[nj * image.width + i] = c;
      }
    }
  }
  
  // Make sure changes to "pixels[]" is applied back to the image
  image.updatePixels();

  // Draw the image
  image(image, 0, 0, w, h);
}
