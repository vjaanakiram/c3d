package com.Elements 
{
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.primitives.Box;
	
	import flash.display.Shape;
	
	public class Element extends Box
	{
		protected var _direction:String;
		//IF IT IS AN APPLE ->
		protected var _catchValue:Number;
		private var _width:Number = 20;
		private var _height:Number = 20;
		private var _alpha:Number = 1;
		
		//color,alpha,width,height				
		public function Element(_c:uint,_a:Number,_w:Number,_h:Number) {
			super(_w,_h,_h,4,4,4);
			var material:FillMaterial = new FillMaterial(0xFF7700);
			setMaterialToAllSurfaces(material);
			/*graphics.lineStyle(0, _c, _a);
			graphics.beginFill(_c, _a);
			graphics.drawRect(0, 0, _w, _h);
			graphics.endFill();*/
			
			_catchValue = 0;
		}
		
		//ONLY USED IN CASE OF A PART OF THE SNAKE

		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			_alpha = value;
		}

		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}

		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}

		public function set direction(value:String):void
		{
			_direction = value;
		}
		public function get direction():String
		{
			return _direction;
		}
		
		//ONLY USED IN CASE OF AN APPLE
		public function set catchValue(value:Number):void
		{
			_catchValue = value;
		}
		public function get catchValue():Number
		{
			return _catchValue;
		}
	}

}