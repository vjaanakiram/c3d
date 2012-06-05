package
{
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.resources.TextureResource;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	[SWF(width="800", height="600", frameRate="30")]
	public class CarWithFollowCamera extends Sprite
	{
		private var rootContainer:Object3D = new Object3D();

		private var camera:Camera3D;
		private var stage3D:Stage3D;
		
		private var speed:Number = 0
		private var steering:Number = 0
		
		private var accelerate:Boolean;
		private var brake:Boolean;
		private var turn_left:Boolean;
		private var turn_right:Boolean;
		
		private var cameraDistance:Number = 800;

		[Embed(source="/images/wood.jpg")]
		private var texture:Class;
		
		private var car:Object3D;
		private var carBody:Box;
		private var carFront:Box;
		
		public function CarWithFollowCamera()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			// CAMERA
			camera = new Camera3D(0.1, 10000);
			camera.view = new View(stage.stageWidth, stage.stageHeight);
			addChild(camera.view);
			
			// init camera settings
			camera.rotationX = deg2rad(70);
			//camera.y = -300;
			camera.rotationZ = Math.PI;
			camera.z = -400;
			
			rootContainer.addChild(camera);
			
			// CAR
			car = new Object3D();
			// car body
			carBody = new Box(200,300,100);
			var material:FillMaterial = new FillMaterial(0xFFFF00, 0.8);
			carBody.setMaterialToAllSurfaces(material);
			carBody.y = -200;
			car.addChild(carBody);
			// car front
			carFront = new Box(200,100,100);
			carFront.setMaterialToAllSurfaces(new FillMaterial(0xFFFF00,.9));
			car.addChild(carFront);		
			
			car.z = -50;
			rootContainer.addChild(car);
			
			// MAP
			generateRandomMapOfCubes()
			
			// INIT Stage3D
			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			stage3D.requestContext3D();

			
		}
		
		
		public function followCarWithCamera():void{
			
			// Simple smoothing
			/*var targetX:Number = car.x + Math.sin(car.rotationZ)*cameraDistance;
			var targetY:Number = car.y - Math.cos(car.rotationZ)*cameraDistance;
			var targetZRotation:Number = car.rotationZ+Math.PI;
			
			camera.x -= (camera.x - targetX)*.2;
			camera.y -= (camera.y - targetY)*.2;
			camera.rotationZ -= (camera.rotationZ - targetZRotation)*.2;*/

			camera.x = car.x + Math.sin(car.rotationZ)*cameraDistance;
			camera.y = car.y - Math.cos(car.rotationZ)*cameraDistance;
			camera.rotationZ = car.rotationZ+Math.PI;
			
		}
		
		private function loop(event:Event):void{
			
			if (accelerate && speed<100) {
				speed+=2;
				
			}else if (brake) {
				speed-=2;
			}else{
				if (Math.abs(speed)>0.3) {
					speed*=0.96;
				} else {
					speed=0;
				}
			}
			
			if (turn_left) {
				steering += Math.PI/40*(speed/100);
			}
			if (turn_right) {
				steering -= Math.PI/40*(speed/100);
			}
			
			car.rotationZ = -steering
			
			car.x += speed*Math.sin(steering);
			car.y += speed*Math.cos(steering);
					
			followCarWithCamera();
			
			camera.render(stage3D);
		}
		
		
		
		public function onKeyDown(e:KeyboardEvent):void {
			if (e.keyCode==38) {
				accelerate=true;
			}
			if (e.keyCode==40) {
				brake=true;
			}
			if (e.keyCode==37) {
				turn_left=true;
			}
			if (e.keyCode==39) {
				turn_right=true;
			}
		}
		public function onKeyUp(e:KeyboardEvent):void {
			if (e.keyCode==38) {
				accelerate=false;
			}
			if (e.keyCode==40) {
				brake=false;
			}
			if (e.keyCode==37) {
				turn_left=false;
			}
			if (e.keyCode==39) {
				turn_right=false;
			}
		}
		
		// HELPER METHODS // not important to study them
		
		protected function onContextCreate(event:Event):void
		{
			for each(var resource:Resource in rootContainer.getResources(true)){
				resource.upload(stage3D.context3D);
				
			}
			
			stage.addEventListener(Event.ENTER_FRAME, loop);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			
			
		}
		
		public function generateRandomMapOfCubes():void{
			
			var ground:Box = new Box(10000,10000,1);
			ground.setMaterialToAllSurfaces(new FillMaterial(0xCCCCCC,0.3));
			rootContainer.addChild(ground);
			
			for(var i:uint = 0;i<30;i++){
				var height:Number = Math.random()*700+200;
				var b:Box = new Box(Math.random()*700+200,Math.random()*700+200,height);
				b.setMaterialToAllSurfaces(new FillMaterial(0xCCCCCC,0.5));
				
				b.z = -height/2;
				b.x = 5000-Math.random()*10000;
				b.y = 5000-Math.random()*10000;
				
				rootContainer.addChild(b);
				
			}
		}
		
		public function rad2deg(radnum:Number):Number{
			return radnum*180/Math.PI;
		}
		
		public function deg2rad(degnum:Number):Number{
			return degnum*Math.PI/180;
		}
	}
}