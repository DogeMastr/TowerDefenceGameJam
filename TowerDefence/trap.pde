class trap{
	PVector pos;
	int type;
	boolean drag;

	trap(int t){
		pos = new PVector();

		drag = true;
		type = _t;

		/*
			Trap types

			1 = bomb
			2 = spikes
			3 = freeze

		*/
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

	}
}
