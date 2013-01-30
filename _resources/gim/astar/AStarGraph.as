package gim.astar 
{
	/**
	 * ...
	 * @author Gamba
	 */
	public class AStarGraph 
	{
		public var nodes:Object;
		public var startNode:AStarNode;
		public var endNode:AStarNode;
		public function AStarGraph($nodes:Object) 
		{
			this.nodes = $nodes;
		}
		
	}

}