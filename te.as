package code  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class te extends MovieClip {
		
		//Lanes for objects
		var lane1:Number = new Number(340-160);
		var lane2:Number = new Number(440-160);
		var lane3:Number = new Number(540-160);
		
		//Master is the game this clip will become child of
		//Player is papandreou
		//Boolean "isToBeRemoved shows wether this clip has been added to removal yet
		var master:game;
		var player:MovieClip;
		var isToBeRemoved:Boolean=new Boolean(true);
		//"speed" is the speed it moves backwards
		var speed:Number = new Number(7);
		
		public function te(lane:int,ma:game,pl:MovieClip) {
			if (lane == 1){
				this.y=lane1;
			}else if (lane==2) {
				this.y=lane2;
			} else if (lane==3) {
				this.y=lane3;
			}
			this.x=800;
			
			master=ma;
			player=pl;
			this.addEventListener(Event.ENTER_FRAME,loop);
		}
		
		
		//Loop for moving, testing collisions, checking if out of bounds etc
		function loop(Event):void {
			//move
			this.x-=speed;
			//Case 1: Out of bounds
			if (this.x<=0 && isToBeRemoved){
				master.Remove(this);
				isToBeRemoved=false;
			//Case 2: Hits Gefry's head
			}else if (this.hitTestObject(player) && isToBeRemoved){
				master.Remove(this);
				isToBeRemoved=false;
				speed=1;
			}
		}
	}
	
}
