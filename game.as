package code
{
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.ui.Keyboard;
	import fl.transitions.TweenEvent;
	import flash.utils.Timer;


	//MAIN CLASS THAT CONTAINS EVERYTHING
	public class game extends MovieClip
	{
		//speed and vertical speed
		var speed:Number;
		var v_speed:Number;
		var speed_factor:Number = new Number(1);
		var max_speed_factor:Number = new Number(6);
		var min_speed_factor:Number = new Number(1);
		var speed_unit:Number = new Number(5);
		
		//Game data 
		var score:Number=new Number(0);
		var health:Number=new Number(100);
		var max_health:Number =new Number(100);


		//MOVEMENT LANES
		var lane1:Number = new Number(340);
		var lane2:Number = new Number(440);
		var lane3:Number = new Number(540);
		var current_lane:Number;

		//Sounds
		var ex_sd:expl_sd = new expl_sd();
		var shoe_sd:hit_by_shoe_sd= new hit_by_shoe_sd();
		var coin_sd:get_coin_sd = new get_coin_sd();
		var splats_sd:splat_sd =new splat_sd();
		var h_up_sd:health_fill_sd =new health_fill_sd();
		
		//Tweens
		var move12:Tween;
		var move21:Tween;
		var move23:Tween;
		var move32:Tween;

		//Movemnt indicator
		var isMoving:Boolean=new Boolean(false);
		
		//Araray of new objects that will appear
		var A:Array = new Array(1,2,3,4,5);
		
		//Object Counters etc
		var i:int=new int(0);
		var count:int=new int(0);
		var total_count:int =new int(101);
		var interval:int =new int(40);
		
		//The parent of game as an "origin" class
		var Father:origin;
		
		//CONSTRUCTOR
		public function game():void
		{	
			//initialize speeds
			speed=speed_factor*speed_unit+5;
			v_speed=22-speed/2;
					
			
			// Freeze game at start
			this.pap.gotoAndStop(1);
			
			//Click and key press listeners			
			this.addEventListener(MouseEvent.CLICK,StartPlaying);			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,control);
			
			//Exit button Listener
			exit_btn.addEventListener(MouseEvent.CLICK,ClickExit);
			
			//Position initialization
			this.pap.y = lane2;
			current_lane = 2;
			
			//Make random obstacles
			Randomize();

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
		
		//Every Frame Function 
		public function Repeat(Event):void
		{
			//movement of the backround
			this.bc.x -=  speed;
			if (this.bc.x <= -800)
			{
				this.bc.x = 0;
			}
			this.cl.x-=speed/10;
			if (this.cl.x <= -800)
			{
				this.cl.x = 0;
			}
			
			//movement of the wheels
			this.pap.bike.wheel1.rotation +=  speed;
			this.pap.bike.wheel2.rotation +=  speed;
			
			//Object Handling
			i++;
			if (i==interval){
				if(A[count]==1){
					this.addChild(new tomatoe(current_lane,this,this.pap.hitpoint));
				}else if(A[count]==2) {
					this.addChild(new shoe(current_lane,this,this.pap.hitpoint));
				}else if(A[count]==3) {
					this.addChild(new bomb(current_lane,this,this.pap.hitpoint));
				}else if(A[count]==4) {
					this.addChild(new coin(current_lane,this,this.pap.hitpoint));
				}else if(A[count]==5) {
					this.addChild(new heart(current_lane,this,this.pap.hitpoint));
				}
				count++;
				if (count==total_count){count=0;};/*renew objects*/
				i=0;
			}
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
				if (speed_factor<max_speed_factor) {
					speed_factor++;
					speed=speed_factor*speed_unit+5;
					speed_indicator.speed_text.text=speed_factor;
					v_speed=22-speed/2;
					
					//Make lane changes faster when running faster
					move12.duration=v_speed;
					move21.duration=v_speed;
					move23.duration=v_speed;
					move32.duration=v_speed;
				}
			}else if (ev.keyCode==Keyboard.LEFT){
				if (speed_factor>min_speed_factor) {
					speed_factor--;
					speed=speed_factor*speed_unit+5;
					speed_indicator.speed_text.text=speed_factor;
					v_speed=22-speed/2;
					
					//Make lane changes faster when running faster
					move12.duration=v_speed;
					move21.duration=v_speed;
					move23.duration=v_speed;
					move32.duration=v_speed;
				}
			}
		}
		
		//Change Movement State. Activated When Any Movement Starts/Stops
		function EndOfMove(TweenEvent):void {
			isMoving=false;
		}
		
		function StartOfMove(TweenEvent):void {
			isMoving=true;
		}	
		
		
		//Object Removal function		
		public function Remove(obstacle:MovieClip):void {
			var tim:Timer = new Timer(600,1);
			tim.addEventListener(TimerEvent.TIMER_COMPLETE, time_up);
			tim.start();
			function time_up():void {
				removeChild(obstacle);
			}
		}
		
		//Fast Object Removal function		
		public function FastRemove(obstacle:MovieClip):void {
			var tim:Timer = new Timer(50,1);
			tim.addEventListener(TimerEvent.TIMER_COMPLETE, time_up);
			tim.start();
			function time_up():void {
				removeChild(obstacle);
			}
		}
		
		//INDICATOR CHANGES FUNCTIONS		
		//Health
		function change_health_by(h:Number) : void {
			if (h<0) {h=h+h*min_speed_factor/6;};
			health+=h;
			if (health<=0) {
				health=0;
				Father.GameOver(score);
				removeEventListener(Event.ENTER_FRAME,Repeat);
			}else if (health>100) {
				health=100;
			}
			this.health_indicator.health_value.scaleX=health/max_health;
			
		}
		
		//Score
		function change_score_by(h:Number) : void {
			score+=h*min_speed_factor;
			this.score_indicator.score_txt.text=score.toString();
		}
		
		//Set Difficulty function
		function Set_Difficulty(diff:int):void {
			min_speed_factor=diff;
			speed_factor=diff;
			speed=speed_factor*speed_unit+5;
			speed_indicator.speed_text.text=speed_factor;
			v_speed=22-speed/2;
			move12.duration=v_speed;
			move21.duration=v_speed;
			move23.duration=v_speed;
			move32.duration=v_speed;
		}
		//Set Difficulty function
		function Set_Father(father:origin):void {
			Father=father;
		}
		
		//Function to start game- Ads every frame listener
		function StartPlaying(MouseEvent) {			
			this.pap.play();
			if (this.cTs.visible){
				this.cTs.visible=false;
				this.addEventListener(Event.ENTER_FRAME,Repeat);
			}
		}
		
		//Function when EXIT buuton pressed
		function ClickExit(MouseEvent):void {		
			ClickExit2();
		}
		function ClickExit2():void {
			cTs.visible=false;
			removeEventListener(Event.ENTER_FRAME,Repeat);
			Father.GameOver(score);		
		}
		
		function Randomize():void {
			var k:int;
			var v:int;

			v=Math.round(Math.random()*50);
			
			for (k=0;k<=100;k++) {
				A[k]=Math.ceil(Math.random()*4);				
			}
			
			for (k=v;k<=100;k+=v+50) {
				A[k]=5;
			}
		}
	}
}