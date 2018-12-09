package code  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class shoe extends MovieClip {
		
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
		var speed2:Number = new Number(0);/*used to send the shoe away after impact with pap*/
		var r_speed:Number = new Number(8);
		var v_speed:Number = new Number(0);/*vertical speed used to send the shoe away after impact with pap*/
		
		public function shoe(lane:int,ma:game,pl:MovieClip) {
			if (lane == 1){
				this.y=lane1;
			}else if (lane==2) {
				this.y=lane2;
			} else if (lane==3) {
				this.y=lane3;
			}
			
			//Freeze image in first frame
			gotoAndStop(1);
			
			this.x=800;
			
			master=ma;
			player=pl;
			
			//set aprropriate speed
			speed=master.speed+2;
			
			this.addEventListener(Event.ENTER_FRAME,loop);
		}
		
		
		//Loop for moving, testing collisions, checking if out of bounds etc
		function loop(Event):void {
			//move and rotate
			this.x-=speed;
			this.shoe_core.x-=speed2;
			this.shoe_core.rotation-=r_speed;
			this.shoe_core.y-=v_speed;
			
			//Case 1: Out of bounds
			if (this.x<=0 && isToBeRemoved){
				master.Remove(this);
				isToBeRemoved=false;
			//Case 2: Hits Gefry's head
			}else if (this.hitTestObject(player) && isToBeRemoved){
				isToBeRemoved=false;
				master.change_health_by(-15);
				master.Remove(this);
				//Show the Bang! image not rotating and change shoes road
				r_speed=0;								
				v_speed=10;
				speed2=speed;
				speed=0;
				gotoAndStop(2);
				//Play sound
				master.shoe_sd.play();
			}
		}
	}
	
}
