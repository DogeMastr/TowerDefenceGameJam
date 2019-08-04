import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class TowerDefence extends PApplet {

tower oneTower;
camp testCamp;
mana manaPool;

trapui tui;
PImage background;

boolean pause;

public void setup(){
	

	pause = true;

	imageMode(CENTER);
	manaPool = new mana(1100,510);

	testCamp = new camp(0,0,0);

	oneTower = new tower(width/2,height/2);

	background = loadImage("data/map.png");
	background.resize(width,height);

	tui = new trapui();
}

public void draw(){
	if(!pause){
		image(background,width/2,height/2);
		tui.run();

		testCamp.run();

		oneTower.run();

		manaPool.run();

		runCollision();

	} else {
		fill(82,10);
		rect(0,0,width,height);
		textSize(100);
		textAlign(CENTER,CENTER);
		fill(255);
		text("PAUSED",width/2,height/2);
	}
}

public void runCollision(){
	for(int i = testCamp.enemyList.size() - 1; i > 0; i--){
		if(testCamp.enemyList.get(i).collision(manaPool)){
			manaPool.amount -= testCamp.enemyList.get(i).damage;
			testCamp.enemyList.remove(i);
		}
	}
}

public boolean gameover(){
	if(manaPool.amount < 0){
		return true;
	} else {
		return false;
	}
}

public void keyReleased(){
	if(key == ' '){
		if(pause){
			pause = false;
		} else {
			pause = true;
		}
	}
}
class camp{
	/*
	Enemy camps can:
		Off screen or on screen
		Destoryed by towers
		have multiple exits (?)
		be walked through
		Summon more enemys
		Respawn enemys that made it through to the mana pool
	*/

	PVector pos;
	float cWidth;
	int cColor;

	ArrayList<enemy> enemyList; //each camp has their own list of enemys

	PImage goblin;
	PImage skelly;
	PImage skellyHorse;
	PImage ogre;

	int countdown; //for summing Enemys
	camp(int x, int y, int size){

		goblin = loadImage("data/enemys/goblin.png");
		skelly = loadImage("data/enemys/skelly.png");
		skellyHorse = loadImage("data/enemys/skellyHorse.png");
		ogre = loadImage("data/enemys/ogre.png");


		pos = new PVector();
		pos.set(x,y);
		cWidth = size;

		cColor = color(160,96,32);

		enemyList = new ArrayList<enemy>();

		countdown = 0;
	}

	public void run(){
		display();
		summon();
		runEnemys();
	}
	public void display(){
		fill(cColor);
		rect(pos.x,pos.y,cWidth,cWidth);
	}

	public void summon(){
		if(countdown == 0){
			for(int i = 0; i < 5; i++){

				float rY = random(40,200);
				float rX = random(-30,-10);
				int type;
				float rng = random(0,100);
				if(45 > rng){
					type = 1;
					enemyList.add(new enemy(rX,rY,type));
				} else if(rng > 75){
					type = 2;
					enemyList.add(new enemy(rX,rY,type));
					enemyList.add(new enemy(rX,rY,type));
				} else if(rng > 90){
					type = 3;
					enemyList.add(new enemy(rX,rY,type));
				} else if(rng > 95){
				  type = 4;
					enemyList.add(new enemy(rX,rY,type));
				}

			}
			countdown = 120;
		}
		countdown--;
	}

	public void runEnemys(){
		for(int i = enemyList.size()-1; i > 0; i--){

			if(enemyList.get(i).health <= 0){

				//particle effect here thanks

				enemyList.remove(i);

			} else {
				enemyList.get(i).run();
			}
		}
	}
}
class enemy{

	/*
		Enemys are spawned in an enemy camp,
			Enemy camps can be:
				Off screen or on screen
				Destoryed by towers
				Multiple exits
				can be walked through

			Enemys can:
				Walk on a path towards the mana pool
				not:
					walk on walls
					walk on towers
				be diffirent types:
					Small - small and fast, low health
					Medium - normal speed & health
					Big - very slow, lots of health

	*/

	PVector pos;

	int type; //1 for small, 2 for medium, 3 for Big

	float speed;
	float radius;
	float health;
	float damage;

	PVector goal1;
	PVector goal2;
	PVector goal3;
	PVector goal4;
	PVector goal5;
	PVector goal6;
	int currentGoal;
	PVector goal;
	PVector velocity;

	PImage sprite;

	enemy(float x,float y,int _type){
		sprite = new PImage();
		pos = new PVector();
		pos.set(x,y);
		type = _type;

		goal = new PVector();

		velocity = new PVector();
		velocity.set(0,0);

		goal1 = new PVector();
		goal2 = new PVector();
		goal3 = new PVector();
		goal4 = new PVector();
		goal5 = new PVector();
		goal6 = new PVector();

		goal1.set(random(180,300),random(100,236));
		goal2.set(random(204,315),random(450,560));
		goal3.set(random(603,725),random(450,560));
		goal4.set(random(560,683),random(110,217));
		goal5.set(random(905,1040),random(110,217));
		goal6.set(random(922,1035),random(450,560));
		goal.set(goal1);
		switch(type){
			case 1: //goblins
				speed = 2;
				radius = 12.5f;
				health = 15;
				damage = 5;
				sprite = testCamp.goblin;
				break;
			case 2:	//sssskkkellitions
				speed = 1.25f;
				radius = 7.5f;
				health = 10;
				damage = 3;
				sprite = testCamp.skelly;
				break;
			case 3: //skelly guards
				speed = 1.15f;
				radius = 10;
				health = 25;
				damage = 10;
				sprite = testCamp.skellyHorse;
				break;
			case 4: //shreck 5
				speed = 0.4f;
				radius = 25;
				health = 100;
				damage = 40;
				sprite = testCamp.ogre;
				break;
		}

	}

	public void run(){
		display();
		setGoals();
		move();
	}
	public void setGoals(){
		switch(currentGoal){
			case 1:
				goal.set(goal1);
				break;
			case 2:
				goal.set(goal2);
				break;
			case 3:
				goal.set(goal3);
				break;
			case 4:
				goal.set(goal4);
				break;
			case 5:
				goal.set(goal5);
				break;
			case 6:
				goal.set(goal6);
				break;
			case 7:
				goal.set(manaPool.pos);
				break;
		}
	}

	public void move(){
	/*
		enemy has a goal, when it reaches it, a new goal is set until it reaches the mana pool
		or dies
	*/
		velocity = PVector.sub(goal,pos);
		velocity.setMag(speed);

		pos.add(velocity);

		if(dist(pos.x,pos.y,goal.x,goal.y) < 5){
			currentGoal++;
		}
	}

	public void display(){
		image(sprite,pos.x,pos.y);
	}

	public boolean collision(mana m){
		if(dist(pos.x,pos.y,m.pos.x,m.pos.y) < m.radius + radius){
			return true;
		}
		return false;
	}
}
class mana{

	PVector pos;
	int amount;
	int cooldown;
	int radius;

	mana(int x, int y){
		pos = new PVector();
		pos.set(x,y);
		cooldown = 60;
		amount = 25;
		radius = 30;
	}

	public void run(){
		display();
		gain();
		cooldown();
	}

	public void display(){
		fill(40,203,239);
		ellipse(pos.x,pos.y,radius*2,radius*2);

		textSize(60);
		text(amount,width/2,height - height/10);
	}

	public void gain(){
		if(cooldown == 0){
			amount++;
			cooldown = 60;
		}
	}

	public void cooldown(){
		if(cooldown > 0){
			cooldown--;
		}
	}
}
class tower{
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

	tower(float x, float y){
		pos = new PVector();
		pos.set(x,y);

		archer = loadImage("data/towers/ArcherTower.png");
		mage = loadImage("data/towers/MageTower.png");
		repeater = loadImage("data/towers/RepeaterTower.png");
		occultist = loadImage("data/towers/OccultistTower.png");

		menu = loadImage("data/ui/menu.png");

		archer.resize(50,50);
		mage.resize(50,50);
		repeater.resize(50,50);
		occultist.resize(50,50);

		type = 1;
		radius = 20;

		archRange = 100;

		mageRange = 70;

		crossRange = 120;

	}

	public void run(){
		display();
		drag();
		drawMenu();
		attack();
	}
	public void display(){
		fill(255);
		switch(type){
			case 1:
				image(archer,pos.x,pos.y);
				break;
			case 2:
				image(mage,pos.x,pos.y);
				break;
			case 3:
				image(repeater,pos.x,pos.y);
				break;
			case 4:
				image(occultist,pos.x,pos.y);
				break;
		}
	}

	public void drawMenu(){
		if(dist(mouseX,mouseY,pos.x,pos.y) < radius && mousePressed && mouseButton == RIGHT || mOpen){
			image(menu,pos.x,pos.y);
			mOpen = true;
		}

		if(mOpen){
			textAlign(CENTER);
			textSize(radius/1.5f);

			fill(255);
			// ellipse(pos.x + radius*2.5,pos.y + radius*2.5,radius*2,radius*2);
			if(dist(mouseX,mouseY,pos.x + radius*2.5f,pos.y + radius*2.5f) < radius*0.75f){
				fill(255);
				rect(mouseX,mouseY,radius*12,radius*8);
				fill(0);
				text("Occultist",mouseX + radius*3, mouseY + radius);
				if(mousePressed){
					if(manaPool.amount > 20){
						type = 4;
						mOpen = false;
					}
				}
			}

			fill(255);
			// ellipse(pos.x - radius*2.5,pos.y + radius*2.5,radius*2,radius*2);
			if(dist(mouseX,mouseY,pos.x - radius*2.5f,pos.y + radius*2.5f) < radius*0.75f){
				fill(255);
				rect(mouseX,mouseY,radius*12,radius*8);
				fill(0);
				text("Archer",mouseX + radius*3, mouseY + radius);
				if(mousePressed){
					if(manaPool.amount > 20){
						type = 1;
						mOpen = false;
					}
				}
			}

			fill(255);
			// ellipse(pos.x + radius*2.5,pos.y - radius*2.5,radius*2,radius*2);
			if(dist(mouseX,mouseY,pos.x + radius*2.5f,pos.y - radius*2.5f) < radius*0.75f){
				fill(255);
				rect(mouseX,mouseY,radius*12,radius*8);
				fill(0);
				text("Repeater",mouseX + radius*3, mouseY + radius);
				if(mousePressed){
					if(manaPool.amount > 20){
						type = 3;
						mOpen = false;
					}
				}
			}

			fill(255);
			// ellipse(pos.x - radius*2.5,pos.y - radius*2.5,radius*2,radius*2);
			if(dist(mouseX,mouseY,pos.x - radius*2.5f,pos.y - radius*2.5f) < radius*0.75f){
				fill(255);
				rect(mouseX,mouseY,radius*12,radius*8);
				fill(0);
				text("Mage",mouseX + radius*3, mouseY + radius);
				if(mousePressed){
					if(manaPool.amount > 20){
						type = 2;
						mOpen = false;
					}
				}
			} //display the round menu thing yes
		}

		if(mousePressed && dist(mouseX,mouseY,pos.x,pos.y) > radius*3){
			mOpen = false;
		}

	}

	public void attack(){
		for(int i = testCamp.enemyList.size()-1; i > 0; i--){
			switch(type){
				case 1:
					//Archer
					if(dist(pos.x,pos.y,testCamp.enemyList.get(i).pos.x,testCamp.enemyList.get(i).pos.y) < testCamp.enemyList.get(i).radius + archRange && cooldown == 0){
						//shoot at the guys
						float damageDone = random(7, 20);
						//play animation then:
						testCamp.enemyList.get(i).health -= damageDone;
						cooldown = 40;
						break;
					}
				case 2:
					//Mage
					if(dist(pos.x,pos.y,testCamp.enemyList.get(i).pos.x,testCamp.enemyList.get(i).pos.y) < testCamp.enemyList.get(i).radius + mageRange && cooldown == 0){
						//shoot at the guys
						float damageDone = random(7, 20);
						//play animation then:
						testCamp.enemyList.get(i).health -= damageDone;
						cooldown = 80;
						break;
					}
				case 3:
					//Repeting crossbow
					if(dist(pos.x,pos.y,testCamp.enemyList.get(i).pos.x,testCamp.enemyList.get(i).pos.y) < testCamp.enemyList.get(i).radius + mageRange && cooldown == 0 && crossBurnout > 0){
						//shoot at the guys
						float damageDone = random(7, 20);
						//play animation then:
						testCamp.enemyList.get(i).health -= damageDone;
						crossBurnout--;
					}
					if(crossBurnout == 0 && cooldown == 0){
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
		if(cooldown > 0){
			cooldown--;
		}
	}

	public void drag(){
		if(mousePressed){
			if(mouseButton == LEFT){
				if(dist(mouseX,mouseY,pos.x,pos.y) < radius || dragging == true){
					pos.set(mouseX,mouseY);
					dragging = true;
				}
			}
		} else {
			dragging = false;
		}
	}
}
class trap{
	PVector pos;
	int type;
	boolean drag;
	int countdown;

	trap(int t){
		pos = new PVector();

		drag = true;
		type = t;

		/*
			Trap types

			1 = bomb
			2 = spikes
			3 = freeze

		*/
	}
	public void run(){
		dragging();
		display();
		attack();
		countdown();
	}
	public void dragging(){
		if(drag){
			pos.set(mouseX,mouseY);
			if(!mousePressed){
				drag = false;
				switch(type){
					case 1:
						countdown = 200;
						break;
					case 2:
						break;
					case 3:
						break;
				}
			}
		}
	}

	public void display(){
		switch(type){
			case 1:
				image(tui.fire,pos.x,pos.y);
				break;
			case 2:
				image(tui.spike,pos.x,pos.y);
				break;
			case 3:
				fill(9,80,70,40);
				ellipse(pos.x,pos.y,200,200);
				break;
		}
	}

	public void attack(){
		for(int i = testCamp.enemyList.size()-1; i > 0; i--){
			switch(type){
				case 1:
					if(countdown == 0){
						if(dist(pos.x,pos.y,testCamp.enemyList.get(i).pos.x,testCamp.enemyList.get(i).pos.y) < 150){
							testCamp.enemyList.get(i).health -= 30;
						}
					}
					break;
				case 2:
					break;
				case 3:
					break;
			}
		}
	}
	public void countdown(){
		if(!drag && countdown > 0){
			countdown--;
		}
	}
}
class trapui{

	PImage ui;

	PImage fire;
	PImage spike;

	ArrayList<trap> trapList;
	trapui(){

		trapList = new ArrayList<trap>();

		ui = loadImage("data/ui/trap.png");

		fire = loadImage("data/traps/fire.png");
		spike = loadImage("data/traps/spike.png");
	}

	public void run(){
		display();
		select();
		runTraps();
	}
	public void display(){
		image(ui,width/2,height-height/10);
	}

	public void select(){
		if(mousePressed){
			if(mouseY > 620){
				if(mouseY < 680){
					if(mouseX > 480 && mouseX < 550){
						if(manaPool.amount > 40){
							trapList.add(new trap(1));
							manaPool.amount -= 40;
						}
					}
					if(mouseX > 600 && mouseX < 670){
						if(manaPool.amount > 20){
							trapList.add(new trap(2));
							manaPool.amount -= 20;
						}
					}
					if(mouseX > 722 && mouseX < 790){
						if(manaPool.amount > 80){
							trapList.add(new trap(3));
							manaPool.amount -= 80;
						}
					}
				}
			}
		}
	}

	public void runTraps(){
		for(int i = trapList.size() - 1; i > 0; i--){
			trapList.get(i).run();
		}
	}

}
  public void settings() { 	size(1280,720); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "TowerDefence" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
