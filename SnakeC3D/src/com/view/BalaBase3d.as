package com.view
{
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.DirectionalLight;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.engine3d.loaders.ParserA3D;
	import alternativa.engine3d.loaders.ParserCollada;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.SkyBox;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapCubeTextureResource;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.shadows.DirectionalLightShadow;
	
	import com.Elements.MySnake;
	import com.Elements.Snake;
	import com.Utils3d.MatCont;
	import com.Utils3d.SpringCameraController;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.media.Camera;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	public class BalaBase3d extends HelloAlternativa3D{
		
		private var controller:SimpleObjectController;
		//private var cameraContoller:SpringCameraController;
		private var  directionalLight:DirectionalLight;
		public var skyBox:SkyBox;
		public var mySnake:MySnake;
		public static var ww:Number;
		public static var hh:Number;
		public var cameraDistance:Number = -300;
		private var bxml:XML;
		private var bparser:ParserCollada = new ParserCollada();
		
		public function BalaBase3d(_ww:Number,_hh:Number,scaleMode:Boolean){
			ww = _ww;
			hh = _hh;
			super(ww,hh,scaleMode);
			//super.addEventListener("NS3D",noStage3D);
			super.addEventListener("S3D",BReady);
			bxml = new XML(new MatCont.bmodel());
		}
		
		private function BReady(e:Event):void{
			trace("3dd BReady...");
			addSky();
			//myCollada();
			addElements();
			controller = new SimpleObjectController(stage, cameraContainer,100);
			//controller.mouseSensitivity = .01;
			controller.lookAtXYZ(0,0,0);
			//controller.unbindAll();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownFun);
		}
		
		private function myCollada():void{
			bparser.parse(bxml);
			var dog:Mesh;
			var myObj:Object3D = new Object3D();
			// itarate all objects
			for (var i:int = 0; i < bparser.objects.length; i++) {
				if (bparser.objects[i]) {
					// if object is not null, then get it
					if (bparser.objects[i] is Mesh) {
						trace(" got myModel is Mesh",bparser.objects[i])
						dog = bparser.objects[i] as Mesh;
						// set material
						//dog.setMaterialToAllSurfaces(new TextureMaterial(new BitmapTextureResource(new;
						dog.setMaterialToAllSurfaces(new FillMaterial());
						//rootContainer.addChild(dog);
					}
				}
			}
			// add to container
			//rootContainer.addChild(dog);
			// upload resources to context
			for each (var dogResource:Resource in dog.getResources()) {
				trace(" got myModel dogResource",dogResource)
				if(dogResource is Mesh){
					Mesh(dogResource).setMaterialToAllSurfaces(new MatCont.left_t_c().bitmapData);
				}
				dogResource.upload(stage3D.context3D);
			}
			
			for each (var child:Object3D in bparser.hierarchy){
				if(child is Mesh){
					Mesh(child).setMaterialToAllSurfaces(new FillMaterial(0xff0000));
				}
				myObj.addChild(child);
			}
			//rootContainer.addChild(myObj);
		}
		
		private function addSky():void{
			skyBox = new SkyBox(3000, 
				new TextureMaterial(MatCont.left_t), 
				new TextureMaterial(MatCont.right_t), 
				new TextureMaterial(MatCont.back_t), 
				new TextureMaterial(MatCont.front_t), 
				new TextureMaterial(MatCont.bottom_t), 
				new TextureMaterial(MatCont.top_t), 0.01);
			rootContainer.addChild(skyBox);
		}
		
		private function addElements():void{
			mySnake = new MySnake();
			mySnake.addEventListener(Snake.ADDED_PART,addedNewSnakePart);
			rootContainer.addChild(mySnake);
			
			MatCont.bark_diffuse.upload(stage3D.context3D);
			MatCont.bark_normal.upload(stage3D.context3D);
			var grassMaterial:StandardMaterial = new StandardMaterial(MatCont.grass_diffuse, MatCont.grass_normal);
			grassMaterial.specularPower = 0.24;
			var barkMaterial:StandardMaterial = new StandardMaterial(MatCont.bark_diffuse, MatCont.bark_normal);
			barkMaterial.specularPower = .4
			
			var platform:Box = new Box(300, 300, 50);
			platform.geometry.upload(stage3D.context3D);
			platform.setMaterialToAllSurfaces(barkMaterial);
			platform.z = 25;
			//rootContainer.addChild(platform);
			
			var floor:Plane = new Plane(900, 900,10,10);//______________________________
			floor.geometry.upload(stage3D.context3D);
			
			//grass.setMaterialToAllSurfaces(new FillMaterial(0xcccccc));
			floor.setMaterialToAllSurfaces(grassMaterial);
			rootContainer.addChild(floor);
			floor.z = -5;
			uploadResources(mySnake.getResources(true));
			
			
			// Light sources
			// Источники света
			var ambientLight:AmbientLight = new AmbientLight(0xFF0f0F0f);
			ambientLight.visible = true;
			//rootContainer.addChild(ambientLight);
			var light:OmniLight = new OmniLight(0x0000ff,500,1200);
			light.visible = true
			light.intensity = 1000;
			//light.x =-400
			// light.y = -40
			light.z = 400;
			//rootContainer.addChild(light);
			
			directionalLight = new DirectionalLight(0xFFFF99);
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
			//loadExternal();
		}
		
		private function addedNewSnakePart(e:Event):void{
			trace("3dd addedNewSnakePart uploading..");
			uploadResources(mySnake.getResources(true));
		}
		//private var twn:TweenLite = new TweenLite(this,3,{cameraDistance:-600, ease:Linear.easeNone});
		private function keyDownFun(e:KeyboardEvent):void{
			trace("3dd keyDownFun")
			if (e.keyCode == Keyboard.DOWN){
				//cameraDistance = -600;
				//twn.restart();
				TweenLite.killTweensOf(this);
				TweenLite.to(this, 6, {cameraDistance:-500, ease:Linear.easeNone}); //onUpdate:showScore
				//cameraDistance = cameraDistance
			}else if(e.keyCode == Keyboard.UP){
				//cameraDistance = -200;
				//twn.reverse();
				TweenLite.killTweensOf(this);
				TweenLite.to(this, 6, {cameraDistance:-300, ease:Linear.easeNone});
			}
			mySnake.directionChanged(e);
		}
		
		private function uploadResources(resources:Vector.<Resource>):void {
			for each (var resource:Resource in resources) {
				resource.upload(stage3D.context3D);
			}
		}
		
		private function loadExternal():void{
			var loaderA3D:URLLoader = new URLLoader(); //create a URLLoader
			loaderA3D.dataFormat = URLLoaderDataFormat.BINARY; //indicate that the content was loaded as a byte array, not as a text
			loaderA3D.load(new URLRequest("myExpo.a3d"));
			loaderA3D.addEventListener(Event.COMPLETE, onA3DLoad); //end load
		}
		private var myModel:Mesh;
		private function onA3DLoad(e:Event):void {
			trace("myModel BINARY.. loaded")
			var parser:ParserA3D = new ParserA3D(); //create a parser
			parser.parse((e.target as URLLoader).data); //parse model
			
			myModel = new Mesh();
			rootContainer.addChild(myModel); //add to the main container
			for each(var obj:Object3D in parser.objects){
				trace("3dd2 myObjs",obj);
				if (obj is Mesh){
					var mesh:Mesh = Mesh(obj); //transform in Mesh
					myModel.addChild(mesh);
				}
			}
			
			for each (var resource:Resource in rootContainer.getResources(true)){
				resource.upload(stage3D.context3D);
			} 
		}
		
		public override function onEnterFrame(e:Event=null):void{
			super.onEnterFrame();
			//directionalLight.lookAt(mySnake.apple.x,mySnake.apple.y,-10);
			//cameraContoller.update();
			//trace("3dd1 snake headpos",mySnake.head.x)
			//controller.lookAtXYZ(mySnake.head.x,mySnake.head.y,mySnake.head.z);
			controller.update();
			//camera.x = mySnake.head.x + Math.sin(mySnake.head.rotationZ)*cameraDistance;
			//camera.y = mySnake.head.y + Math.cos(mySnake.head.rotationZ)*cameraDistance;
			//camera.rotationZ = mySnake.head.rotationZ+Math.PI; // Math.PI = 180 deg
			camera.render(stage3D);
		}
		
		public function onStageResize(e:Event):void{
			camera.view.width = stage.stageWidth;
			camera.view.height = stage.stageHeight;
		}
	}
}