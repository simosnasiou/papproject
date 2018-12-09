package code
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;

	public class origin extends MovieClip
	{
		//intro sounds
		var ss:Sound = new intro_music();
		var sc:SoundChannel;
		var cr:crash_sd = new crash_sd();
		
		//Songs And Sound Channel
		var so1:Sound=new song1;
		var so2:Sound=new song2;
		var so3:Sound=new song3;
		var so4:Sound=new song4;
		var soch:SoundChannel;

		//Temporraty score before saved
		var temp_score:int;
		
		//Scores and names of owners
		var score1:int = new int(0);
		var name1:String = new String("Player");
		var score2:int = new int(0);
		var name2:String = new String("Player");
		var score3:int = new int(0);
		var name3:String = new String("Player");
		var score4:int = new int(0);
		var name4:String = new String("Player");

		//how many levels have been unlocked
		var levels_unlocked:int = new int(1);

		//Current_level
		var selected_level:int = new int(1);

		//Current_level
		var difficulty:int = new int(1);

		//Constructor
		public function origin()
		{
			LoadData();
			gotoAndStop(1);
			sc = ss.play();/*play the introduction sound*/
			//Button listeners
			this.intro.next_btn.addEventListener(MouseEvent.CLICK,GoToMenu);

		}
		
		//Function to SAVE All Scores And Names of those who have them
		function SaveData():void {
			var Record:SharedObject = SharedObject.getLocal("Record");
			Record.data.unlocked_tmp=levels_unlocked;
			Record.data.score1_temp=score1;
			Record.data.name1_temp=name1;
			Record.data.score2_temp=score2;
			Record.data.name2_temp=name2;
			Record.data.score3_temp=score3;
			Record.data.name3_temp=name3;
			Record.data.score4_temp=score4;
			Record.data.name4_temp=name4;
			Record.flush();
		}
		
		//Function to LOAD All Scores And Names of those who have them
		function LoadData():void {
			var Record:SharedObject = SharedObject.getLocal("Record");
			
			levels_unlocked=Record.data.unlocked_tmp;
			score1=Record.data.score1_temp;
			name1=Record.data.name1_temp
			score2=Record.data.score2_temp;
			name2=Record.data.name2_temp;
			score3=Record.data.score3_temp;
			name3=Record.data.name3_temp;
			score4=Record.data.score4_temp;
			name4=Record.data.name4_temp;
		}

		// Funtion to go to MAIN MENU initialize Listeners when button next is presed;
		function GoToMenu(MouseEvent):void
		{
			sc.stop();
			gotoAndStop(2);
			show_locks();
			PlayListener();
			MenuTableListener();
			DiffListeners();
			HelpListeners();
			InfoListeners();
			show_data();
		}

		// Funtion to start playing game when button play is presed
		function GoToPlayGame(MouseEvent):void
		{
			gotoAndStop(6);
				g1.Set_Difficulty(difficulty);
				g1.Set_Father(this);
				g1.cl.gotoAndStop(selected_level);
				g1.bc.gotoAndStop(selected_level);
				g1.midle.gotoAndStop(selected_level);
				
				if (selected_level==1) {
					soch=so1.play(0,100,null);
				}else if (selected_level==2) {
					soch=so2.play(0,100,null);
				}else if (selected_level==3) {
					soch=so3.play(0,100,null);
				}else {
					soch=so4.play(0,100,null);
				}
		}

		//Hide/show the correct locks
		function show_locks():void
		{
			if (levels_unlocked >= 2)
			{
				m_menu.menu_table.lc2.visible = false;
			}
			if (levels_unlocked >= 3)
			{
				m_menu.menu_table.lc3.visible = false;
			}
			if (levels_unlocked >= 4)
			{
				m_menu.menu_table.lc4.visible = false;
			}
		}
		
		//Display the names and scores of players
		function show_data():void
		{
			m_menu.menu_table.n1.text=name1;
			m_menu.menu_table.s1.text=score1;
			m_menu.menu_table.n2.text=name2;
			m_menu.menu_table.s2.text=score2;
			m_menu.menu_table.n3.text=name3;
			m_menu.menu_table.s3.text=score3;
			m_menu.menu_table.n4.text=name4;
			m_menu.menu_table.s4.text=score4;
		}

		//Make a listener for btn play
		function PlayListener():void
		{
			m_menu.play_btn.addEventListener(MouseEvent.CLICK,GoToPlayGame);

		}

		//Add click listener to selection table;
		function MenuTableListener():void
		{
			m_menu.menu_table.addEventListener(MouseEvent.CLICK,SelectLevel);
		}

		//Add click listeners to dificulty buttons table;
		function DiffListeners():void
		{
			m_menu.sel_diff.dis.text = difficulty;
			m_menu.sel_diff.bt_up.addEventListener(MouseEvent.CLICK,Diff_up);
			m_menu.sel_diff.bt_down.addEventListener(MouseEvent.CLICK,Diff_down);
		}

		//For dificulty up button;
		function Diff_up(MouseEvent):void
		{
			if (difficulty < 6)
			{
				difficulty++;
				m_menu.sel_diff.dis.text = difficulty;
			}
		}
		//For dificulty down button
		function Diff_down(MouseEvent):void
		{
			if (difficulty > 1)
			{
				difficulty--;
				m_menu.sel_diff.dis.text = difficulty;
			}
		}

		//Add click listeners to HELP btn
		function HelpListeners():void
		{
			m_menu.help_btn.addEventListener(MouseEvent.CLICK,GoToHelp);
		}
		//Function to go to HELP page;
		function GoToHelp(MouseEvent):void
		{
			gotoAndStop(3);
			BackListeners();
		}

		//Add click listeners to INFO btn
		function InfoListeners():void
		{
			m_menu.info_btn.addEventListener(MouseEvent.CLICK,GoToInfo);
		}
		//Function to go to INFO page;
		function GoToInfo(MouseEvent):void
		{
			gotoAndStop(4);
			BackListeners();
		}

		//Add click listeners to BACK btn
		function BackListeners():void
		{
			difficulty=1;
			back_btn.addEventListener(MouseEvent.CLICK,GoToMenu);
		}

		//Fuction to be called from game when player looses
		function GameOver(s:int):void
		{
			//stop playing the songs
			soch.stop();
			
			this.gotoAndStop(5);
			cr.play();
			
			var SCORE:int;
			if (selected_level==1){SCORE==score1}else
			if (selected_level==2){SCORE==score2}else
			if (selected_level==4){SCORE==score4}else
			if (selected_level==3){SCORE==score3};
			
			if (s > SCORE && s>250)
			{
				if (levels_unlocked<=selected_level&&levels_unlocked<4){levels_unlocked=selected_level+1;};
				temp_score=s;
				this.g_o_page.gotoAndStop(2);
				this.g_o_page.score_display.text=s;
				this.g_o_page.enter_btn.addEventListener(MouseEvent.CLICK,EnterClicked);
			}
			else
			{
				this.g_o_page.gotoAndStop(1);
				this.g_o_page.menu_btn.addEventListener(MouseEvent.CLICK,MenuClicked);
			}

		}


		//Function called when ENTER button is pressed
		function EnterClicked(MouseEvent):void
		{
			if (this.g_o_page.name_input.text!=""){
				if (selected_level==1){
					name1=this.g_o_page.name_input.text;
					score1=temp_score;
				} else
				if (selected_level==2){
					name2=this.g_o_page.name_input.text;
					score2=temp_score;
				}else
				if (selected_level==3){
					name3=this.g_o_page.name_input.text;
					score3=temp_score;
				}else
				if (selected_level==4){
					name4=this.g_o_page.name_input.text;
					score4=temp_score;
				};
				gotoAndStop(2);
				show_locks();
				PlayListener();
				MenuTableListener();
				DiffListeners();
				HelpListeners();
				InfoListeners();
				SaveData();
				selected_level=1;
				show_data();
				
			}
		}
		//Function called when MENU button is pressed
		function MenuClicked(MouseEvent):void
		{
			gotoAndStop(2);
			show_locks();
			PlayListener();
			MenuTableListener();
			DiffListeners();
			HelpListeners();
			InfoListeners();
			selected_level=1;
			trace(selected_level);
			show_data();
		}
		//The fuction called when clicked selecting the level
		function SelectLevel(e:MouseEvent):void
		{
			if (e.stageY > 240 && e.stageY < 303 && levels_unlocked >= 1)
			{
				this.m_menu.menu_table.bar.y = -94.5;
				selected_level = 1;
			}
			else if (e.stageY>=303 && e.stageY<366 && levels_unlocked>=2)
			{
				this.m_menu.menu_table.bar.y = -31.4;
				selected_level = 2;
			}
			else if (e.stageY>=366 && e.stageY<430 && levels_unlocked>=3)
			{
				this.m_menu.menu_table.bar.y = 32.6;
				selected_level = 3;
			}
			else if (e.stageY>=430 && e.stageY<496 && levels_unlocked>=4)
			{
				this.m_menu.menu_table.bar.y = 96;
				selected_level = 4;
			}
		}

	}
}