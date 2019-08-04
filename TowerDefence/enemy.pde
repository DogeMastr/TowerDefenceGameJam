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
				radius = 12.5;
				health = 15;
				damage = 5;
				sprite = testCamp.goblin;
				break;
			case 2:	//sssskkkellitions
				speed = 1.25;
				radius = 7.5;
				health = 10;
				damage = 3;
				sprite = testCamp.skelly;
				break;
			case 3: //skelly guards
				speed = 1.15;
				radius = 10;
				health = 25;
				damage = 10;
				sprite = testCamp.skellyHorse;
				break;
			case 4: //shreck 5
				speed = 0.4;
				radius = 25;
				health = 100;
				damage = 40;
				sprite = testCamp.ogre;
				break;
		}

	}

	void run(){
		display();
		setGoals();
		move();
	}
	void setGoals(){
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

	void move(){
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

	void display(){
		image(sprite,pos.x,pos.y);
	}

	boolean collision(mana m){
		if(dist(pos.x,pos.y,m.pos.x,m.pos.y) < m.radius + radius){
			return true;
		}
		return false;
	}
}
