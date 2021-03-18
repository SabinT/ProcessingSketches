import controlP5.*;

ControlP5 controls;

void setupControls() {
  controls = new ControlP5(this);
  
  controls.addSlider("feedRate")
     .setPosition(10, 20)
     .setSize(600, 14)
     .setRange(0, 1)
     .setColorCaptionLabel(color(255))
     .setValue(feedRate);
     
  controls.addSlider("killRate")
     .setPosition(10, 60)
     .setSize(600, 14)
     .setRange(0, 1)
     .setColorCaptionLabel(color(255))
     .setValue(killRate);
     
  controls.addSlider("dRateA")
     .setPosition(10, 100)
     .setSize(600, 14)
     .setRange(0, 10)
     .setColorCaptionLabel(color(255))
     .setValue(dRateA);
     
  controls.addSlider("dRateB")
     .setPosition(10, 140)
     .setSize(600, 14)
     .setRange(0, 10)
     .setColorCaptionLabel(color(255))
     .setValue(dRateB);
}

void drawHelpText() {
  int startY = 160;
  
  text("Controls", 10, startY + 20);
  text("A: Add chemical A (based on image)", 10, startY + 40);
  text("B: Add chemical B (based on image)", 10, startY + 60);
  text("C: Clear screen with chemical A", 10, startY + 80);
  text("H: Show/hide help", 10, startY + 100);
  text("Click and drag with mouse to inject chemical B", 10, startY + 120);
}
