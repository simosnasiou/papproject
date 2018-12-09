package code
{
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.ui.Keyboard;
	import fl.transitions.TweenEvent;


	//MAIN CLASS THAT CONTAINS EVERYTHING
	public class main extends MovieClip
	{
		//speed and vertical speed
		var speed:Number;
		var v_speed:Number;

		//MOVEMENT LANES
		var lane1:Number = new Number(340);
		var lane2:Number = new Number(440);
		var lane3:Number = new Number(540);
		var current_lane:Number;

		//Tweens
		var move12:Tween;
		var move21:Tween;
		var move23:Tween;
		var move32:Tween;

		//Movemnt indicator
		var isMoving:Boolean=new Boolean(false);		

		//constructor
		public function main():void
		{
			
			//initialize speeds
			speed = new Number(15);
			v_speed = new Number(20);

			//On enter frame and key press listeners
			this.addEventListener(Event.ENTER_FRAME,Repeat);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,control);
			
			//Position initialization
			this.pap.y = lane2;
			current_lane = 2;

			//Keyboard and tween initialization
			move12 = new Tween(this.pap,"y",Regular.easeInOut,lane1,lane2,v_speed,false);
			move23 = new Tween(this.pap,"y",Regular.easeInOut,lane2,lane3,v_speed,false);

			move32 = new Tween(this.pap,"y",Regular.easeInOut,lane3,lane2,v_speed,false);
			move21 = new Tween(this.pap,"y",Regular.easeInOut,lane2,lane1,v_speed,false);
			move12.stop();
			move23.stop();
			move32.stop();
			move21.stop();
			//Theese Listeners are to change the movement idicator
			move12.addEventListener(TweenEvent.MOTION_FINISH,EndOfMove);
			move21.addEventListener(TweenEvent.MOTION_FINISH,EndOfMove);
			move23.addEventListener(TweenEvent.MOTION_FINISH,EndOfMove);
			move32.addEventListener(TweenEvent.MOTION_FINISH,EndOfMove);
			
			move12.addEventListener(TweenEvent.MOTION_START,StartOfMove);
			move21.addEventListener(TweenEvent.MOTION_START,StartOfMove);
			move23.addEventListener(TweenEvent.MOTION_START,StartOfMove);
			move32.addEventListener(TweenEvent.MOTION_START,StartOfMove);
			
		}
		
		//every Frame function 
		public function Repeat(Event):void
		{
			//movement of the backround
			this.bc.x -=  speed;
			if (this.bc.x <= -800)
			{
				this.bc.x = 0;
			}
			
			//movement of the wheels
			this.pap.bike.wheel1.rotation +=  speed;
			this.pap.bike.wheel2.rotation +=  speed;
		}

		//When a key is pressed
		function control(ev:KeyboardEvent):void
		{

			//MOVE UP AND DOWN WHEN NOT ALREADY MOVING
			if (ev.keyCode == Keyboard.UP && !isMoving)
			{
				if (current_lane == 2)
				{
					move21.start();
					current_lane = 1;
				}
				else if (current_lane==3)
				{
					move32.start();
					current_lane = 2;
				}
			}
			else if (ev.keyCode==Keyboard.DOWN && !isMoving)
			{
				if (current_lane == 1)
				{
					move12.start();
					current_lane = 2;
				}
				else if (current_lane==2)
				{
					move23.start();
					current_lane = 3;
				}
			}
			
			//CHANGE SPEED (temp)
			
			if(ev.keyCode==Keyboard.RIGHT){
				speed+=2;
			}else if (ev.keyCode==Keyboard.LEFT){
				speed-=2;
			}
		}
		
		//Change Movement State Activated When Any Movement Starts/Stops
		function EndOfMove(TweenEvent):void {
			isMoving=false;
		}
		
		function StartOfMove(TweenEvent):void {
			isMoving=true;
		}


		
		
	}
}