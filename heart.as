package code  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	public class heart extends MovieClip {
		
		//Lanes for objects
		var lane1:Number = new Number(340-165);
		var lane2:Number = new Number(440-165);
		var lane3:Number = new Number(540-165);
		
		//Master is the game this clip will become child of
		//Player is papandreou
		//Boolean "isToBeRemoved shows wether this clip has been added to removal yet
		var master:game;
		var player:MovieClip;
		var isToBeRemoved:Boolean=new Boolean(true);
		//"speed" is the speed it moves backwards
		var speed:Number = new Number(5);
		
		
		//Constructor
		public function heart(lane:int,ma:game,pl:MovieClip) {
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
			
			// make it not move forward
			this.speed=master.speed;
			
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
				master.FastRemove(this);
				isToBeRemoved=false;
				speed=1;
				
				//Heal
				master.change_health_by(40);
				
				//Play healing sound
				master.h_up_sd.play();
			}
		}
	}
	
}
