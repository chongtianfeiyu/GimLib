package gim.maps.controlPanel 
{
	import com.bit101.components.PushButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Gamba
	 */
	public class GimVerticalContainer extends Sprite
	{
		public var gap:Number = 2;
		public var elements:Array;
		public var currentSelectedIndex:int;
		public var currentSelectedElement:PushButton;
		
		public function GimVerticalContainer() 
		{
			elements = [];
		}
		
		public function addElement(btn:PushButton):void 
		{
			elements.push(btn);
			btn.y = height + gap;
			btn.x = 0;
			btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			addChild(btn);
		}
		
		private function onBtnClick(e:MouseEvent):void 
		{
			currentSelectedIndex = elements.indexOf(e.currentTarget);
			currentSelectedElement = e.currentTarget as PushButton;
		}
		
	}

}