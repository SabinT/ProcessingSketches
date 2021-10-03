class Star {
  public PVector position;
  public float radius = 1;
  public int col = color(255);

  public Star(PVector pos, int col) {
    this.position = pos;
    this.col = col;
  }
  
  public void Draw(PGraphics g) {
    g.fill(col);
    g.noStroke();
    g.circle(position.x, position.y, radius * 2);
  }
}
