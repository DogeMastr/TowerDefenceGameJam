class trap{
	PVector pos;
	int type;
	boolean drag;
	int countdown;

	trap(int t){
		pos = new PVector();

		drag = true;
		type = t;

		/*
			Trap types

			1 = bomb
			2 = spikes
			3 = freeze

		*/
	}
	void run(){
		dragging();
		display();
		attack();
		countdown();
	}
	void dragging(){
		if(drag){
			pos.set(mouseX,mouseY);
			if(!mousePressed){
				drag = false;
				switch(type){
					case 1:
						countdown = 200;
						break;
					case 2:
						break;
					case 3:
						break;
				}
			}
		}
	}

	void display(){
		switch(type){
			case 1:
				image(tui.fire,pos.x,pos.y);
				break;
			case 2:
				image(tui.spike,pos.x,pos.y);
				break;
			case 3:
				fill(9,80,70,40);
				ellipse(pos.x,pos.y,200,200);
				break;
		}
	}

	void attack(){
		for(int i = testCamp.enemyList.size()-1; i > 0; i--){
			switch(type){
				case 1:
					if(countdown == 0){
						if(dist(pos.x,pos.y,testCamp.enemyList.get(i).pos.x,testCamp.enemyList.get(i).pos.y) < 150){
							testCamp.enemyList.get(i).health -= 30;
						}
					}
					break;
				case 2:
					break;
				case 3:
					break;
			}
		}
	}
	void countdown(){
		if(!drag && countdown > 0){
			countdown--;
		}
	}
}
