class trapui{

	PImage ui;

	PImage fire;
	PImage spike;

	ArrayList<trap> trapList;
	trapui(){

		trapList = new ArrayList<trap>();

		ui = loadImage("data/ui/trap.png");

		fire = loadImage("data/traps/fire.png");
		spike = loadImage("data/traps/spike.png");
	}

	void run(){
		display();
		select();
		runTraps();
	}
	void display(){
		image(ui,width/2,height-height/10);
	}

	void select(){
		if(mousePressed){
			if(mouseY > 620){
				if(mouseY < 680){
					if(mouseX > 480 && mouseX < 550){
						if(manaPool.amount > 40){
							trapList.add(new trap(1));
							manaPool.amount -= 40;
						}
					}
					if(mouseX > 600 && mouseX < 670){
						if(manaPool.amount > 20){
							trapList.add(new trap(2));
							manaPool.amount -= 20;
						}
					}
					if(mouseX > 722 && mouseX < 790){
						if(manaPool.amount > 80){
							trapList.add(new trap(3));
							manaPool.amount -= 80;
						}
					}
				}
			}
		}
	}

	void runTraps(){
		for(int i = trapList.size() - 1; i > 0; i--){
			trapList.get(i).run();
		}
	}

}
