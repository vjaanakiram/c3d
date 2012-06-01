package com.Utils3d
{
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Object3D;
	
	import flash.display.InteractiveObject;
	import flash.geom.Vector3D;
	
	public class SpringCameraController extends SimpleObjectController
	{
		private var _camTarget:Object3D;
		private var _zrot:Number = 0;
		
		public var mass:Number = 40;
		public var damping:Number = 4;
		public var stiffness:Number = 1;
		public var positionOffset:Vector3D = new Vector3D(0, -50, 5);
		public var lookOffset:Vector3D = new Vector3D(0, 10, 2);
		
		public function SpringCameraController(eventSource:InteractiveObject, object:Object3D, speed:Number, speedMultiplier:Number=3, mouseSensitivity:Number=1)
		{
			super(eventSource, object, speed, speedMultiplier, mouseSensitivity);
		}
		
		public function set target(t:Object3D):void {
			_camTarget=t;
		}
		
		public function get target():Object3D {
			return _camTarget;
		}
		
		public function set zrot(n:Number):void {
			_zrot = n;
			if(_zrot < 0.001) n = 0;
		}
		
		public function get zrot():Number {
			return _zrot;
		}
		
		private var _velocity:Vector3D = new Vector3D();
		private var _dv:Vector3D = new Vector3D();
		private var _stretch:Vector3D = new Vector3D();
		private var _force:Vector3D = new Vector3D();
		private var _acceleration:Vector3D = new Vector3D();
		
		private var _desiredPosition:Vector3D = new Vector3D();
		private var _lookAtPosition:Vector3D = new Vector3D();
		private var _xPosition:Vector3D = new Vector3D();
		
		override public function update():void {
			if(_camTarget != null) {
				
				_desiredPosition = new Vector3D(_camTarget.x,_camTarget.y,_camTarget.z);
				_desiredPosition=_desiredPosition.add(positionOffset.clone());
				
				_stretch.x = (object.x - _desiredPosition.x) * -stiffness;
				_stretch.y = (object.y - _desiredPosition.y) * -stiffness;
				_stretch.z = (object.z - _desiredPosition.z) * -stiffness;
				
				_dv.x = _velocity.x * damping;
				_dv.y = _velocity.y * damping;
				_dv.z = _velocity.z * damping;
				
				_force.x = _stretch.x - _dv.x;
				_force.y = _stretch.y - _dv.y;
				_force.z = _stretch.z - _dv.z;
				
				_acceleration.x = _force.x * (1 / mass);
				_acceleration.y = _force.y * (1 / mass);
				_acceleration.z = _force.z * (1 / mass);
				
				_velocity=_velocity.add(_acceleration);
				_xPosition=new Vector3D(object.x,object.y,object.z);
				_xPosition=_xPosition.add(_velocity);
				
				setObjectPos(_xPosition);
				
				_lookAtPosition= new Vector3D(_camTarget.x,_camTarget.y,_camTarget.z);
				_lookAtPosition=_lookAtPosition.add(lookOffset.clone());
				lookAt(_lookAtPosition);
				if(Math.abs(_zrot) > 0) object.rotationY = _zrot;
				updateObjectTransform()
			}
		}
	}
}