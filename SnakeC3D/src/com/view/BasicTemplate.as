package com.view
{
	import alternativa.engine3d.controllers.CameraController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Scene3D;
	import alternativa.engine3d.display.View;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class BasicTemplate extends Sprite
	{
		/**
		 * シーンインスタンスです。
		 */
		public var scene:Scene3D;
		/**
		 * ビューインスタンスです。
		 */
		public var view:View;
		/**
		 * カメラインスタンスです。
		 */
		public var camera:Camera3D;
		/**
		 * カメラコントローラーです。
		 */
		public var cameraController:CameraController;
		
		private var _viewWidth:int;
		private var _viewHeight:int;
		private var _scaleToStage:Boolean;
		
		/**
		 * 新しい BasicTemplate インスタンスを作成します。
		 * @param    viewWidth
		 * @param    viewHeight
		 * @param    scaleToStage
		 */
		
		public function BasicTemplate(viewWidth:int=640, viewHeight:int=480, scaleToStage:Boolean = true) {
			_viewWidth = viewWidth;
			_viewHeight = viewHeight;
			_scaleToStage = scaleToStage;
			
			// Creating scene
			scene = new Scene3D();
			scene.splitAnalysis = false; // not analysis for performance
			scene.root = new Object3D();
			
			// Adding camera
			camera = new Camera3D();
			camera.z = -1000;
			scene.root.addChild(camera);
			
			// camera contoller
			cameraController = new CameraController(this);
			cameraController.camera = camera;
			
			// set view
			view = new View();
			view.camera = camera;
			addChild(view);
			
			// stage
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * 初期化されたときに実行されるイベントです。
		 * 初期化時に実行したい処理をオーバーライドして記述します。
		 */
		protected function atInit():void {}
		
		/**
		 * 初期化されたときに実行されるイベントです。
		 * 初期化時に実行したい処理を記述します。
		 */
		private var _onInit:Function = function():void { };
		public function get onInit():Function { return _onInit; }
		public function set onInit(value:Function):void {
			_onInit = value;
		}
		
		/**
		 * Event.ENTER_FRAME 時に実行されるレンダリングのイベントです。
		 * レンダリング前に実行したい処理をオーバーライドして記述します。
		 */
		protected function atPreRender():void {}
		
		/**
		 * Event.ENTER_FRAME 時に実行されるレンダリングのイベントです。
		 * レンダリング前に実行したい処理を記述します。
		 */
		private var _onPreRender:Function = function():void{};
		public function get onPreRender():Function { return _onPreRender; }
		public function set onPreRender(value:Function):void {
			_onPreRender = value;
		}
		
		/**
		 * Event.ENTER_FRAME 時に実行されるレンダリングのイベントです。
		 * レンダリング後に実行したい処理をオーバーライドして記述します。
		 */
		protected function atPostRender():void {
		}
		
		/**
		 * Event.ENTER_FRAME 時に実行されるレンダリングのイベントです。
		 * レンダリング後に実行したい処理を記述します。
		 */
		protected var _onPostRender:Function = function():void{};
		public function get onPostRender():Function { return _onPostRender; }
		public function set onPostRender(value:Function):void {
			_onPostRender = value;
		}
		
		/**
		 * レンダリングを開始します。
		 */
		public function startRendering():void {
			addEventListener(Event.ENTER_FRAME, onRenderTick);
		}
		/**
		 * レンダリングを停止します。
		 */
		public function stopRendering():void {
			removeEventListener(Event.ENTER_FRAME, onRenderTick);
		}
		
		/**
		 * シングルレンダリング(レンダリングを一回だけ)を実行します。
		 */
		public function singleRender():void {
			onRenderTick();
		}
		
		/**
		 * @private
		 */
		private function init(e:Event = null):void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.HIGH;
			
			// resize
			stage.addEventListener(Event.RESIZE, onResize);
			onResize(null);
			
			// render
			startRendering();
			
			atInit();
			_onInit();
			
		}
		
		/**
		 * @private
		 */
		private function onRenderTick(e:Event = null):void {
			atPreRender();
			_onPreRender();
			scene.calculate();
			atPostRender();
			_onPostRender();
		}
		
		/**
		 * @private
		 */
		private function onResize(event:Event = null):void {
			if (_scaleToStage) {
				view.width = stage.stageWidth;
				view.height = stage.stageHeight;
				view.graphics.clear()
				view.graphics.beginFill(0x000000)
				view.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight)            
			}else {
				view.width = _viewWidth;
				view.height = _viewHeight;
				view.graphics.clear();
				view.graphics.beginFill(0x000000)
				view.graphics.drawRect(0,0,_viewWidth,_viewHeight)
			}
		}
	}
}