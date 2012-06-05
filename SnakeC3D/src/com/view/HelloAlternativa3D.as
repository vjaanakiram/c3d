package com.view {

	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.primitives.Box;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;

	/**
	 * Alternativa3D "Hello world!" application. 
	 * Создание простейшего трёхмерного приложения.
	 */
	public class HelloAlternativa3D extends Sprite {
		public var rootContainer:Object3D = new Object3D();
		public var msgStr:String = "";
		
		public var camera:Camera3D;
		public var stage3D:Stage3D;
		//public var box:Box;
		
		public function HelloAlternativa3D(ww:Number,hh:Number,scaleMode:Boolean) {
			// Camera and view
			// Создание камеры и вьюпорта
			camera = new Camera3D(0.1, 10000);
			camera.view = new View(ww, hh, scaleMode, 0, 0, 4);
			addChild(camera.view);
			addChild(camera.diagram);
			
			// Initial position
			// Установка положения камеры
			camera.rotationX = -120*Math.PI/180;
			camera.y = -600;
			camera.z = 300;
			rootContainer.addChild(camera);
			// Primitive box
			// Создание примитива
			//box = new Box(100, 100, 100,5, 5, 5);
			//var material:FillMaterial = new FillMaterial(0xFF7700);
			//box.setMaterialToAllSurfaces(material);
			//rootContainer.addChild(box);
			//box.y = 200;
			
			if(stage){
				init();
			}else{
				addEventListener(Event.ADDED_TO_STAGE,init);
			}
		}
		
		private function init(e:Event = null):void{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			// are we running Flash 11 with Stage3D available?
			var stage3DAvailable:Boolean = ApplicationDomain.currentDomain.hasDefinition("flash.display.Stage3D");
			if (stage3DAvailable){
				stage3D = stage.stage3Ds[0];
				stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
				// detect when the swf is not using wmode=direct
				stage3D.addEventListener(ErrorEvent.ERROR, onStage3DError);
				// request hardware 3d mode now
				stage3D.requestContext3D();
			}else{
				trace("stage3DAvailable is false!");
				msgStr = 'Flash 11 Required.\nYour version: '
					+ Capabilities.version
					+'\nThis game uses Stage3D.'
					+'\nPlease upgrade to Flash 11'
					+'\nso you can play 3d games!';
			}
			dispatchEvent(new Event(Cont3D.MSG));
			//dispatchEvent(new Event("NS3D"));
		}
		
		private function onContextCreate(e:Event):void {
			dispatchEvent(new Event("S3D"));
			for each (var resource:Resource in rootContainer.getResources(true)) {
				resource.upload(stage3D.context3D);
			}
			// Listeners
			// Подписка на события
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private var ct:Number = 5
		public function onEnterFrame(e:Event=null):void {
			// Width and height of view
			// Установка ширины и высоты вьюпорта
			//camera.view.width = stage.stageWidth;
			//camera.view.height = stage.stageHeight;
		}
		
		// this error is fired if the swf is not using wmode=direct
		private function onStage3DError( e:ErrorEvent ):void{
			trace("onStage3DError!");
			msgStr = 'Embed Error Detected!'
				+'\nYour Flash 11 settings'
				+'\nhave hardware 3D turned OFF.'
				+'\nIs wmode=direct in the html?'
				+'\nExpect poor performance.';
			
			dispatchEvent(new Event(Cont3D.MSG));
		}
		
		public function addSnake(snake:Box):void{
			trace("dd2 added new snake part...")
			rootContainer.addChild(snake);
			snake.geometry.upload(stage3D.context3D);
		}
		
	}
}
