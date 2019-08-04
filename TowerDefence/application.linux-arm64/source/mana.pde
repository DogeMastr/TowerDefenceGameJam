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

	void run(){
		display();
		gain();
		cooldown();
	}

	void display(){
		fill(40,203,239);

		textSize(60);
		textAlign(CENTER);
		text(amount,width/2,height/10);
	}

	void gain(){
		if(cooldown == 0){
			amount++;
			cooldown = 60;
		}
	}

	void cooldown(){
		if(cooldown > 0){
			cooldown--;
		}
	}
}
