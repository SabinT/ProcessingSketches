class Petal {
  public ArrayList<BezierCurve> curves = new ArrayList<BezierCurve>();
  
  // Degrees
  public float rotation = 0;
  
  public PVector translation = new PVector(0,0);
  
  public float scale = 1;
  
  public void Draw() {
    PVector leafStart = new PVector(0, -petalLength / 2); 
    PVector leafEnd = new PVector(0, petalLength / 2); 
  
    this.curves.clear();
    PVector previousStart = new PVector(leafStart.x, leafStart.y);
    PVector previousEnd = new PVector(leafEnd.x, leafEnd.y);
    
    for (int i = 0; i <= segments; i++) {
      float t = i / (float) segments;
      BezierCurve curve = new BezierCurve();
      
      float currentLeafScale = (float) Math.pow(previousStart.dist(previousEnd) /  petalLength, powerFactor);
      
      // Change the start/end pos successively for even/odd vertices.
      int even = 1 - i % 2;
      int odd = i % 2;
      PVector startOffset = new PVector(0, even * i/2 * spiralStep); 
      PVector endOffset = new PVector(0, -odd * i/2 * spiralStep); 
      
      curve.a = new PVector(previousStart.x, previousStart.y);
      previousStart.add(startOffset);
      
      // Alternate the direction between left and right
      float angle1 = angleOffset1 + ((i % 2) == 0 ? -maxAngle1 : maxAngle1);
      
      // Note: maxAngle is defined against a vertical line, get angle from horizontal line
      angle1 = radians(90 - angle1);
  
      curve.b = new PVector(currentLeafScale * r1 * cos(angle1), currentLeafScale * r1 * sin(angle1));
      curve.b.add(curve.a);
      
      curve.d = new PVector(previousEnd.x, previousEnd.y);
      previousEnd.add(endOffset);
      
      float angle2 = angleOffset2 + ((i % 2) == 0 ? -maxAngle2 : maxAngle2);
      angle2 = radians(90 - angle2);
      
      curve.c = new PVector(currentLeafScale * r2 * cos(angle2), currentLeafScale * r2 * -sin(angle2));
      curve.c.add(curve.d);
      
      this.curves.add(curve);
    }
    
    pushMatrix();
    translate(this.translation.x, this.translation.y);
    rotate(radians(this.rotation));
    scale(this.scale);
    
    for (BezierCurve c: this.curves) {
      c.Draw();
    }
    
    popMatrix();
  }

}
