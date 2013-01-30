package core
{
	import caurina.transitions.Tweener;
	
	import gim.patterns.interfaces.Observer;
	import gim.patterns.interfaces.Subject;
	
	import spark.components.Group;

	public class BaseButtonBar extends Group implements Subject
	{
		public function BaseButtonBar()
		{
		}
		
		public function show():void
		{
			this.visible = true;
			this.alpha = 0;
			Tweener.removeTweens(this);
			Tweener.addTween(this,{alpha:1,time:1});
		}
		
		public function hide():void
		{
			this.visible = false;
		}
		
		//implement/////////////////////////////////////////////////////////
		
		private var observers:Array;
		public function registObserver(o:Observer):void
		{
			if(!observers) observers = [];
			observers.push(o);
		}
		
		public function removeObserver(o:Observer):void
		{
			if(observers.indexOf(o) != -1)
			{
				observers.splice(observers.indexOf(o),1);
			}
		}
		
		public function noticeObserver(notice:Object = null):void
		{
			for each(var o:Observer in observers)
			{
				o.notice(notice);
			}
		}
	}
}