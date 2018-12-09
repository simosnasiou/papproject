package code  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class tomatoe extends MovieClip {
		
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
		//"r_speed" is the speed of rotation
		var speed:Number = new Number(7);
		var r_speed:Number = new Number(7);
		
		public function tomatoe(lane:int,ma:game,pl:MovieClip) {
			if (lane == 1){
				this.y=lane1;
			}else if (lane==2) {
				this.y=lane2;
			} else if (lane==3) {
				this.y=lane3;
			}
			this.x=800;
			
			//stop in fisrst frame so as not to explode 
			this.gotoAndStop(1);
			master=ma;
			player=pl;
			//Set the right speed
			speed=master.speed+2;
			
			this.addEventListener(Event.ENTER_FRAME,loop);
		}
		
		//Fuction to explode when hits papadrea
		function explode():void {
			r_speed=0;
			this.gotoAndStop(2);
			master.change_health_by(-15);
		}
		
		
		//Loop for moving, testing collisions, checking if out of bounds etc
		function loop(Event):void {
			//move and rotate
			this.x-=speed;
			this.core_fruit.rotation-=r_speed;
			//Case 1: Out of bounds
			if (this.x<=0 && isToBeRemoved){
				master.Remove(this);
				isToBeRemoved=false;
			//Case 2: Hits Gefry's head
			}else if (this.hitTestObject(player) && isToBeRemoved){
				master.Remove(this);
				isToBeRemoved=false;
				explode();
				speed=1;
				//Play sound
				master.splats_sd.play();
			}
		}
	}
	
}
