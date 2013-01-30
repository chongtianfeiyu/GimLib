package gim.maps.models
{
	import gim.astar.AStarNode;
	
	/**
	 * ...
	 * @author Gamba
	 */
	public class ModelNode extends Model implements AStarNode
	{
		/*
		 *<point id="1">
		   <x>1932.55</x>
		   <y>916.4</y>
		   <nodeID>2012-12-05_16:05:55_1096_7436</nodeID>
		   <floorID>3</floorID>
		   </point>
		 * */
		
		public var id:String;
		public var floorID:String;
		private var _x:Number;
		private var _y:Number;
		private var _nodeID:String;
		private var _h:Number;
		private var _g:Number;
		private var _f:Number;
		private var _relatedNodes:Array;
		private var _parentNode:AStarNode;
		
		public function ModelNode(xml:XML)
		{
			this.id = xml.@id;
			this.x = Number(xml.x);
			this.y = Number(xml.y);
			this.nodeID = xml.nodeID;
			this.floorID = xml.floorID;
			this.relatedNodes = [];
		}
		
		public function get nodeID():String
		{
			return _nodeID;
		}
		
		public function set nodeID(value:String):void
		{
			_nodeID = value;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function get g():Number
		{
			return _g;
		}
		
		public function set g(value:Number):void
		{
			_g = value;
		}
		
		public function get h():Number
		{
			return _h;
		}
		
		public function set h(value:Number):void
		{
			_h = value;
		}
		
		public function get f():Number
		{
			return _f;
		}
		
		public function set f(value:Number):void
		{
			_f = value;
		}
		
		public function addRelatedNodes(value:AStarNode):void
		{
			if (_relatedNodes.indexOf(value) == -1 && value != this)
			{
				_relatedNodes.push(value);
			}
		}
		
		public function get relatedNodes():Array
		{
			return _relatedNodes;
		}
		
		public function set relatedNodes(value:Array):void
		{
			_relatedNodes = value;
		}
		
		public function set parent(node:AStarNode):void
		{
			_parentNode = node;
		}
		
		public function get parent():AStarNode
		{
			return _parentNode;
		}
	}

}