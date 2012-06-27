package com.view
{
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.View;
	
	import flash.display.Scene;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class BasicTemplate extends Sprite{
		private var _viewWidth:int;
		private var _viewHeight:int;
		private var _scaleToStage:Boolean;
		public var rootContainer:Object3D = new Object3D();
		public var cameraContainer:Object3D = new Object3D();
		public var cam:Camera3D;
		
		/**
		 * @param    viewWidth
		 * @param    viewHeight
		 * @param    scaleToStage
		 */
		
		public function BasicTemplate(viewWidth:int=640, viewHeight:int=480, scaleToStage:Boolean = true) {
			_viewWidth = viewWidth;
			_viewHeight = viewHeight;
			_scaleToStage = scaleToStage;
			cam = new Camera3D(.1,10000);
			cam.view = new View(viewWidth,viewHeight,false,0,0,3);
			addChild(cam.view);
			addChild(cam.diagram);
			
			// Initial position
			cam.rotationX = -120*Math.PI/180;
			cam.y = -800;
			cam.z = 200;
			cameraContainer.addChild(cam);
			rootContainer.addChild(cameraContainer);
			
			// stage
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function startRendering():void {
			addEventListener(Event.ENTER_FRAME, onRenderTick);
		}
		
		public function stopRendering():void {
			removeEventListener(Event.ENTER_FRAME, onRenderTick);
		}
		
		public function singleRender():void {
			onRenderTick();
		}
		
		private function init(e:Event = null):void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.HIGH;
			
			// resize
			stage.addEventListener(Event.RESIZE, onResize);
			onResize(null);
			
			// render
			startRendering();
		}
		
		public function onRenderTick(e:Event = null):void {
			
		}
		
		private function onResize(event:Event = null):void {
			if (_scaleToStage) {
				cam.view.width = stage.stageWidth;
				cam.view.height = stage.stageHeight;
				cam.view.graphics.clear()
				cam.view.graphics.beginFill(0x000000)
				cam.view.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight)            
			}else {
				cam.view.width = _viewWidth;
				cam.view.height = _viewHeight;
				cam.view.graphics.clear();
				cam.view.graphics.beginFill(0x000000)
				cam.view.graphics.drawRect(0,0,_viewWidth,_viewHeight)
			}
		}
	}
}