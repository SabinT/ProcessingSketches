import processing.svg.*;

import controlP5.*;
ControlP5 cp5;

PGraphics pg;

int nextControlYPos = 10;

boolean debugDraw = false;
boolean showControls = true;

ArrayList<BezierCurve> curves = new ArrayList<BezierCurve>();

float Deg2Rad = TWO_PI / 360;

int segments = 10;
float r1 = 317.5; // Distance of 2nd control point from first
float r2 = 400; // Distance of 3rd control point from 4th
float maxAngle1 = 30; // The max angle from the centerline that the 1st control point makes relative to the 2nd
float angleOffset1 = 0;
float maxAngle2 = 75; // The max angle from the centerline that the 3rd control point makes relative to the 4th
float angleOffset2 = 0;
float crossSegments = 8;

float w = 1080, h = 1080;

float leafLength = 685;

void addRangeSlider(String var, float min, float max, float val) {
  controlP5.Slider s = cp5.addSlider(var)
     .setPosition(20, nextControlYPos)
     .setSize(200, 20)
     .setRange(min, max)
     .setValue(val)
     .setColorCaptionLabel(color(200,200,200));

  s.getValueLabel()
     .setFont(font)
     .setSize(14)
     .toUpperCase(false);
   
  s.getCaptionLabel()
     .setFont(font)
     .setSize(14)
     .toUpperCase(false);
     
  nextControlYPos += 30;
}

void addToggle(String var) {
  cp5.addToggle(var)
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
  
  addRangeSlider("leafLength", 0, h, leafLength);
  addRangeSlider("r1", 0, 500, r1);
  addRangeSlider("r2", 0, 500, r2);
  addRangeSlider("maxAngle1", 0, 180, maxAngle1);
  addRangeSlider("maxAngle2", 0, 180, maxAngle2);
  addRangeSlider("angleOffset1", -180, 180, angleOffset1);
  addRangeSlider("angleOffset2", -180, 180, angleOffset2);
  addRangeSlider("segments", 1, 100, segments);
  addRangeSlider("crossSegments", 1, 100, crossSegments);
  addToggle("debugDraw");
}
  
void setup() {
  size(1080, 1080, P2D);
  
  pg = createGraphics(width, height, P2D);

  pg.smooth(8);
  
  pg.beginDraw();

  pg.strokeWeight(4);
  
  buildControlGui();
  
  pg.colorMode(HSB, 255);
  pg.endDraw();
}

void draw() {
  PVector leafStart = new PVector(540, (h - leafLength) / 2); 
  PVector leafEnd = new PVector(540, h - (h - leafLength) / 2); 

  this.curves.clear();
  for (int i = 0; i <= segments; i++) {
    float t = i / (float) segments;
    BezierCurve c = new BezierCurve();
    
    c.a = leafStart;
    
    float angle1 = angleOffset1 + lerp(-maxAngle1, maxAngle1, t); 
    // Note: maxAngle is defined against a vertical line, get angle from horizontal line
    // Also convert to radians
    angle1 = (90 - angle1) * Deg2Rad;

    c.b = new PVector(r1 * cos(angle1), r1 * sin(angle1));
    c.b.add(c.a);
    
    c.d = leafEnd;
    float angle2 = angleOffset2 + lerp(-maxAngle2, maxAngle2, t); // radians
    angle2 = (90 - angle2) * Deg2Rad;
    
    c.c = new PVector(r2 * cos(angle2), r2 * -sin(angle2));
    c.c.add(c.d);
    
    this.curves.add(c);
  }
  
  pg.beginDraw();
  pg.clear();
  pg.background(0);

  if (debugDraw) {
    pg.stroke(150, 150, 150);
    pg.strokeWeight(1);
    pg.noFill();
    pg.circle(leafStart.x, leafStart.y, r1 * 2);
    pg.circle(leafEnd.x, leafEnd.y, r2 * 2);
  }

  for (BezierCurve c: this.curves) {
    c.Draw(pg);
  }
  
  // Draw a "horizontal lines" along the length of the bands.
  // A "band" is the space between two vertical lines.
  // There are (n - 1) bands for (n) lines
  float tStep = 1.0f / crossSegments;
  for (int band = 0; band < this.curves.size() - 1; band++) {
    // Start odd segments at an offset
    float t = (millis() / 20000f + (band % 2 == 0 ? 0 : tStep / 2)) % tStep;
    while (t < 1) {
      BezierCurve curve = this.curves.get(band);
      PVector a = curve.Evaluate(t);
      PVector b = this.curves.get(band + 1).Evaluate(t);
      
      pg.stroke(lerpColor(curve.startCol, curve.endCol, t));
      pg.strokeWeight(2);
      pg.line(a.x, a.y, b.x, b.y);
      t += tStep;
    }
  }
  
  pg.endDraw();
  
  image(pg, 0, 0);
  
}

