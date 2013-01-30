package gim.events
{
	import flash.events.Event;

	public class GimEvent extends Event
	{
		public static var BUTTON_CLICKED:String = "BUTTON_CLICKED";
		public static var RIGHT_VIEW_CLOSED:String = "VIEW_CLOSED";
		
		public var data:Object;
		public function GimEvent($type:String,$data:Object = null)
		{
			super($type,true);
			data = $data;
		}
	}
}