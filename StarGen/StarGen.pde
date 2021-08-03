int constellationsGenerated = 0;

float w = 1080;
float h = 1080;

ArrayList<Constellation> constellations = new ArrayList<Constellation>();
ArrayList<Star> stars = new ArrayList<Star>();

void setup() {
  size(1080, 1080);
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
      PVector p = new PVector(random(r2, w - r2), random(r2, h - r2));

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
    PVector p = new PVector(random(padding, w - padding), random(padding, h - padding));
    
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
  
  clear();
  background(0);
  
  for(Constellation c: constellations) {
    c.Draw();
  }
  
  for(Star s: stars) {
    s.Draw();
  }
}

void keyPressed() {
  if (key == 'G' || key == 'g') {
    generate();
  }
  
 if (key == 'c' || key == 'C') {
    controlsVisible = !controlsVisible;
 }
 
 if (controlsVisible) {
   cp5.show();
 } else {
   cp5.hide();
 }
}
