package gim.patterns.interfaces
{
	public interface Subject
	{
		function registObserver(o:Observer):void;
		function removeObserver(o:Observer):void;
		function noticeObserver(notice:Object = null):void;
	}
}