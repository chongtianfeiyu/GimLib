package gim.astar 
{
	
	/**
	 * ...
	 * @author Gamba
	 */
	public interface AStarNode 
	{
		function get nodeID():String;
		
		function get x():Number;
		function get y():Number;
		
		function get g():Number;
		function set g(value:Number):void;
		function get h():Number;
		function set h(value:Number):void;
		function get f():Number;
		function set f(value:Number):void;
		
		function addRelatedNodes(value:AStarNode):void
		function get relatedNodes():Array;
		function set parent(node:AStarNode):void;
		function get parent():AStarNode;
	}
	
}