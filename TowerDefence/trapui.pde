class trapui{

	PImage ui;

	PImage fire;
	PImage spike;

	trapui(){
		ui = loadImage("data/ui/trap.png");

		fire = loadImage("data/traps/fire.png");
		spike = loadImage("data/traps/spike.png");
	}

	void display(){
		image(ui,width/2,height-height/10);
	}

	void help
}
