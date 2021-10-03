int constellationsGenerated = 0;

PGraphics render;

int rw = 4000;
int rh = 4000;

float w = 1080;
float h = 1080;

ArrayList<Constellation> constellations = new ArrayList<Constellation>();
ArrayList<Star> stars = new ArrayList<Star>();

void setup() {
  size(1080, 1080);
  render = createGraphics(rw, rh);
  
  smooth(8);
  strokeWeight(4);
  
  buildControlGui();
  
  colorMode(HSB, 255);
}

boolean isGenerating = false;
int lastGenerationTime;
int generationDelayMillis = 0;
int starsGeneratedPerFrame =  30;

void generate() {
  constellations.clear();
  stars.clear();
  
  int maxAttempts = 1000;
  for(int i = 0; i < nConstellations; i++) {
    int j = 0;
    while (j++ <= maxAttempts) {
      // Using r2 as padding to make sure coordinates of stars that will get added to constellation  //<>//
      // always lie inside the screen
      PVector p = new PVector(random(r2, rw - r2), random(r2, rh - r2));

      // Make sure this point isn't too close to existing constellations
      boolean tooClose = false;
      for (Constellation c: constellations) {
        if (c.CheckInfluence(p, true)) {
          // Too close, try again
          
          tooClose = true;
          break;
        }
      }
      
      if (!tooClose) {
        Constellation c = new Constellation("C" + i, p, r1, r2);
        constellations.add(c);
        break;
      }
    }
  }
  
  // Kick off one-by-one star generation
  isGenerating = true;
  lastGenerationTime = millis();
}

void generateNewStarIfNeeded() {
    int padding = 10;
    PVector p = new PVector(random(padding, rw - padding), random(padding, rh - padding));
    
    Star s = new Star(p, color(random(100, 255)));
    stars.add(s);
    
    for (Constellation c: constellations) {
      c.AddStarIfCloseEnough(s);
    }
    
    lastGenerationTime = millis();
}

void draw() {
  // See if there's stars left to generate
  if (isGenerating && 
    stars.size() < nStars &&
    millis() > lastGenerationTime + generationDelayMillis
  ) {
    for (int i = 0; i < starsGeneratedPerFrame; i++) {
      generateNewStarIfNeeded();
    }
  }
  else {
    isGenerating = false;
  }
  
  render.beginDraw();
  
  render.clear();
  render.background(0);
  
  for(Constellation c: constellations) {
    c.Draw(render);
  }
  
  for(Star s: stars) {
    s.Draw(render);
  }
  
  render.endDraw();
  
  image(render, 0, 0, w, h);
}

void keyPressed() {
  if (key == 'G' || key == 'g') {
    generate();
  }
  
 if (key == 'c' || key == 'C') {
    controlsVisible = !controlsVisible;
 }
 
   switch (key) {
    case 's':
      String dateString = String.format("Star_%d-%02d-%02d %02d.%02d.%02d",
        year(), month(), day(), hour(), minute(), second());
      saveFrame(dateString + ".scr.png");
      render.save(dateString + ".png");
      break;
  }
 
 if (controlsVisible) {
   cp5.show();
 } else {
   cp5.hide();
 }
}
