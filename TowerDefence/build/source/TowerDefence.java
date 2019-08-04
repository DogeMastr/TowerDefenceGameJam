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

PImage background;
public void setup(){
	
	imageMode(CENTER);
	oneTower = new tower(width/2,height/2);

	manaPool = new mana(1100,510);

	testCamp = new camp(0,0,0);

	background = loadImage("data/map.png");
	background.resize(width,height);
}

public void draw(){
	image(background,width/2,height/2);
	oneTower.run();

	manaPool.run();

	testCamp.run();

	runCollision();
}

public void runCollision(){
	for(int i = testCamp.enemyList.size() - 1; i > 0; i--){
		if(testCamp.enemyList.get(i).collision(manaPool)){
			manaPool.amount -= testCamp.enemyList.get(i).damage;
			testCamp.enemyList.remove(i);
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
			for(int i = 0; i < 10; i++){

				int type = (int)random(1,3);

				float rY = (int)random(40,200);
				enemyList.add(new enemy(-30,rY,type));

			}
			countdown = 120;
		}
		countdown--;
	}

	public void runEnemys(){
		for(int i = 0; i < enemyList.size(); i++){
			enemyList.get(i).run();
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
		type = (int)random(0,5);
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


	tower(float x, float y){
		pos = new PVector();
		pos.set(x,y);

		archer = loadImage("data/towers/ArcherTower.png");
		mage = loadImage("data/towers/MageTower.png");
		repeater = loadImage("data/towers/RepeaterTower.png");
		occultist = loadImage("data/towers/OccultistTower.png");

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
			fill(255);
			ellipse(pos.x,pos.y,radius*5,radius*5);
			fill(74);
			ellipse(pos.x,pos.y,radius*4,radius*4);
			mOpen = true;
		}

		if(mOpen){
			textAlign(CENTER);
			textSize(radius/1.5f);

			fill(255);
			ellipse(pos.x + radius*2,pos.y + radius*2,radius*2,radius*2);
			if(dist(mouseX,mouseY,pos.x + radius*2,pos.y + radius*2) < radius*0.75f){
				fill(255);
				rect(mouseX,mouseY,radius*12,radius*8);
				fill(0);
				text("this turns it yellow",mouseX + radius*3, mouseY + radius);
				if(mousePressed){
					type = 1;
					mOpen = false;
				}
			}

			fill(255);
			ellipse(pos.x - radius*2,pos.y + radius*2,radius*2,radius*2);
			if(dist(mouseX,mouseY,pos.x - radius*2,pos.y + radius*2) < radius*0.75f){
				fill(255);
				rect(mouseX,mouseY,radius*12,radius*8);
				fill(0);
				text("this turns it blue",mouseX + radius*3, mouseY + radius);
				if(mousePressed){
					type = 2;
					mOpen = false;
				}
			}

			fill(255);
			ellipse(pos.x + radius*2,pos.y - radius*2,radius*2,radius*2);
			if(dist(mouseX,mouseY,pos.x + radius*2,pos.y - radius*2) < radius*0.75f){
				fill(255);
				rect(mouseX,mouseY,radius*12,radius*8);
				fill(0);
				text("this turns it red",mouseX + radius*3, mouseY + radius);
				if(mousePressed){
					type = 3;
					mOpen = false;
				}
			}

			fill(255);
			ellipse(pos.x - radius*2,pos.y - radius*2,radius*2,radius*2);
			if(dist(mouseX,mouseY,pos.x - radius*2,pos.y - radius*2) < radius*0.75f){
				fill(255);
				rect(mouseX,mouseY,radius*12,radius*8);
				fill(0);
				text("this turns it green",mouseX + radius*3, mouseY + radius);
				if(mousePressed){
					type = 4;
					mOpen = false;
				}
			} //display the round menu thing yes
		}

		if(mousePressed && dist(mouseX,mouseY,pos.x,pos.y) > radius*3){
			mOpen = false;
		}

	}

	public void attack(){
		for(int i = testCamp.enemyList.size(); i < 0; i--){
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
