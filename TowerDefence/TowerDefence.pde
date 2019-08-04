tower oneTower;
camp testCamp;
mana manaPool;

PImage background;
void setup(){
	size(1280,720);
	imageMode(CENTER);
	manaPool = new mana(1100,510);

	testCamp = new camp(0,0,0);

	oneTower = new tower(width/2,height/2);

	background = loadImage("data/map.png");
	background.resize(width,height);
}

void draw(){
	image(background,width/2,height/2);
	testCamp.run();

	oneTower.run();

	manaPool.run();

	runCollision();
}

void runCollision(){
	for(int i = testCamp.enemyList.size() - 1; i > 0; i--){
		if(testCamp.enemyList.get(i).collision(manaPool)){
			manaPool.amount -= testCamp.enemyList.get(i).damage;
			testCamp.enemyList.remove(i);
		}
	}
}
