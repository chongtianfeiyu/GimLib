package gim.tools
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import main.AppContainer;
	
	/**
	 * ...
	 * @author Gamba
	 */
	public class GimTools
	{
		public function GimTools()
		{
		
		}
		
		static public function loadString(url:String, onLoad:Function):void
		{
			var urlLoader:URLLoader = new URLLoader();
			var onLoadFunc:Function = function(e:Event):void
			{
				var str:String = e.currentTarget.data;
				onLoad(str);
			}
			urlLoader.addEventListener(Event.COMPLETE, onLoadFunc);
			urlLoader.load(new URLRequest(url));
		}
		
		static public function loadStringLinear(array:Array, onStringLoad:Function):void
		{
			var currentLoadIndex:int = 0;
			var strObject:Object = { };
			var onLoaded:Function = function(str:String):void
			{
				strObject[array[currentLoadIndex]] = str;
				if (currentLoadIndex < array.length - 1)
				{
					currentLoadIndex++;
					loadString(array[currentLoadIndex], onLoaded);
				}
				else
				{
					onStringLoad(strObject);
				}
			}
			loadString(array[currentLoadIndex], onLoaded);
		}
		
		static public function drawRect(sprite:Sprite, $width:Number, $height:Number):void 
		{
			sprite.graphics.beginFill(0xff0033, 0.2);
			sprite.graphics.drawRect(0, 0, $width, $height);
			sprite.graphics.endFill();
		}
		
		public static function adaptSizeToParent(dObj:DisplayObject):void
		{
			var scaleW:Number = dObj.parent.width / dObj.width;
			var scaleH:Number = dObj.parent.height / dObj.height;
			var scale:Number = scaleW < scaleH?scaleW:scaleH;
			dObj.scaleX = dObj.scaleY = scale;
			dObj.x = (dObj.parent.width - dObj.width * scale) * 0.5;
			dObj.y = (dObj.parent.height - dObj.height * scale) * 0.5;
		}
	}

}