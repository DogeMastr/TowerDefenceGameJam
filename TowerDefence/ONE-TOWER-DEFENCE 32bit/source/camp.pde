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
				} else if(rng > 85){
					type = 3;
					enemyList.add(new enemy(rX,rY,type));
				} else if(rng > 90){
				  type = 4;
					enemyList.add(new enemy(rX,rY,type));
				}

			}
			countdown = 120;
		}
		countdown--;
	}

	void runEnemys(){
		for(int i = enemyList.size()-1; i > 0; i--){

			if(enemyList.get(i).health <= 0){

				//particle effect here thanks
				death.play();

				enemyList.remove(i);
				kills++;
			} else {
				enemyList.get(i).run();
			}
		}
	}
}
