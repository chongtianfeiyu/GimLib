package gim.components 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author BOB
	 */
	public class GimLoading extends MovieClip
	{
		
		private var mc:MovieClip;
		private var speed:Number;
		public function GimLoading($radius:Number = 24,$size:Number = 3,$number:Number = 12,$color:uint = 0xff0033,$speed:Number = 28,isShade:Boolean = true) 
		{
			this.speed = $speed;
			mc = new MovieClip();
			addChild(mc);
			
			for (var i:int = 0; i < $number; i++) 
			{
				var angle:Number = Math.PI * 2 / $number * i;
				var ball:GimBall = new GimBall($color,0.8,$size);
				mc.addChild(ball);
				ball.x = Math.cos(angle) * $radius;
				ball.y = Math.sin(angle) * $radius;
				if (isShade)
					ball.alpha = 1 / $number * i;
			}
			
			mc.addEventListener(Event.ENTER_FRAME, doEnterFrame);
		}
		
		private function doEnterFrame(e:Event):void 
		{
			mc.rotation += speed;
		}
		
	}

}

import flash.display.Graphics;
import flash.display.Sprite;
/**
 * ...
 * @author BOB
 */
class GimBall extends Sprite
{
	
	public function GimBall(color:uint = 0xff0033,alpha:Number = 1,radius:Number = 12) 
	{
		var g:Graphics = this.graphics;
		g.beginFill(color, alpha);
		g.drawCircle(0, 0, radius);
		g.endFill();
	}
	
}