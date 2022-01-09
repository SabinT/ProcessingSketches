import java.util.*;

int binCount = 100;
float binRenderWidth = 4;
float binRenderMaxHeight = 100;

void plotHistogram(ArrayList<Float> list, PVector origin) {
  // Range is assumed to be [0.0, 1.0)
  int[] bins = new int[binCount];
  Arrays.fill(bins, 0);
  
  int min = Integer.MAX_VALUE;
  int max = Integer.MIN_VALUE;

  for (int i = 0; i < list.size(); i++) {
    float x = list.get(i);
    int bin = (int) Math.floor(x * binCount);
    bins[bin] += 1;
    int c = bins[bin];
    if (c < min) { min = c; }
    if (c > max) { max = c; }
  }
  
  for (int i = 0; i < binCount; i++) {
    float h = bins[i] * binRenderMaxHeight / (float) max;
    rect(
      origin.x + i * binRenderWidth,
      origin.y + binRenderMaxHeight - h,
      binRenderWidth,
      h);
  }
}

void setup() {
  size(800, 300);
  
  background(0);
  stroke(#ffffff);
  strokeWeight(1);
  fill(#ff0000);
  
  int numElements = 100000;

  Random r = new Random(new Date().getTime());
  
  ArrayList<Float> A = new ArrayList<Float>(); 
  ArrayList<Float> B = new ArrayList<Float>(); 
  ArrayList<Float> C = new ArrayList<Float>(); 
  
  for (int i = 0; i < numElements; i++) {
    A.add(r.nextFloat());
    float b = r.nextFloat();
    B.add(b);
    if (b > 0.5) {
      C.add(r.nextFloat());
    }
  }
  
  plotHistogram(A, new PVector(0, 0));
  plotHistogram(B, new PVector(0, binRenderMaxHeight));
  plotHistogram(C, new PVector(0, 2 * binRenderMaxHeight));
  
  A.clear(); B.clear(); C.clear();
  
  Random r1 = new Random(new Date().getTime());
  Random r2 = new Random(new Date().getTime() + 1);
  Random r3 = new Random(new Date().getTime() + 1);
  
    for (int i = 0; i < numElements; i++) {
    A.add(r1.nextFloat());
    float b = r2.nextFloat();
    B.add(b);
    if (b > 0.5) {
      C.add(r3.nextFloat());
    }
  }
  
  float bw = binRenderWidth * binCount;
  fill(#00ff00);
  plotHistogram(A, new PVector(bw, 0));
  plotHistogram(B, new PVector(bw, binRenderMaxHeight));
  plotHistogram(C, new PVector(bw, 2 * binRenderMaxHeight));
}
