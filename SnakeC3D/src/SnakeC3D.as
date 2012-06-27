package{
	import com.view.BalaBase3d;
	import com.view.Cont3D;
	import com.view.HelloAlternativa3D;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	
	
	public class SnakeC3D extends Sprite{
		
		[Embed(source="/images/Desert.jpg")]
		private var AssetClass:Class;
		//params.wmode="direct" //bala
		private var balaBase:BalaBase3d;
		// used to politely tell users about problems
		private var titlescreenTf:TextField = new TextField();
		
		public function SnakeC3D(){
			stage.scaleMode = StageScaleMode.EXACT_FIT
			var bg:Bitmap = new AssetClass();
			//addChild(bg);
			// change stage parameters
			stage.stageHeight = 1000;
			stage.stageWidth = 1000;
			stage.showDefaultContextMenu = false;
			balaBase = new BalaBase3d(stage.stageWidth,stage.stageHeight,true);
			balaBase.addEventListener(Cont3D.MSG,gotMsg);
			addChild(balaBase);
			//balaBase.x = 50;
			//balaBase.y = 50;
			titlescreenTf.width = 250;
			titlescreenTf.x = balaBase.x + 400;
			addChild(titlescreenTf);
			
			stage.addEventListener(Event.RESIZE, resizeListener);
			trace("starting..stageWidth: " + stage.stageWidth + " stageHeight: " + stage.stageHeight);
			balaBase.onStageResize(null);
			// add a sample red square to the display list
			var shp:Shape = new Shape();
			shp.graphics.beginFill( 0xFF0000 );
			shp.graphics.drawRect( 0, 0, 100, 100 );
			shp.graphics.endFill();
			shp.x = stage.stageWidth - 100;
			//addChild(shp);
		}
		
		private function resizeListener (e:Event):void {
			balaBase.onStageResize(null);
			trace("stageWidth: " + stage.stageWidth + " stageHeight: " + stage.stageHeight);
		}
		
		private function gotMsg(e:Event):void{
			//titlescreenTf.text = BalaBase3d.msgStr;
		}
	}
}