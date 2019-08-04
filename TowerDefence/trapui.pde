class trapui {

  PImage ui;

  PImage fire;
  PImage spike;

  ArrayList<trap> trapList;
  trapui() {

    trapList = new ArrayList<trap>();

    ui = loadImage("data/ui/trap.png");

    fire = loadImage("data/traps/fire.png");
    spike = loadImage("data/traps/spike.png");
  }

  void run() {
    display();
    select();
    runTraps();
  }
  void display() {
    image(ui, width/2, height-height/10);
  }

  void select() {

    textAlign(CENTER, TOP);
    fill(255);
    textSize(15);
    if (mouseY > 620) {
      if (mouseY < 680) {
        if (mouseX > 480 && mouseX < 550) {
          image(textbacking, mouseX, mouseY-100);
          text("Fire Gas Trap: 40 MANA", mouseX, mouseY - 140);
          text("A grate that emmits burning gas that caused enemies to sizzle and fry.", mouseX, mouseY - 80);
          if (mousePressed) {
            if (manaPool.amount > 40) {
              trapList.add(new trap(1));
              manaPool.amount -= 40;
            }
          }
        }
        if (mouseX > 600 && mouseX < 670) {
          image(textbacking, mouseX, mouseY-100);
          text("Spike Trap: 20 MANA", mouseX, mouseY-140);
          text("A simple bed of spikes that impale enemies", mouseX, mouseY - 80);
          text("that dare to wade across", mouseX, mouseY - 60);
          if (mousePressed) {
            if (manaPool.amount > 20) {
              trapList.add(new trap(2));
              manaPool.amount -= 20;
            }
          }
        }
        if (mouseX > 722 && mouseX < 790) {
          image(textbacking, mouseX, mouseY-100);
          text("Freeze Spell: 80 MANA", mouseX, mouseY - 140);
          text("A last ditch spell that freezes and enemies", mouseX, mouseY - 80);
          text("foolish enough to step into its bounds.", mouseX, mouseY - 60);
          if (mousePressed) {
            if (manaPool.amount > 80) {
              trapList.add(new trap(3));
              manaPool.amount -= 80;
            }
          }
        }
      }
    }
  }

  void runTraps() {
    for (int i = trapList.size() - 1; i > 0; i--) {
      trapList.get(i).run();
      if (trapList.get(i).finished) {
        trapList.remove(i);
      }
    }
  }
}
