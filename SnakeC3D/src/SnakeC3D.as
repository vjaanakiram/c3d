package{
	import com.view.BalaBase3d;
	import com.view.Cont3D;
	import com.view.HelloAlternativa3D;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	
	public class SnakeC3D extends Sprite{
		
		[Embed(source="/images/Desert.jpg")]
		private var AssetClass:Class;
		//public class SnakeC3D extends Sprite{
		private var balaBase:BalaBase3d;
		// used to politely tell users about problems
		private var titlescreenTf:TextField = new TextField();
		public function SnakeC3D(){
			var bg:Bitmap = new AssetClass();
			addChild(bg);
			balaBase = new BalaBase3d(100,100,true);
			balaBase.addEventListener(Cont3D.MSG,gotMsg);
			addChild(balaBase);
			balaBase.x = 50;
			balaBase.y = 50;
			titlescreenTf.width = 250;
			titlescreenTf.x = balaBase.x + 400;
			addChild(titlescreenTf);
		}
		
		private function gotMsg(e:Event):void{
			//titlescreenTf.text = BalaBase3d.msgStr;
		}
	}
}