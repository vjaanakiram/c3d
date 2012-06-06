package com.view
{
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.DirectionalLight;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.SkyBox;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapCubeTextureResource;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.shadows.DirectionalLightShadow;
	
	import com.Elements.MySnake;
	import com.Elements.Snake;
	import com.Utils3d.SpringCameraController;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.media.Camera;

	public class BalaBase3d extends HelloAlternativa3D{
		// params.wmode="direct" //bala
		//-locale en_US -use-network=false -swf-version=13
		[Embed(source="/images/bark_diffuse.jpg")] private static const EmbedBarkDiffuse:Class;
		[Embed(source="/images/bark_normal.jpg")] private static const EmbedBarkNormal:Class;
		[Embed(source="/images/wood.jpg")] private static const EmbedGrassDiffuse:Class;
		
		
		[Embed(source = "/images/skybox/left.jpg")] static private const left_t_c:Class;
		private var left_t:BitmapTextureResource = new BitmapTextureResource(new left_t_c().bitmapData);
		[Embed(source = "/images/skybox/right.jpg")] static private const right_t_c:Class;
		private var right_t:BitmapTextureResource = new BitmapTextureResource(new right_t_c().bitmapData);
		[Embed(source = "/images/skybox/top.jpg")] static private const top_t_c:Class;
		private var top_t:BitmapTextureResource = new BitmapTextureResource(new top_t_c().bitmapData);
		[Embed(source = "/images/skybox/bottom.jpg")] static private const bottom_t_c:Class;
		private var bottom_t:BitmapTextureResource = new BitmapTextureResource(new bottom_t_c().bitmapData);
		[Embed(source = "/images/skybox/front.jpg")] static private const front_t_c:Class;
		private var front_t:BitmapTextureResource = new BitmapTextureResource(new front_t_c().bitmapData);
		[Embed(source = "/images/skybox/back.jpg")] static private const back_t_c:Class;
		private var back_t:BitmapTextureResource = new BitmapTextureResource(new back_t_c().bitmapData);
		
		private var controller:SimpleObjectController;
		private var cameraContoller:SpringCameraController;
		public var skyBox:SkyBox;
		public var mySnake:MySnake;
		public static var ww:Number;
		public static var hh:Number;
		private var cameraDistance:Number = -200;
		
		public function BalaBase3d(_ww:Number,_hh:Number,scaleMode:Boolean){
			ww = _ww;
			hh = _hh;
			super(ww,hh,scaleMode);
			//super.addEventListener("NS3D",noStage3D);
			super.addEventListener("S3D",BReady);
		}
		
		private function BReady(e:Event):void{
			trace("3dd BReady...");
			addSky();
			addElements();
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownFun);
		}
		
		private function addSky():void{
			skyBox = new SkyBox(3000, 
				new TextureMaterial(left_t), 
				new TextureMaterial(right_t), 
				new TextureMaterial(back_t), 
				new TextureMaterial(front_t), 
				new TextureMaterial(bottom_t), 
				new TextureMaterial(top_t), 0.01);
			rootContainer.addChild(skyBox);
		}
		//private var cameraContoller:SpringCameraController
		private function addElements():void{
			mySnake = new MySnake();
			mySnake.addEventListener(Snake.ADDED_PART,addedNewSnakePart);
			rootContainer.addChild(mySnake);
			controller = new SimpleObjectController(stage, camera,100);
			//controller.mouseSensitivity = .01;
			controller.lookAtXYZ(0,0,0);
			controller.unbindAll();
			var grass_diffuse:BitmapTextureResource = new BitmapTextureResource(new EmbedGrassDiffuse().bitmapData);
			var grass_normal:BitmapTextureResource = new BitmapTextureResource(new BitmapData(1, 1, false, 0x7F7FFF));
			
			var bark_diffuse:BitmapTextureResource = new BitmapTextureResource(new EmbedBarkDiffuse().bitmapData);
			var bark_normal:BitmapTextureResource = new BitmapTextureResource(new BitmapData(1,1,false,0xff0000));//new EmbedBarkNormal().bitmapData);
			
			bark_diffuse.upload(stage3D.context3D);
			bark_normal.upload(stage3D.context3D);
			var grassMaterial:StandardMaterial = new StandardMaterial(grass_diffuse, grass_normal);
			grassMaterial.specularPower = 0.24;
			var barkMaterial:StandardMaterial = new StandardMaterial(bark_diffuse, bark_normal);
			barkMaterial.specularPower = .4
				
			var platform:Box = new Box(300, 300, 50);
			platform.geometry.upload(stage3D.context3D);
			platform.setMaterialToAllSurfaces(barkMaterial);
			platform.z = 25;
			//rootContainer.addChild(platform);
			
			var grass:Plane = new Plane(900, 900,10,10);//______________________________
			grass.geometry.upload(stage3D.context3D);
			
			grass.setMaterialToAllSurfaces(new FillMaterial(0xcccccc,0.7));
			//grass.setMaterialToAllSurfaces(grassMaterial);
			rootContainer.addChild(grass);
			grass.z = -5;
			uploadResources(mySnake.getResources(true));
			
			
			// Light sources
			// Источники света
			var ambientLight:AmbientLight = new AmbientLight(0xFF0f0F0f);
			ambientLight.visible = true;
			rootContainer.addChild(ambientLight);
			var light:OmniLight = new OmniLight(0xffff0000,500,1200);
			//light.intensity = 1000;
			light.x =-400
			// light.y = -40
			light.z = -400;
			rootContainer.addChild(light);
			
			var directionalLight:DirectionalLight = new DirectionalLight(0xFFFF99);
			directionalLight.lookAt(-0.5, -1, -1);
			rootContainer.addChild(directionalLight);
			
			
			// Shadow
			// Тень
			var shadow:DirectionalLightShadow = new DirectionalLightShadow(1000, 1000, -500, 500, 512, 2);
			shadow.biasMultiplier = 0.97;
			shadow.addCaster(platform);
			shadow.addCaster(mySnake.head);
			directionalLight.shadow = shadow;
			
			//camera.fov=100*Math.PI/180;
			
			
			//cameraContoller = new SpringCameraController(this,camera,100);
			//cameraContoller.target = mySnake.apple;
			//cameraContoller.mass = 3;
			//cameraContoller.damping = 3;
			//cameraContoller.stiffness = 1;
			//cameraContoller.positionOffset = new Vector3D(0, 60, 60);
			//cameraContoller.lookOffset = new Vector3D(0, 0, 0);
		}
		
		private function addedNewSnakePart(e:Event):void{
			trace("3dd addedNewSnakePart uploading..");
			uploadResources(mySnake.getResources(true));
		}
		
		private function keyDownFun(e:KeyboardEvent):void{
			trace("3dd keyDownFun")
			mySnake.directionChanged(e);
		}
		
		private function uploadResources(resources:Vector.<Resource>):void {
			for each (var resource:Resource in resources) {
				resource.upload(stage3D.context3D);
			}
		}
		
		public override function onEnterFrame(e:Event=null):void{
			super.onEnterFrame();
			//cameraContoller.update();
			//trace("3dd1 snake headpos",mySnake.head.x)
			//controller.lookAtXYZ(mySnake.head.x,mySnake.head.y,mySnake.head.z);
			//controller.update();
			camera.x = mySnake.head.x + Math.sin(mySnake.head.rotationZ)*cameraDistance;
			camera.y = mySnake.head.y + Math.cos(mySnake.head.rotationZ)*cameraDistance;
			//camera.rotationZ = mySnake.head.rotationZ+Math.PI; // Math.PI = 180 deg
			camera.render(stage3D);
		}
	}
}