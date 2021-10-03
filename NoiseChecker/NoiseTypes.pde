import java.util.Random;


float regularRandom(int x, int y) {
  return rand.nextFloat();
}

float randomMinusRandom(int x, int y) {
  return rand.nextFloat() - rand.nextFloat();
}

float randomAvgRandom(int x, int y) {
  return 0.5 * (rand.nextFloat() + rand.nextFloat());
}

float randomToTheRandom(int x, int y) {
  return (float) Math.pow(rand.nextDouble(), rand.nextDouble());
}

float randomToTheRandomToTheRandom(int x, int y) {
  return (float) Math.pow(Math.pow(rand.nextDouble(), rand.nextDouble()), rand.nextDouble());
}

float randomMinusRandomToTheRandom(int x, int y) {
  return (float) (rand.nextDouble() - Math.pow(rand.nextDouble(), rand.nextDouble()));
}

float oneMinusRandomToTheRandom(int x, int y) {
  return (float) (1 - Math.pow(rand.nextDouble(), rand.nextDouble()));
}

float alternateInvert (int x, int y) {
  if ((x / 32) % 2 == 0 && (y / 32) % 2 == 0) {
    return 1 - rand.nextFloat();
  }
  
  return rand.nextFloat();
}
