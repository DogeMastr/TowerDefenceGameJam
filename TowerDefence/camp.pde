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
	color cColor;

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

	void run(){
		display();
		summon();
		runEnemys();
	}
	void display(){
		fill(cColor);
		rect(pos.x,pos.y,cWidth,cWidth);
	}

	void summon(){
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

	void runEnemys(){
		for(int i = 0; i < enemyList.size(); i++){
			enemyList.get(i).run();
		}
	}
}
