class trap{
	PVector pos;
	int type;
	boolean drag;
	int countdown;

	int icecountdown;

	boolean finished;
	trap(int t){
		pos = new PVector();
		finished = false;
		drag = true;
		type = t;
		icecountdown = 120;
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
						countdown = 100;
						icecountdown = 120;
						break;
					case 3:
						countdown = 100;
						icecountdown = 120;
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
				case 1://fire
					if(countdown == 0){
						if(dist(pos.x,pos.y,testCamp.enemyList.get(i).pos.x,testCamp.enemyList.get(i).pos.y) < 150){
							testCamp.enemyList.get(i).health -= 30;
							finished = true;
						}
					}
					break;
				case 2:
					if(countdown == 0){
						if(dist(pos.x,pos.y,testCamp.enemyList.get(i).pos.x,testCamp.enemyList.get(i).pos.y) < 150){
							if(icecountdown > 0){
								testCamp.enemyList.get(i).health -= 2;
								icecountdown -= 2;

							} else {
								finished = true;
							}
						}
					}
					break;
				case 3:
					if(countdown == 0){
						if(dist(pos.x,pos.y,testCamp.enemyList.get(i).pos.x,testCamp.enemyList.get(i).pos.y) < 200){
							if(icecountdown > 0){
								testCamp.enemyList.get(i).speed = 0;
								icecountdown--;
							} else {
								switch(testCamp.enemyList.get(i).type){
									case 1: //goblins
										testCamp.enemyList.get(i).speed = 2;
										break;
									case 2:	//sssskkkellitions
										testCamp.enemyList.get(i).speed = 1.25;
										break;
									case 3: //skelly guards
										testCamp.enemyList.get(i).speed = 1.15;
										break;
									case 4: //shreck 5
										testCamp.enemyList.get(i).speed = 0.4;
								}
								finished = true;
							}
						}
					}
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
