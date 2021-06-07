import controlP5.*;
ControlP5 cp5;

boolean controlsVisible =  true;

int nextControlYPos = 10;

boolean debugDraw = true;

float Deg2Rad = TWO_PI / 360;

int segments = 10;
float r1 = 317.5; // Distance of 2nd control point from first
float r2 = 400; // Distance of 3rd control point from 4th
float maxAngle1 = 30; // The max angle from the centerline that the 1st control point makes relative to the 2nd
float angleOffset1 = 0;
float maxAngle2 = 75; // The max angle from the centerline that the 3rd control point makes relative to the 4th
float angleOffset2 = 0;
float powerFactor = 1;
float spiralStep = 10;

float petalLength = 685;

void addRangeSlider(String var, float min, float max, float val) {
  controlP5.Slider s = cp5.addSlider(var)
    .setPosition(20, nextControlYPos)
    .setSize(200, 20)
    .setRange(min, max)
    .setValue(val)
    .setColorCaptionLabel(color(20,20,20));

  s.getValueLabel()
    .setFont(font)
    .setSize(20)
    .toUpperCase(false);
   
  s.getCaptionLabel()
    .setFont(font)
    .setSize(20)
    .toUpperCase(false);
     
  nextControlYPos += 30;
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
  
  addRangeSlider("petalLength", 0, h, petalLength);
  addRangeSlider("r1", 0, 500, r1);
  addRangeSlider("r2", 0, 500, r2);
  addRangeSlider("maxAngle1", 0, 180, maxAngle1);
  addRangeSlider("maxAngle2", 0, 180, maxAngle2);
  addRangeSlider("angleOffset1", -180, 180, angleOffset1);
  addRangeSlider("angleOffset2", -180, 180, angleOffset2);
  addRangeSlider("segments", 1, 100, segments);
  addRangeSlider("powerFactor", -10, 10, powerFactor);
  addRangeSlider("spiralStep", -50, 50, spiralStep);
  addToggle("debugDraw");
}
