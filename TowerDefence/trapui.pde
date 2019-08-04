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
						trapList.add(new trap(1));
					}
					if(mouseX > 600 && mouseX < 670){
						trapList.add(new trap(2));
					}
					if(mouseX > 722 && mouseX < 790){
						trapList.add(new trap(3));
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
