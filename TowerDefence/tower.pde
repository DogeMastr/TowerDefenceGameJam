class tower {
  PVector pos;
  int type;
  int cooldown;
  int radius;
  boolean mOpen; //menu open if true
  boolean dragging;
  int archRange;

  int mageRange;

  int crossRange;
  int crossBurnout;

  PImage archer;
  PImage mage;
  PImage repeater;
  PImage occultist;

  PImage menu;

  tower(float x, float y) {
    pos = new PVector();
    pos.set(x, y);

    archer = loadImage("data/towers/ArcherTower.png");
    mage = loadImage("data/towers/MageTower.png");
    repeater = loadImage("data/towers/RepeaterTower.png");
    occultist = loadImage("data/towers/OccultistTower.png");

    menu = loadImage("data/ui/menu.png");

    archer.resize(50, 50);
    mage.resize(50, 50);
    repeater.resize(50, 50);
    occultist.resize(50, 50);

    type = 1;
    radius = 20;

    archRange = 100;

    mageRange = 70;

    crossRange = 120;
  }

  void run() {
    display();
    drag();
    drawMenu();
    attack();
  }
  void display() {
    fill(255);
    switch(type) {
    case 1:
      image(archer, pos.x, pos.y);
      break;
    case 2:
      image(mage, pos.x, pos.y);
      break;
    case 3:
      image(repeater, pos.x, pos.y);
      break;
    case 4:
      image(occultist, pos.x, pos.y);
      break;
    }
  }

  void drawMenu() {
    if (dist(mouseX, mouseY, pos.x, pos.y) < radius && mousePressed && mouseButton == RIGHT || mOpen) {
      image(menu, pos.x, pos.y);
      mOpen = true;
    }

    if (mOpen) {
      imageMode(CORNER);
      textAlign(CENTER);
      textSize(20);

      fill(255);
      // ellipse(pos.x + radius*2.5,pos.y + radius*2.5,radius*2,radius*2);
      if (dist(mouseX, mouseY, pos.x + radius*2.5, pos.y + radius*2.5) < radius*0.75) {
        fill(255);
        // rect(mouseX,mouseY,radius*12,radius*8);
        image(textbacking, mouseX, mouseY);
        fill(255);
        text("Occult's Eye", mouseX + radius*3, mouseY + 40);
        text("Fires an ethereal high damage projectile", mouseX + radius*3, mouseY + 60);
        text("dealing massive damage and draining mana.", mouseX + radius*3, mouseY + 80);
        if (mousePressed) {
          if (manaPool.amount > 20) {
            change.play();
            type = 4;
            mOpen = false;
          }
        }
      }

      fill(255);
      // ellipse(pos.x - radius*2.5,pos.y + radius*2.5,radius*2,radius*2);
      if (dist(mouseX, mouseY, pos.x - radius*2.5, pos.y + radius*2.5) < radius*0.75) {
        fill(255);
        // rect(mouseX,mouseY,radius*12,radius*8);
        image(textbacking, mouseX, mouseY);
        fill(255);
        text("Archer Tower: 20 MANA", mouseX + radius*3, mouseY + 40);
        text("Steadily fires arrows at enemies.", mouseX + radius*3, mouseY + 60);
        if (mousePressed) {
          if (manaPool.amount > 20) {
            manaPool.amount -= 20;
            change.play();
            type = 1;
            mOpen = false;
          }
        }
      }

      fill(255);
      // ellipse(pos.x + radius*2.5,pos.y - radius*2.5,radius*2,radius*2);
      if (dist(mouseX, mouseY, pos.x + radius*2.5, pos.y - radius*2.5) < radius*0.75) {
        fill(255);
        // rect(mouseX,mouseY,radius*12,radius*8);
        image(textbacking, mouseX, mouseY);
        fill(255);
        text("Repeater: 20 MANA", mouseX + radius*3, mouseY + 40);
        text("Advanced technology that rapidly fires arrows at high speeds towards enemies,", mouseX + radius*3, mouseY + 60);
        text("but does less damage and needs to be reloaded frequently.", mouseX + radius*3, mouseY + 80);
        if (mousePressed) {
          if (manaPool.amount > 20) {
            manaPool.amount -= 20;
            change.play();
            type = 3;
            mOpen = false;
          }
        }
      }

      fill(255);
      // ellipse(pos.x - radius*2.5,pos.y - radius*2.5,radius*2,radius*2);
      if (dist(mouseX, mouseY, pos.x - radius*2.5, pos.y - radius*2.5) < radius*0.75) {
        fill(255);
        // rect(mouseX,mouseY,radius*12,radius*8);
        image(textbacking, mouseX, mouseY);
        fill(255);
        text("Mage: 20 MANA", mouseX + radius*3, mouseY + 40);
        text("Does more damage with longer cooldowns in between shots.", mouseX + radius*3, mouseY + 60);
        if (mousePressed) {
          if (manaPool.amount > 20) {
            manaPool.amount -= 20;
            change.play();
            type = 2;
            mOpen = false;
          }
        }
      } //display the round menu thing yes
    }

    if (mousePressed && dist(mouseX, mouseY, pos.x, pos.y) > radius*3) {
      mOpen = false;
    }
  }

  void attack() {
    for (int i = testCamp.enemyList.size()-1; i > 0; i--) {
      switch(type) {
      case 1:
        //Archer
        if (dist(pos.x, pos.y, testCamp.enemyList.get(i).pos.x, testCamp.enemyList.get(i).pos.y) < testCamp.enemyList.get(i).radius + archRange && cooldown == 0) {
          //shoot at the guys
          float damageDone = random(7, 20);
          //play animation then:
          testCamp.enemyList.get(i).health -= damageDone;
          cooldown = 40;
          break;
        }
      case 2:
        //Mage
        if (dist(pos.x, pos.y, testCamp.enemyList.get(i).pos.x, testCamp.enemyList.get(i).pos.y) < testCamp.enemyList.get(i).radius + mageRange && cooldown == 0) {
          //shoot at the guys
          float damageDone = random(7, 20);
          //play animation then:
          testCamp.enemyList.get(i).health -= damageDone;
          cooldown = 80;
          break;
        }
      case 3:
        //Repeting crossbow
        if (dist(pos.x, pos.y, testCamp.enemyList.get(i).pos.x, testCamp.enemyList.get(i).pos.y) < testCamp.enemyList.get(i).radius + mageRange && cooldown == 0 && crossBurnout > 0) {
          //shoot at the guys
          float damageDone = random(7, 20);
          //play animation then:
          testCamp.enemyList.get(i).health -= damageDone;
          crossBurnout--;
        }
        if (crossBurnout == 0 && cooldown == 0) {
          cooldown = 120;
          crossBurnout = 40;
        }
        break;
      case 4:
        //Occultist
        break;
      }
    }
    //cooo00ldown
    if (cooldown > 0) {
      cooldown--;
    }
  }

  void drag() {
    if (mousePressed) {
      if (mouseButton == LEFT) {
        if (dist(mouseX, mouseY, pos.x, pos.y) < radius || dragging == true) {
          pos.set(mouseX, mouseY);
          dragging = true;
        }
      }
    } else {
      dragging = false;
    }
  }
}
