/**
 * @author Balakrishna [vamsibalu@gmail.com]
 * @version 2.0
 */
package com.Elements  
{
	import alternativa.engine3d.core.Object3D;
	
	import com.model.PlayerDataVO;
	import com.view.BalaBase3d;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	
	public class Snake extends Object3D
	{
		//DO NOT GIVE THEM A VALUE HERE! Give them a value in the init() function
		public var snake_vector:Vector.<Element>; //the snake's parts are held in here and visible to Board bala
		public var markers_vector:Vector.<Object>; //the markers are held in here bala
		public var timer:Timer;//for sync to Remote Time on Board
		private var dead:Boolean;
		private var min_elements:int; //holds how many parts should the snake have at the beginning
		private var apple:Element; //Our apple
		private var space_value:Number; //space between the snake parts
		public var last_button_down:uint; //the keyCode of the last button pressed to any snake (bala)
		public var flag:Boolean; //is it allowed to change direction? bala
		private var score:Number;
		private var score_tf:TextField; //the Textfield showing the score
		private var remoteSnake:Boolean;
		public var playerData:PlayerDataVO = new PlayerDataVO();
		private var brickSize:Number = 15;
		//private var base:BalaBase3d;
		public static const ADDED_PART:String = "addedsnakepart";
		
		public function Snake(_remoteSnake:Boolean) {
			//base = _base;
			remoteSnake = _remoteSnake;
			//if(stage)
			//this.addEventListener(Event.ADDED_TO_STAGE, init);
			init();
		}
		
		private function init(e:Event = null):void{
			snake_vector = new Vector.<Element>;
			markers_vector = new Vector.<Object>;
			space_value = 2;
			timer = new Timer(700); //Every 50th millisecond, the moveIt() function will be fired!
			dead = false;
			min_elements = 1;
			//apple = new Element(0xFF0000, 1,10, 10); //red, not transparent, width:10, height: 10;
			//apple.catchValue = 0; //pretty obvious
			last_button_down = Keyboard.RIGHT; //The starting direction of the snake (only change it if you change the 'for cycle' too.)
			score = 0;
			score_tf = new TextField();
			//this.addChild(score_tf);
			
			//Create the first <min_elements> Snake parts
			for(var i:int=0;i<min_elements;++i){
				snake_vector[i] = new Element(0x00AAFF,1,brickSize,brickSize);
				//snake_vector[i].rotationZ = Math.random()*45;
				snake_vector[i].direction = "R"; //The starting direction of the snake
				if (i == 0){
					//you have to place the first element on a GRID. (now: 0,0) [possible x positions: (snake_vector[0].width+space_value)*<UINT> ]
					attachElement(snake_vector[i],0,0,snake_vector[i].direction) 
					snake_vector[0].alpha = 0.7;
				}else{
					attachElement(snake_vector[i], snake_vector[i - 1].x, snake_vector[i - 1].y, snake_vector[i - 1].direction);
				}
			}
			
			placeApple(snake_vector,false);  //for 1st time board will add
			timer.addEventListener(TimerEvent.TIMER,moveIt);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN,directionChanged);
			timer.start();
		}
		
		//for remoteSnake to use xml data
		public function attachElement(who:Element,lastXPos:Number = 0,lastYPos:Number = 0,dirOfLast:String = "R"):void
		{
			if (dirOfLast == "R")
			{
				who.x = lastXPos - snake_vector[0].width - space_value;
				who.y = lastYPos;
			}
			else if(dirOfLast == "L")
			{
				who.x = lastXPos + snake_vector[0].width + space_value;
				who.y = lastYPos;
			}
			else if(dirOfLast == "U")
			{
				who.x = lastXPos;
				who.y = lastYPos - snake_vector[0].height + space_value;
			}
			else if(dirOfLast == "D")
			{
				who.x = lastXPos;
				who.y = lastYPos + snake_vector[0].height - space_value;
			}
			//this.addChild(who);
			//base.addSnake(who);
			addChild(who);
			dispatchEvent(new Event(Snake.ADDED_PART));
		}
		
		//Moving Snake..
		private function moveIt(e:TimerEvent):void{
			if(apple && remoteSnake == false){
				if (snake_vector[0].x == apple.x && snake_vector[0].y == apple.y){
					placeApple(snake_vector);
					trace("3dd1 dispatching..I_GOT_FOOD");
					dispatchEvent(new Event(MySnake.I_GOT_FOOD));
					
					//show the current Score
					score += apple.catchValue;
					score_tf.text = "Score:" + String(score);
					playerData.score = String(score);
					//Attach a new snake Element
					snake_vector.push(new Element(0x00AAFF,1,brickSize,brickSize));
					snake_vector[snake_vector.length-1].direction = snake_vector[snake_vector.length-2].direction; //lastOneRichtung
					attachElement(snake_vector[snake_vector.length-1],
						(snake_vector[snake_vector.length-2].x),
						snake_vector[snake_vector.length-2].y,
						snake_vector[snake_vector.length-2].direction);
				}
			}
			
			
			if(remoteSnake == false){
				if (snake_vector[0].x > BalaBase3d.ww-snake_vector[0].width || snake_vector[0].x < 0 || snake_vector[0].y > BalaBase3d.hh-snake_vector[0].height || snake_vector[0].y < 0){
					GAME_OVER();
				}
			}
			
			for (var i:int = 0; i < snake_vector.length; i++)
			{
				if (markers_vector.length > 0)
				{
					for(var j:uint=0;j < markers_vector.length;j++)
					{
						if(snake_vector[i].x == markers_vector[j].x && snake_vector[i].y == markers_vector[j].y)
						{
							snake_vector[i].direction = markers_vector[j].type;
							if(i == snake_vector.length-1)
							{
								markers_vector.splice(j, 1);
							}
						}
					}
				}
				if(remoteSnake == false){
					if (snake_vector[i] != snake_vector[0] && (snake_vector[0].x == snake_vector[i].x && snake_vector[0].y == snake_vector[i].y))
					{
						GAME_OVER();
					}
				}
				
				//Move the boy
				var DIRECTION:String = snake_vector[i].direction;
				switch (DIRECTION){
					case "R" :
						snake_vector[i].x += snake_vector[i].width + space_value;
						break;
					case "L" :
						snake_vector[i].x -= snake_vector[i].width + space_value;
						break;
					case "D" :
						snake_vector[i].y -= snake_vector[i].height + space_value;
						break;
					case "U" :
						snake_vector[i].y += snake_vector[i].width + space_value;
						break;
				}
				
			}
			flag = true;
		}
		
		private function GAME_OVER():void {
			//trace("3dd GameOver..")
			//dead = true;
			//timer.stop();
			/*while (base.rootContainer.numChildren)
			this.removeChildAt(0);*/
			//timer.removeEventListener(TimerEvent.TIMER,moveIt);
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,directionChanged);
			//init();
		}
		
		public function placeApple(snake_vector:Vector.<Element>,caught:Boolean = true):void{
			trace("dd5 placeApple")
			if(apple == null){
				apple = new Element(0xFF0000,1,brickSize, brickSize);
				addChild(apple);
			}
			apple.catchValue = 0;
			
			if (caught)
				apple.catchValue += 10;
			
			var boundsX:int = (Math.floor(BalaBase3d.ww / (snake_vector[0].width + space_value)))-1;
			var randomX:Number = Math.floor(Math.random()*boundsX);
			
			var boundsY:int = (Math.floor(BalaBase3d.hh/(snake_vector[0].height + space_value)))-1;
			var randomY:Number = Math.floor(Math.random()*boundsY);
			
			apple.x = randomX * (brickSize + space_value);
			apple.y = randomY * (brickSize + space_value);
			
			for(var i:uint=0;i<snake_vector.length-1;i++){
				if(snake_vector[i].x == apple.x && snake_vector[i].y == apple.y)
					placeApple(snake_vector,false);
			}
		}
		
	}
	
}