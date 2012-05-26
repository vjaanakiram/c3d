package com.view
{
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.View;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DRenderMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.text.TextField;
	
	import org.osmf.layout.ScaleMode;
	
	public class Cont3D extends Sprite{
		
		private var rootContainer:Object3D = new Object3D();
		private var cam:Camera3D;
		private var stage3D:Stage3D;
		private var ww:Number;
		private var hh:Number;
		// used to politely tell users about problems
		private var titlescreenTf:TextField = new TextField();
		private var basicTemplate:BasicTemplate;
		public function Cont3D(_ww:Number,_hh:Number){
			ww = _ww;
			hh = _hh;
			if(stage){
				init();
			}else{
				addEventListener(Event.ADDED_TO_STAGE,init);
			}
		}
		
		private function init(e:Event = null):void{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			cam = new Camera3D(.1,10000);
			cam.view = new View(ww,hh,false,0,0,4);
			addChild(cam.view);
			addChild(cam.diagram);
			
			cam.rotationX = -120*Math.PI/180;
			cam.y = -800;
			cam.z = 200;
			rootContainer.addChild(cam);
			
			// are we running Flash 11 with Stage3D available?
			var stage3DAvailable:Boolean = ApplicationDomain.currentDomain.hasDefinition
				("flash.display.Stage3D");
			if (stage3DAvailable)
			{
				stage3D = stage.stage3Ds[0];
				stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
				// detect when the swf is not using wmode=direct
				stage3D.addEventListener(ErrorEvent.ERROR, onStage3DError);
				// request hardware 3d mode now
				stage3D.requestContext3D();
			}
			else
			{
				trace("stage3DAvailable is false!");
				titlescreenTf.text =
					'Flash 11 Required.\nYour version: '
					+ Capabilities.version
					+'\nThis game uses Stage3D.'
					+'\nPlease upgrade to Flash 11'
					+'\nso you can play 3d games!';
			}
		}
		
		private function onContextCreate(event:Event):void{
			// Remove existing frame handler. Note that a context
			// loss can occur at any time which will force you
			// to recreate all objects we create here.
			// A context loss occurs for instance if you hit
			// CTRL-ALT-DELETE on Windows.
			// It takes a while before a new context is available
			// hence removing the enterFrame handler is important!
			
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			
			// Obtain the current context
			var t:Stage3D = event.target as Stage3D;
			var context3D:Context3D = t.context3D;   
			
			if (context3D == null)
			{
				// Currently no 3d context is available (error!)
				trace('ERROR: no context3D - video driver problem?');
				return;
			}
			
			// detect software mode (html might not have wmode=direct)
			if ((context3D.driverInfo == Context3DRenderMode.SOFTWARE)
				|| (context3D.driverInfo.indexOf('oftware')>-1))
			{
				//Context3DRenderMode.AUTO
				trace("Software mode detected!");
				titlescreenTf.text = 'Software Rendering Detected!'
					+'\nYour Flash 11 settings'
					+'\nhave hardware 3D turned OFF.'
					+'\nIs wmode=direct in the html?'
					+'\nExpect poor performance.';
			}
			// if this is too big, it changes the stage size!
			titlescreenTf.text = 'Flash 11 Stage3D '
				+'(Molehill) is working perfectly!'
				+'\nFlash Version: '
				+ Capabilities.version
				+ '\n3D mode: ' + context3D.driverInfo;
			
			// Disabling error checking will drastically improve performance.
			// If set to true, Flash sends helpful error messages regarding
			// AGAL compilation errors, uninitialized program constants, etc.
			/*context3D.enableErrorChecking = false;
			CONFIG::debug
			{
				context3D.enableErrorChecking = true; // v2
			}*/
			
			// The 3d back buffer size is in pixels
			context3D.configureBackBuffer(ww, hh, 0, true);
			
			// start animating
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			addChild(titlescreenTf);
		}
		
		private function onEnterFrame(e:Event):void {
			cam.view.width = ww;
			cam.view.height = hh;
			//box.rotationZ -= 0.01;
			cam.render(stage3D);
		}
		
		// this error is fired if the swf is not using wmode=direct
		private function onStage3DError ( e:ErrorEvent ):void{
			trace("onStage3DError!");
			titlescreenTf.text = 'Embed Error Detected!'
				+'\nYour Flash 11 settings'
				+'\nhave hardware 3D turned OFF.'
				+'\nIs wmode=direct in the html?'
				+'\nExpect poor performance.';
		}
	}
}