/*
  MADE BY DOGEMASTR & INFINNITOR
  
  @doge_mastr on twitter
  Infinnitor doesent have a twitter
*/


import processing.sound.*;

tower oneTower;
camp testCamp;
mana manaPool;

trapui tui;
PImage background;
PImage textbacking;

int kills;
int gametimer;

boolean pause;

SoundFile  death;
SoundFile  shoot;
SoundFile  explosion;
SoundFile  damage;
SoundFile  blast;
SoundFile  change;


void setup(){

	kills = 0;
	gametimer = 0;

	death = new SoundFile(this, "sounds/blast.wav");
	shoot = new SoundFile(this, "data/sounds/shoot.wav");
	explosion = new SoundFile(this, "data/sounds/explosion.wav");
	damage = new SoundFile(this, "data/sounds/damage.wav");
	blast = new SoundFile(this, "data/sounds/blast.wav");
	change = new SoundFile(this, "data/sounds/change.wav");

	size(1280,720);

	textbacking = loadImage("data/ui/text.png");

	pause = true;

	imageMode(CENTER);
	manaPool = new mana(1100,510);

	testCamp = new camp(0,0,0);

	oneTower = new tower(width/2,height/2);

	background = loadImage("data/map.png");
	background.resize(width,height);

	tui = new trapui();
}

void draw(){
	if(!gameover()){
		if(!pause){
			imageMode(CENTER);
			image(background,width/2,height/2);
			tui.run();

			testCamp.run();

			oneTower.run();

			manaPool.run();

			runCollision();
			gametimer++;
		} else {
			fill(82,10);
			rect(0,0,width,height);
			textSize(100);
			textAlign(CENTER,CENTER);
			fill(255);
			text("ONLY ONE TOWER",width/2,height/3);
			textSize(30);
			text("(defence)",width/2 ,height/3 + 80);
			text("Press space to start, pause & unpause",width/2,height/2);
			text("Left click and drag your tower to defend",width/2,height/2 + 40);
			text("Right click and select to change your tower",width/2,height/2+80);
			text("Click and drag traps to place them", width/2, height/2 + 120);
			text("You gain 1 mana every second", width/2, height/2 + 160);
			text("Code by DogeMastr, Art by Infinnitor",width/2,height- height/5 + 40);
			text("Made in 48~ hours for the GMTK-only-one gamejam",width/2,height- height/5 + 80);
		}
	} else {
		fill(82,10);
		rect(0,0,width,height);
		textSize(100);
		textAlign(CENTER,CENTER);
		fill(255);
		textSize(100);
		text("YOU LOST", width/2,height/3);
		textSize(30);
		text("Hope you had fun playing!", width/2,height/2);
		text("You killed " + kills + " monsters!", width/2,height/2 + 40);
		text("You lasted " + gametimer + " frames!", width/2,height/2 + 80);
		text("press space to play again!", width/2, height/2 + 120);

		if(keyPressed){
			if(key == ' '){
				reset();
			}
		}
	}
}

void reset(){

		kills = 0;
		gametimer = 0;

		imageMode(CENTER);
		manaPool = new mana(1100,510);

		testCamp = new camp(0,0,0);

		oneTower = new tower(width/2,height/2);

		tui = new trapui();
}

void runCollision(){
	for(int i = testCamp.enemyList.size() - 1; i > 0; i--){
		if(testCamp.enemyList.get(i).collision(manaPool)){
			manaPool.amount -= testCamp.enemyList.get(i).damage;
			testCamp.enemyList.remove(i);
			damage.play();
		}
	}
}

boolean gameover(){
	if(manaPool.amount < 0){
		return true;
	} else {
		return false;
	}
}

void keyReleased(){
	if(key == ' '){
		if(pause){
			pause = false;
		} else {
			pause = true;
		}
	}
}
