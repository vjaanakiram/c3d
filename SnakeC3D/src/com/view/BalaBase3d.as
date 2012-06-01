package com.view
{
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.DirectionalLight;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.shadows.DirectionalLightShadow;
	
	import com.Elements.MySnake;
	import com.Utils3d.SpringCameraController;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Vector3D;

	public class BalaBase3d extends HelloAlternativa3D{
		// params.wmode="direct" //bala
		//-locale en_US -use-network=false -swf-version=13
		[Embed(source="/images/bark_diffuse.jpg")] private static const EmbedBarkDiffuse:Class;
		[Embed(source="/images/bark_normal.jpg")] private static const EmbedBarkNormal:Class;
		[Embed(source="/images/grass.jpg")] private static const EmbedGrassDiffuse:Class;
		
		private var controller:SimpleObjectController;
		public var mySnake:MySnake;
		public var ww:Number;
		public var hh:Number;
		
		public function BalaBase3d(_ww:Number,_hh:Number,scaleMode:Boolean){
			ww = _ww;
			hh = _hh;
			super(ww,hh,scaleMode);
			super.addEventListener("BR",BReady);
		}
		
		private function BReady(e:Event):void{
			trace("bready...")
			addElements();
		}
		private var cameraContoller:SpringCameraController
		private function addElements():void{
			mySnake = new MySnake(this);
			controller = new SimpleObjectController(stage, camera, 200);
			controller.mouseSensitivity = .01;
			var grass_diffuse:BitmapTextureResource = new BitmapTextureResource(new EmbedGrassDiffuse().bitmapData);
			var grass_normal:BitmapTextureResource = new BitmapTextureResource(new BitmapData(1, 1, false, 0x7F7FFF));
			
			var bark_diffuse:BitmapTextureResource = new BitmapTextureResource(new EmbedBarkDiffuse().bitmapData);
			var bark_normal:BitmapTextureResource = new BitmapTextureResource(new BitmapData(1,1,false,0xff0000));//new EmbedBarkNormal().bitmapData);
			
			bark_diffuse.upload(stage3D.context3D);
			bark_normal.upload(stage3D.context3D);
			
			var grassMaterial:StandardMaterial = new StandardMaterial(grass_diffuse, grass_normal);
			grassMaterial.specularPower = 0.14;
			var barkMaterial:StandardMaterial = new StandardMaterial(bark_diffuse, bark_normal);
			barkMaterial.specularPower = .4
				
			var platform:Box = new Box(300, 300, 50);
			platform.geometry.upload(stage3D.context3D);
			platform.setMaterialToAllSurfaces(barkMaterial);
			platform.z = 25;
			//rootContainer.addChild(platform);
			
			var grass:Plane = new Plane(900, 900);
			grass.geometry.upload(stage3D.context3D);
			grass.setMaterialToAllSurfaces(grassMaterial);
			rootContainer.addChild(grass);
			
			
			// Light sources
			// Источники света
			var ambientLight:AmbientLight = new AmbientLight(0x333333);
			rootContainer.addChild(ambientLight);
			var directionalLight:DirectionalLight = new DirectionalLight(0xFFFF99);
			directionalLight.lookAt(-0.5, -1, -1);
			rootContainer.addChild(directionalLight);
			
			
			// Shadow
			// Тень
			var shadow:DirectionalLightShadow = new DirectionalLightShadow(1000, 1000, -500, 500, 512, 2);
			shadow.biasMultiplier = 0.97;
			shadow.addCaster(platform);
			shadow.addCaster(box);
			directionalLight.shadow = shadow;
			
			cameraContoller = new SpringCameraController(this,camera,100);
			//cameraContoller.target=box;
			
			camera.fov=100*Math.PI/180;
			
			cameraContoller.mass = 30;
			cameraContoller.damping = 30;
			cameraContoller.stiffness = 1;
			cameraContoller.positionOffset = new Vector3D(50, 200, 100);
			cameraContoller.lookOffset = new Vector3D(0, 0, 0);
		}
		
		public override function onEnterFrame(e:Event=null):void{
			super.onEnterFrame();
			//cameraContoller.update();
			controller.update();
		}
	}
}