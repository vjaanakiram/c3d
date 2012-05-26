package{
	import com.view.Cont3D;
	
	import flash.display.Sprite;
	
	public class SnakeC3D extends Sprite
	{
		private var cont3d:Cont3D;
		public function SnakeC3D()
		{
			cont3d = new Cont3D(400,400);
			addChild(cont3d);
			cont3d.x = 50;
			cont3d.y = 50;
			
		}
	}
}