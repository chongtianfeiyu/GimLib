package core
{
	import caurina.transitions.Tweener;
	
	import gim.patterns.interfaces.Observer;
	
	import spark.components.Group;

	public class BaseView extends Group implements Observer
	{
		public var index:int;
		
		public function BaseView()
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
		
		public function notice(obj:Object = null):void
		{
//			trace(obj);
			(obj == this.index) ? show() : hide();
		}
	}
}