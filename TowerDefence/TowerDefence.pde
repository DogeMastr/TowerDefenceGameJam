import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

tower oneTower;
camp testCamp;
mana manaPool;

trapui tui;
PImage background;

boolean pause;

void setup(){
	size(1280,720);

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
