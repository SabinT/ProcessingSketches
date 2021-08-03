import controlP5.*;
ControlP5 cp5;

boolean controlsVisible =  true;
int nextControlYPos = 10;
int controlYStep = 22;
int controlColor = color(255);
int controlFontSize = 12;

boolean debugDraw = true;

float Deg2Rad = TWO_PI / 360;

int nStars = 1000; // max number of stars
int nConstellations = 10; // number of constellations to seed the scene with 

int starsPerGroupMin = 2; // min number of start per constellation
int starsPerGroupMax = 6; // max #stars per constellation

float r1 = 45; // Constellation min influence distance
float r2 = 75; // Constellation max influence distance

void addRangeSlider(String var, float min, float max, float val) {
  controlP5.Slider s = cp5.addSlider(var)
    .setPosition(20, nextControlYPos)
    .setSize(200, 20)
    .setRange(min, max)
    .setValue(val)
    .setColorCaptionLabel(color(20,20,20));

  s.getValueLabel()
    .setFont(font)
    .setSize(controlFontSize)
    .toUpperCase(false);
   
  s.getCaptionLabel()
    .setFont(font)
    .setSize(20)
    .toUpperCase(false)
    .setColor(controlColor);
     
  nextControlYPos += controlYStep;
}

void addButton(String functionName) {
  controlP5.Button b = cp5.addButton(functionName)
    .setPosition(20, nextControlYPos)
    .setSize(200,19);
    
  b.getValueLabel()
    .setFont(font)
    .setSize(controlFontSize)
    .toUpperCase(false);
   
  b.getCaptionLabel()
    .setFont(font)
    .setSize(20)
    .toUpperCase(false)
    .setColor(controlColor);

  nextControlYPos += controlYStep;
}

void addToggle(String var) {
  cp5.addToggle(var)
    .setPosition(20, nextControlYPos)
    .setSize(50,20);
     
  nextControlYPos += 30;
}

void addLabel(String label) {
  cp5.addLabel(label)     
    .setPosition(20, nextControlYPos)
    .setSize(50,20);
     
  nextControlYPos += 30;
}

PFont pfont;
ControlFont font;

void buildControlGui() {
  cp5 = new ControlP5(this);
  
  pfont = createFont("Lekton",10,true); // use true/false for smooth/no-smooth
  font = new ControlFont(pfont,241);
  
  addRangeSlider("nStars", 0, 10000, nStars);
  addRangeSlider("nConstellations", 0, 20, nConstellations);
  
  addRangeSlider("r1", 0, 100, r1);
  addRangeSlider("r2", 0, 100, r2);
  
  addRangeSlider("starsPerGroupMin", 2, 10, starsPerGroupMin);
  addRangeSlider("starsPerGroupMax", 2, 10, starsPerGroupMax);

  addButton("generate");
  // addToggle("debugDraw");
}
