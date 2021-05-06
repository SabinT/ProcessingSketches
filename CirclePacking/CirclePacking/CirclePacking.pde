color red = color(255, 0, 0);
color black = color(0, 0, 0);
color white = color(255, 255, 255);

int w = 1000;
int h = 1000;

int circleCount = 100;
ArrayList<Circle> circles;

Circle boundingCircle;

// This code runs once at the start of the program.
// You can use this for one-time calculations.
void setup() {
  size(1000, 1000);
  
  boundingCircle = new Circle();
  boundingCircle.center = new PVector(500, 500);
  boundingCircle.radius = 400;
  boundingCircle.col = white;
  
  circles = new ArrayList<Circle>();
  
  // Make sure the program doesn't run endlessly if no new circles can be added
  // by limiting the iteration count to 1000
  int iterations = 0;
  int circlesAdded = 0;
  while (circlesAdded < 500 && iterations++ <= 1000) {
    Circle c = new Circle();
    float x = random(0, 1000);
    float y = random(0, 1000);
    c.center = new PVector(x,y);

    float maxPossibleRadius = 50;  // Set a limit on how large new circles can be
    
    // Check if we are inside the larger "bounding circle".
    // The bounding circle is centered at 500
    float distanceFromCenter = c.center.dist(boundingCircle.center);
    if (distanceFromCenter < boundingCircle.radius) {
      float r = boundingCircle.radius - distanceFromCenter;
      // It is possible to draw a circle of radius "r", but still respect
      // our initial "max radius limit"
      // Comment this line and uncomment the next line to lift this restriction.
      maxPossibleRadius = min(maxPossibleRadius, r);
      // maxPossibleRadius = r;
    } else {
      // We are outside the bounding circle, do not add a circle
      // Skip ahead to the next iteration of the loop.
      continue;
    }
    
    // Make sure every circle added is as large as possible
    // without overlapping any previously added circle.
    // Iterate through all existing circles, and see how close the randomly chosen
    // spawn point is. This way, we can determine the "maximum possible radius" for
    // the new circle.
    boolean overlap = false;
    for (Circle d: circles) {
      // Calculate the distance between the centers of the circles.
      float distance = d.center.dist(c.center);
      
      // Is the new random center outside an existing circle?
      if (distance > d.radius) {
        float r = distance - d.radius;
        if (r < maxPossibleRadius) {
          maxPossibleRadius = r;
        }
      } else {
        // New position is inside an existing circle, skip
        overlap = true;
        break;
      }
    }
    
    if (!overlap) {
      c.radius = maxPossibleRadius;
      
      // Set a random gray value. TODO experiment with other color variations
      c.col = color(random(0, 255));
      circles.add(c);
      circlesAdded++;
    }
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
