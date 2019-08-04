import processing.sound.*;

tower oneTower;
camp testCamp;
mana manaPool;

trapui tui;
PImage background;
PImage textbacking;

boolean pause;

SoundFile  death;
SoundFile  shoot;
SoundFile  explosion;
SoundFile  damage;
SoundFile  blast;
SoundFile  change;


void setup(){

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
	if(!pause){
		imageMode(CENTER);
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
