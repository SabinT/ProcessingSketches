import processing.svg.*;

boolean exportSvgRequest = false;

ArrayList<BezierCurve> curves = new ArrayList<BezierCurve>();
ArrayList<Petal> petals = new ArrayList<Petal>();

float w = 1080;
float h = 1080;

float goldenAngle = 137.507764;

void setup() {
  size(1080, 1080);
  smooth(8);
  strokeWeight(4);
  
  buildControlGui();
  
  colorMode(HSB, 255);
  
  float currentAngle = 0;
  float angleStep = 60;
  float petalDistance = 200;
  float petalScale = 0.75;
  for (int i = 0; i < 6; i++) {
    Petal p = new Petal(); // This is why Java sucks, horrible initializer syntax
    
    p.rotation = currentAngle;
    
    p.translation = new PVector(w/2 + cos(radians(90 - currentAngle)) * petalDistance, h/2 - sin(radians(90 - currentAngle)) * petalDistance);
    
    p.scale = petalScale;
    
    this.petals.add(p);
    
    currentAngle += angleStep;
  }
}

void draw() {
  clear();
  background(255);
  
  for(Petal p: this.petals) {
    p.Draw();
  }
}
