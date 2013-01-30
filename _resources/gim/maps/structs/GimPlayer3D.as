package gim.maps.structs
{
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.primitives.GeoSphere;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Gamba
	 */
	public class GimPlayer3D extends Object3D
	{
		private var speed:Vector3D;
		private var points:Vector.<Vector3D>;
		private var timer:Timer;
		
		public function GimPlayer3D($size:Number = 30)
		{
			super();
			var ball:GeoSphere = new GeoSphere($size, 3, false, Struct3D.getStandardMaterial(0x0099cc));
			addChild(ball);
			timer = new Timer(20, 0);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			this.visible = false;
		}
		
		private var stepRate:Number = 20;
		private var currentLength:Number;
		private var deltaStep:Number;
		private var preVector:Vector3D;
		
		private function onTimer(e:TimerEvent):void
		{
			if (index > points.length - 1)
			{
				index = 1;
				currentTargetVector = points[0];
				this.x = currentTargetVector.x;
				this.y = currentTargetVector.y;
				this.z = currentTargetVector.z;
			}
			
			preVector = points[index - 1];
			if (preVector == currentTargetVector)
			{
				currentLength = 0;
				currentTargetVector = points[index];
				var deltaX:Number = currentTargetVector.x - preVector.x;
				var deltaY:Number = currentTargetVector.y - preVector.y;
				var deltaZ:Number = currentTargetVector.z - preVector.z;
				deltaStep = Math.sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ);
				var ratio:Number = deltaStep / stepRate;
				speed.x = deltaX / ratio;
				speed.y = deltaY / ratio;
				speed.z = deltaZ / ratio;
			}
			
			this.x += speed.x;
			this.y += speed.y;
			this.z += speed.z;
			currentLength += stepRate;
			
			if (currentLength > deltaStep)
			{
				index++;
				preVector = currentTargetVector;
				this.x = currentTargetVector.x;
				this.y = currentTargetVector.y;
				this.z = currentTargetVector.z;
			}
			
			timer.start();
		}
		
		private var currentTargetVector:Vector3D;
		private var index:int;
		
		public function move($points:Vector.<Vector3D>, $stepRate:Number = 30):void
		{
			if ($points.length < 2)
				return;
			
			currentTargetVector = $points[0];
			this.x = currentTargetVector.x;
			this.y = currentTargetVector.y;
			this.z = currentTargetVector.z;
			
			index = 1;
			speed = new Vector3D();
			stepRate = $stepRate;
			this.points = $points;
			this.visible = true;
			timer.start();
		}
		
		public function stop():void
		{
			timer.stop();
			speed = null;
			this.x = 0;
			this.y = 0;
			this.z = 0;
			this.points = null;
			this.visible = false;
		}
	
	}

}