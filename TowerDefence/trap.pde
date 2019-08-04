class trap{
	PVector pos;
	int type;
	boolean drag;

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
	}
	void dragging(){
		if(drag){
			pos.set(mouseX,mouseY);
			if(!mousePressed){
				drag = false;
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
}