void keyPressed() {  
  // Add chemicals to the scene
  if (key == 'C' || key == 'c') {
    showControls = !showControls;
    if (showControls) {
      cp5.show();
    } else {
      cp5.hide();
    }
  }
  
  if (key == 'S' || key == 's') {
    pg.save("output.png");
  }
}



// 4-Point (Cubic) Bezier curve
class BezierCurve {
  public PVector a, b, c, d; // control points
  
  public color startCol = color(150, 255, 255);
  public color endCol =  color(100, 255, 255);
  
  private ArrayList<PVector> points;
  private ArrayList<Integer> colors;
  
  public BezierCurve() {
    this.points = new ArrayList<PVector>();
    this.colors = new ArrayList<Integer>();
  }
  
  private PVector Lerp(PVector a, PVector b, float t) {
    PVector result = new PVector(a.x, a.y, a.z);
    result.lerp(b, t);
    return result;
  }
  
  private void DrawLine(PGraphics pg, PVector a, PVector b, color c) {
    pg.strokeWeight(2);
    pg.stroke(c);
    pg.line(a.x, a.y, b.x, b.y);
  }
  
  public PVector Evaluate(float t) {
    // De Casteljau’s algorithm
    // Evaluate 3 points at position 't' between a->b, b->c, and c->d
    PVector p1 = Lerp(a, b, t);
    PVector p2 = Lerp(b, c, t);
    PVector p3 = Lerp(c, d, t);
    
    // Now, evaluate 2 points at position 't' between p1->p2, p2->p3
    PVector q1 = Lerp(p1, p2, t);
    PVector q2 = Lerp(p2, p3, t);
    
    // The position at 't' on the final segment is the point on the curve
    return Lerp(q1, q2, t);
  }
  
  // Build line segments for rendering
  private void Evaluate() {
    this.points.clear();
    this.colors.clear();
    
    int segments = 50;
    for (int i = 0; i <= segments; i++) {
      float t = i / (float) segments;
      
      this.points.add(this.Evaluate(t));
      this.colors.add(lerpColor(this.startCol, this.endCol, t));
    }
  }
  
  void Draw(PGraphics pg) {
    this.Evaluate();
    
    strokeWeight(4);
    for(int i = 0; i < this.points.size() - 1; i++) {
      this.DrawLine(pg, this.points.get(i), this.points.get(i + 1), this.colors.get(i));
    }
    
    if (debugDraw) {
      // draw control points
      pg.strokeWeight(1);
      color debugCol = color(150,150,150);
      this.DrawLine(pg, this.a, this.b, debugCol);
      this.DrawLine(pg, this.b, this.c, debugCol);
      this.DrawLine(pg, this.c, this.d, debugCol);
      
      float diameter = 10;
      pg.stroke(0);
      pg.strokeWeight(2);
      pg.fill(255);
      pg.circle(a.x, a.y, diameter);
      pg.circle(b.x, b.y, diameter);
      pg.circle(c.x, c.y, diameter);
      pg.circle(d.x, d.y, diameter);
    }
  }
}
