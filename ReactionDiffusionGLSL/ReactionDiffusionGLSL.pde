PGraphics buffer0;
PGraphics buffer1;
PShader diff;
PShader colorify;
PImage seedImage;
boolean showHelp = true;

// Channel R = Chemical A, Channel G = Chemical B
void seedB() {
  // Add a little bit of Chemical B (Green)
  buffer0.beginDraw(); //<>//
  buffer0.blendMode(ADD);
  
  buffer0.tint(0, 255, 0);
  buffer0.image(seedImage, 0, 0, width, height);
  buffer0.noTint();
  noTint();
  
  buffer0.endDraw();
}

void seedA() {
  buffer0.beginDraw(); //<>//
  buffer0.blendMode(ADD);
  
  buffer0.tint(255, 0, 0);
  buffer0.image(seedImage, 0, 0, width, height);
  buffer0.noTint();
  
  buffer0.endDraw();
}

void fillWithA() {
  buffer0.beginDraw();
  buffer0.blendMode(BLEND);
  buffer0.background(255, 0, 0);
  buffer0.endDraw();
}

void setup(){
  size(800, 800, P2D);
  seedImage = loadImage("DONTHATE.png");
  buffer0 = createGraphics(width, height, P2D);
  buffer1 = createGraphics(width, height, P2D);

  diff = loadShader("rd.glsl");
  colorify = loadShader("colorify.glsl");
 
  // Using normalized pixel size as the grid spacing for Laplacian calculation
  diff.set("deltaU", 1.0/width);
  diff.set("deltaV", 1.0/height);

  // Fill the buffer with Chemical A (Red)
  fillWithA();
  
  // Insert some amount of B to start the reaction
  seedB();
}

void keyPressed() {  
  // Add chemicals to the scene
  if (key == 'A' || key == 'a') {
    seedA();
  }
  
  if (key == 'B' || key == 'b') {
    seedB();
    // seedBCircle();
  }
  
  if (key == 'C' || key == 'c') {
    fillWithA();
  }
  
  if (key == 'H' || key == 'h') {
    showHelp = !showHelp;
  }
}

void mouseDragged() {
  buffer0.beginDraw();
  buffer0.blendMode(BLEND);
  
  buffer0.noStroke();
  buffer0.fill(0, 255, 0);
  buffer0.ellipse(mouseX, mouseY, 20, 20);
  
  buffer0.endDraw();
}

void draw(){
  // This runs the reaction-diffusion step, and saves the result in buffer0
  buffer0.beginDraw();
  buffer0.blendMode(BLEND);
  buffer0.shader(diff);
  buffer0.image(buffer0, 0, 0);
  buffer0.resetShader();
  buffer0.endDraw();
 
  // This reads the chemical channels (R, G) and produces a colored image
  buffer1.beginDraw();
  buffer1.blendMode(BLEND);
  buffer1.shader(colorify);
  buffer1.image(buffer0, 0, 0);
  buffer1.resetShader();
  buffer1.endDraw();
  image(buffer1, 0, 0);
  
  if (showHelp) {
    text("Controls", 10, 20);
    text("A: Add chemical A (based on image)", 10, 40);
    text("B: Add chemical B (based on image)", 10, 60);
    text("C: Clear screen with chemical A", 10, 80);
    text("H: Show/hide help", 10, 100);
    text("Click and drag with mouse to inject chemical B", 10, 120);
  }
  
  // Uncomment to visualize the seed image
  //blendMode(ADD);
  //image(seedImage, 0, 0, width, height);
}
