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

	void run(){
		display();
		drag();
		drawMenu();
		attack();
	}
	void display(){
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

	void drawMenu(){
		if(dist(mouseX,mouseY,pos.x,pos.y) < radius && mousePressed && mouseButton == RIGHT || mOpen){
			image(menu,pos.x,pos.y);
			mOpen = true;
		}

		if(mOpen){
			textAlign(CENTER);
			textSize(radius/1.5);

			fill(255);
			// ellipse(pos.x + radius*2.5,pos.y + radius*2.5,radius*2,radius*2);
			if(dist(mouseX,mouseY,pos.x + radius*2.5,pos.y + radius*2.5) < radius*0.75){
				fill(255);
				rect(mouseX,mouseY,radius*12,radius*8);
				fill(0);
				text("Occultist",mouseX + radius*3, mouseY + radius);
				if(mousePressed){
					type = 4;
					mOpen = false;
				}
			}

			fill(255);
			// ellipse(pos.x - radius*2.5,pos.y + radius*2.5,radius*2,radius*2);
			if(dist(mouseX,mouseY,pos.x - radius*2.5,pos.y + radius*2.5) < radius*0.75){
				fill(255);
				rect(mouseX,mouseY,radius*12,radius*8);
				fill(0);
				text("Archer",mouseX + radius*3, mouseY + radius);
				if(mousePressed){
					type = 1;
					mOpen = false;
				}
			}

			fill(255);
			// ellipse(pos.x + radius*2.5,pos.y - radius*2.5,radius*2,radius*2);
			if(dist(mouseX,mouseY,pos.x + radius*2.5,pos.y - radius*2.5) < radius*0.75){
				fill(255);
				rect(mouseX,mouseY,radius*12,radius*8);
				fill(0);
				text("Repeater",mouseX + radius*3, mouseY + radius);
				if(mousePressed){
					type = 3;
					mOpen = false;
				}
			}

			fill(255);
			// ellipse(pos.x - radius*2.5,pos.y - radius*2.5,radius*2,radius*2);
			if(dist(mouseX,mouseY,pos.x - radius*2.5,pos.y - radius*2.5) < radius*0.75){
				fill(255);
				rect(mouseX,mouseY,radius*12,radius*8);
				fill(0);
				text("Mage",mouseX + radius*3, mouseY + radius);
				if(mousePressed){
					type = 2;
					mOpen = false;
				}
			} //display the round menu thing yes
		}

		if(mousePressed && dist(mouseX,mouseY,pos.x,pos.y) > radius*3){
			mOpen = false;
		}

	}

	void attack(){
		for(int i = testCamp.enemyList.size()-1; i > 0; i--){
			println("haha yeah man");
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

	void drag(){
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
