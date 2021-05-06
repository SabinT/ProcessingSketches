color red = color(255, 0, 0);
color black = color(0, 0, 0);
color white = color(255, 255, 255);

int w = 1000;
int h = 1000;

Circle boundingCircle;
ArrayList<Circle> circles;

// This code runs once at the start of the program.
// You can use this for one-time setup/calculations.
void setup() {
  size(1000, 1000);
  
  boundingCircle = new Circle();
  boundingCircle.center = new PVector(500, 500);
  boundingCircle.radius = 400;
  boundingCircle.col = white;
  
  circles = new ArrayList<Circle>();
  
  // Spawn some circles at random locations
  for (int i = 0; i < 10; i++) {
    Circle c = new Circle();
    float x = random(0, 1000);
    float y = random(0, 1000);
    
    // See this reference page for convenience functions available with PVector
    // (e.g., calculating distance between two points)
    // https://processing.org/reference/PVector.html
    c.center = new PVector(x,y);

    // TODO 1: Make sure new circles are added only if they
    // don't overlap existing circles.
    // TODO 2: Maximize the radius of new circles (with a reasonable limit)
    // TODO 3: Also make sure the circles all inside a larger outer circle
    // centered at 500, 500 and with diameter 800.
    c.radius = 20;
    
    // Set a random gray value. TODO experiment with other color variations
    c.col = color(random(0, 255));
    circles.add(c);
  }
}

// This code runs several times per second, redrawing with every execution
// You can use this for animations.
void draw() {
  // Draw the outer circle centered at x=500, y=500, diameter=800
  // Black outline, filled white
  stroke(black);
  fill(white);
  circle(500, 500, 800);
  
  // Draw the bounding circle
  boundingCircle.draw();
  
  // Draw all circles in the list
  for (Circle c: circles) {
    c.draw();
  }
}

class Circle {
  // PVector is a 3-component vector and has (x,y,z). z is unused in this program.
  public PVector center;
  public float radius;
  public color col;
  
  public void draw() {
    stroke(black);
    fill(this.col);
    circle(center.x, center.y, this.radius * 2);
  }
}
