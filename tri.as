package code  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
public class tri extends MovieClip {
		
		var master:game;
		var player:MovieClip;
		var isToBeRemoved:Boolean=new Boolean(true);
		
		public function tri(Y:int,ma:game,pl:MovieClip) {
			this.y=Y-160;
			this.x=800;
			
			
			master=ma;
			player=pl;
			this.addEventListener(Event.ENTER_FRAME,loop);
		}
		
		
		//Loop for testing collisions checking if out of bounds etc
		function loop(Event):void {
			this.x-=5;
			if ((this.x<=0 ||this.hitTestObject(player)) && isToBeRemoved){
				master.Remove(this);
				isToBeRemoved=false;
			}
		}
	}
	
}
