package gim.astar 
{
	import gim.tools.GimTools;
	/**
	 * ...
	 * @author Gamba
	 */
	public class GimAStar 
	{
		static private var _instance:GimAStar;
		static public function get instance():GimAStar 
		{
			if (!_instance) _instance = new GimAStar();
			return _instance;
		}
		
		public function GimAStar() 
		{
			
		}
		
		private var aStarGraph:AStarGraph;
		private var openList:Array;		//保存所有已生成但未考察的结点
		private var closeList:Array;	//保存已经访问过的结点
		public function findPath(startNodeID:String,endNodeID:String,nodes:Object):Array
		{
			//构建寻路图
			aStarGraph = new AStarGraph(nodes);
			aStarGraph.startNode = nodes[startNodeID];
			aStarGraph.endNode = nodes[endNodeID];
			
			openList = [];
			closeList = [];
			
			aStarGraph.startNode.g = 0;
			aStarGraph.startNode.h = getH(aStarGraph.startNode);
			aStarGraph.startNode.f = aStarGraph.startNode.g + aStarGraph.startNode.h;
			
			var foundNodes:Array = [];
			
			var node:AStarNode = aStarGraph.startNode;
			while (node != aStarGraph.endNode)
			{
				var startNodeArray:Array = node.relatedNodes;
				for each(var relatedNode:AStarNode in startNodeArray)
				{
					if (openList.indexOf(relatedNode) == -1 && closeList.indexOf(relatedNode) == -1)
					{
						relatedNode.parent = node;
						relatedNode.g = relatedNode.g + calculateDistance(relatedNode, node);
						relatedNode.h = getH(relatedNode);
						relatedNode.f = relatedNode.g + relatedNode.h;
						openList.push(relatedNode);
					}
				}
				closeList.push(node);
				if (openList.length == 0)
				{
					return [];
				}
				//得到f值最小的结点
				openList.sortOn("f", Array.NUMERIC);
				node = openList.shift();
			}
			
			node = aStarGraph.endNode;
			foundNodes.unshift(node);
			while (node != aStarGraph.startNode)
			{
				node = node.parent;
				foundNodes.unshift(node);
			}
			
			return foundNodes;
		}
		
		private function calculateDistance(origNode:AStarNode, aimNode:AStarNode):Number 
		{
			var numSquareA:Number = (origNode.x - aimNode.x) * (origNode.x - aimNode.x);
			var numSquareB:Number = (origNode.y - aimNode.y) * (origNode.y - aimNode.y);
			return Math.sqrt(numSquareA + numSquareB);
		}
		
		//十分重要的H函数,暂时为计算当前结点到寻路图中终点的距离,应当适应各种情况,比如方向等,以便得到最优H
		private function getH(node:AStarNode):Number
		{
			return calculateDistance(node, aStarGraph.endNode);
			//var dx:Number = node.x - aStarGraph.endNode.x;
			//var dy:Number = node.y - aStarGraph.endNode.y;
			//return Math.sqrt(dx * dx + dy * dy);
		}
		
	}

}