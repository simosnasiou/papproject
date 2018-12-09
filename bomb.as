package code  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class bomb extends MovieClip {
		
		//Lanes for objects
		var lane1:Number = new Number(340-180);
		var lane2:Number = new Number(440-180);
		var lane3:Number = new Number(540-180);
		
		//Master is the game this clip will become child of
		//Player is papandreou
		//Boolean "isToBeRemoved shows wether this clip has been added to removal yet
		var master:game;
		var player:MovieClip;
		var isToBeRemoved:Boolean=new Boolean(true);
		//"speed" is the speed it moves backwards
		var speed:Number = new Number(10);
		
		public function bomb(lane:int,ma:game,pl:MovieClip) {
			if (lane == 1){
				this.y=lane1;
			}else if (lane==2) {
				this.y=lane2;
			} else if (lane==3) {
				this.y=lane3;
			}
			this.x=800;
			
			//stop in frame 1
			this.gotoAndStop(1);
			
			master=ma;
			player=pl;
			this.addEventListener(Event.ENTER_FRAME,loop);
			
			//Set the right Speed
			speed=master.speed + 4;
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
				
				explode();
				//Play sound
				master.ex_sd.play();
				
				speed=1;
				master.change_health_by(-25);
			}
		}
		
		//explode on impact
		function explode():void {
			this.gotoAndStop(2);
		}
	}
	
}
