class Constellation {
  public Constellation(String name, PVector center, float minRadius, float maxRadius) {
    this.center = center;
    this.radius = random(minRadius, maxRadius);
    this.name = name;
    
    this.maxStars = (int) random(starsPerGroupMin, starsPerGroupMax);
  }
  
  private int maxStars;
  
  private String name = "";
  
  // This is used to seed the constellations, and used for proximity checks when adding
  // new stars to the constellation
  private PVector center;
  
  // The min, max radius from the center. A random value in [r1, r2] is used for influence check
  private float radius;
  
  private ArrayList<Star> stars = new ArrayList<Star>();
  
  public void AddStarIfCloseEnough(Star star) {
    if (this.CheckInfluence(star.position, false) && this.stars.size() <= this.maxStars) { 
      this.stars.add(star);
    }
  }
  
  // Check if the given position is within the "influence" of the constellation,
  public boolean CheckInfluence(PVector pos, boolean diameter) {
    PVector pos2 = new PVector(pos.x, pos.y);
    
    // TODO for complete accuracy when checking intersection with another constellation,
    // need to know the radius of the other constellation
    return (pos2.sub(this.center)).mag() <  (diameter ? this.radius * 2 : this.radius);
  }
  
  public void Draw(PGraphics g) {
    // Draw the name of the constellation
    g.fill(color(255));
    g.textAlign(CENTER, CENTER);
    g.text(this.name, this.center.x, this.center.y);
    
    if (debugDraw) {
      g.noFill();
      g.stroke(100);
      g.strokeWeight(0.5);
      g.circle(this.center.x, this.center.y, this.radius * 2);
    }
    
    // Draw lines from one start to another, in order.
    // Also draw an outline circle around each star
    for(int i = 0; i < this.stars.size(); i++) {
      Star a = this.stars.get(i);

      g.noFill();
      g.strokeWeight(2);
      g.stroke(color(255));
      g.circle(a.position.x, a.position.y, a.radius * 4);

      if (i > 0) {
        Star b = this.stars.get(i - 1);
        g.strokeWeight(1);
        g.line(a.position.x, a.position.y, b.position.x, b.position.y);
      }
    }
  }
}
