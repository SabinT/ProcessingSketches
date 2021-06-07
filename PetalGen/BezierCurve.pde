// 4-Point (Cubic) Bezier curve
class BezierCurve {
  public PVector a, b, c, d; // control points
  
  public color startCol = color(0, 255, 150);
  public color endCol =  color(25, 255, 200);
  
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
  
  private void DrawLine(PVector a, PVector b, color c) {
    stroke(c);
    line(a.x, a.y, b.x, b.y);
  }
  
  public PVector Evaluate(float t, boolean debugDraw) {
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
      
      this.points.add(this.Evaluate(t, false));
      this.colors.add(lerpColor(this.startCol, this.endCol, t));
    }
  }
  
  void Draw() {
    this.Evaluate();
    
    strokeWeight(4);
    for(int i = 0; i < this.points.size() - 1; i++) {
      this.DrawLine(this.points.get(i), this.points.get(i + 1), this.colors.get(i));
    }
    
    if (debugDraw) {
      // draw control points
      strokeWeight(1);
      color debugCol = color(150,150,150);
      this.DrawLine(this.a, this.b, debugCol);
      this.DrawLine(this.b, this.c, debugCol);
      this.DrawLine(this.c, this.d, debugCol);
      
      float diameter = 10;
      stroke(0);
      strokeWeight(2);
      fill(255);
      circle(a.x, a.y, diameter);
      circle(b.x, b.y, diameter);
      circle(c.x, c.y, diameter);
      circle(d.x, d.y, diameter);
    }
  }
}
