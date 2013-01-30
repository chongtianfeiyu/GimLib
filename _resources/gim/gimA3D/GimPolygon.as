package gim.gimA3D
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Gamba
	 */
	public class GimPolygon
	{
		public var points:Array; //这个多边形的有序顶点
		public var indices:Array = []; //组成这个多边形的三角形顶点在points中的index数组,三个index代表一个三角形,三个顶点为points[index]
		public var triangleNumber:int = 0; //三角形数目
		
		private var discardedPoints:Array = [];
		private var thePolyPoints:Array;
		
		public function GimPolygon($points:Array,$holes:Array = null)
		{
			points = setAntiClockWise($points.concat());
			thePolyPoints = points.concat();
			if ($holes)
			{
				//首先排序holes
				$holes = sortHoles($holes);
				
				for each(var hole:Array in $holes)
				{
					hole = setAntiClockWise(hole);
					hole = hole.reverse();
					if (hole && hole.length > 0) 
					{
						thePolyPoints = combinePoints(thePolyPoints, hole);
						points = thePolyPoints.concat();
					}
				}
			}
			calculateTriangles();
		}
		
		private function sortHoles($holes:Array):Array 
		{
			var tmpHoles:Array = [];
			var tmpPont:Point;
			for each(var hole:Array in $holes)
			{
				var maxYPoint:Point = getMaxYPoint(hole);
				if (!tmpPont)
				{
					tmpPont = maxYPoint;
					tmpHoles.push(hole);
				}
				else if(maxYPoint.x * maxYPoint.y > tmpPont.x * tmpPont.y)
				{
					tmpHoles.push(hole);
				}
				else
				{
					tmpHoles.unshift(hole);
				}
			}
			return tmpHoles;
		}
		
		private function combinePoints($points:Array, $hole:Array):Array 
		{
			var combinedPoints:Array;
			
			//找到桥边
			var tmpObj:Object = { };
			tmpObj["minDistance"] = null;
			for each(var pointPolygon:Point in $points)
			{
				for each(var pointHole:Point in $hole)
				{
					var dis:Number = Math.sqrt((pointPolygon.x - pointHole.x) * (pointPolygon.x - pointHole.x) + (pointPolygon.y - pointHole.y) * (pointPolygon.y - pointHole.y));
					if (tmpObj["minDistance"])
					{
						if ( tmpObj["minDistance"] > dis )
						{
							tmpObj["minDistance"] = dis;
							tmpObj["bridgeEdge"] = [pointPolygon, pointHole];
						}
					}
					else
					{
						tmpObj["minDistance"] = dis;
						tmpObj["bridgeEdge"] = [pointPolygon, pointHole];
					}
				}
			}
			
			pointPolygon = tmpObj["bridgeEdge"][0];
			pointHole = tmpObj["bridgeEdge"][1];
			
			combinedPoints = $points.slice(0, $points.indexOf(pointPolygon));
			//combinedPoints.push(new Point(pointPolygon.x,pointPolygon.y + 100));
			combinedPoints.push(pointPolygon);
			combinedPoints = combinedPoints.concat($hole.slice($hole.indexOf(pointHole)));
			combinedPoints = combinedPoints.concat($hole.slice(0, $hole.indexOf(pointHole)));
			combinedPoints.push(pointHole);
			combinedPoints = combinedPoints.concat($points.slice($points.indexOf(pointPolygon)));
			
			return combinedPoints;
		}
		
		private var products:Object = { };
		private function calculateTriangles():void
		{
			var length:int = thePolyPoints.length;
			if (length < 3)
			{
				return;
			}
			else if (length == 3)
			{
				addTriangle(thePolyPoints[0], thePolyPoints[1], thePolyPoints[2]);
				return;
			}
			
			var rebuildPolyPoints:Boolean = false;
			
			var p0:Point = thePolyPoints[0];
			var p1:Point = thePolyPoints[1];
			var p2:Point = thePolyPoints[2];
			var product:Number = vectorProduct(p0, p1, p2);
			
			if (product > 0) 
			{
				rebuildPolyPoints = true;
			}
			else if (product <= 0)
			{
				for each (var p:Point in thePolyPoints)
				{
					if (p != p0 && p != p1 && p != p2)
					{
						if (isInsideTrangle(p0, p1, p2, p))
						{
							rebuildPolyPoints = true;
							break;
						}
					}
				}
			}
			
			if (rebuildPolyPoints)
			{
				thePolyPoints.shift();
				thePolyPoints.push(p0);
				calculateTriangles();
			}
			else
			{
				addTriangle(p0, p1, p2);
				thePolyPoints.splice(thePolyPoints.indexOf(p1), 1);
				if (thePolyPoints.length >= 3)
				{
					calculateTriangles();
				}
			}
		}
		
		/**
		 * 找到数组的Y最大点,将最大点设置为数组起始点,以最大点使多边形顶点数组按逆时针方向排列
		 * */
		private function setAntiClockWise($points:Array):Array
		{
			var pMax:Point = getMaxYPoint($points);
			var maxIndex:int = $points.indexOf(pMax);
			
			if ($points.length > 2)
			{
				var p0:Point = $points[maxIndex == 0 ? $points.length - 1 : maxIndex - 1];
				var p1:Point = $points[maxIndex];
				var p2:Point = $points[(maxIndex + 1) % $points.length];
				
				var product:Number = vectorProduct(p0, p1, p2);
				if (product >= 0)
					$points = $points.reverse(); //product > 0,为顺时针
			}
			
			return $points;
		}
		
		private function getMaxYPoint($points:Array):Point
		{
			var pMax:Point = $points[0];
			for each (var p:Point in $points)
			{
				if (p.y > pMax.y)
				{
					pMax = p;
				}
				else if (p.y == pMax.y)
				{
					if (p.x > pMax.x)
						pMax = p;
				}
			}
			return pMax;
		}
		
		private function vectorProduct(p0:Point, p1:Point, p2:Point):Number
		{
			return (p2.x - p1.x) * (p0.y - p1.y) - (p0.x - p1.x) * (p2.y - p1.y); //角p2p1p0的大小,对于一个凸点,大于0则为顺时针,小于0则为逆时针
		}
		
		private function addTriangle(a:Point, b:Point, c:Point):void
		{
			this.indices.push(points.indexOf(a));
			this.indices.push(points.indexOf(b));
			this.indices.push(points.indexOf(c));
			this.triangleNumber++;
		}
		
		//掌握核心技术啊
		private function isInsideTrangle(A:Point, B:Point, C:Point, P:Point):Boolean
		{
			var planeAB:Number = vectorProduct(A, B, P);
			var planeBC:Number = vectorProduct(B, C, P);
			var planeCA:Number = vectorProduct(C, A, P);
			//var planeAB:Number = (A.x - P.x) * (B.y - P.y) - (B.x - P.x) * (A.y - P.y);
			//var planeBC:Number = (B.x - P.x) * (C.y - P.y) - (C.x - P.x) * (B.y - P.y);
			//var planeCA:Number = (C.x - P.x) * (A.y - P.y) - (A.x - P.x) * (C.y - P.y);
			return sign(planeAB) == sign(planeBC) && sign(planeBC) == sign(planeCA);
		}
		
		private function sign(n:Number):int
		{
			return Math.abs(n) / n;
		}
		
		/**
		 * 在输入的sprite中绘制出这个逻辑多边形
		 * @param sprite 绘制多边形的容器sprite
		 * */
		public function drawPolygon(sprite:Sprite):void
		{
			sprite.graphics.clear();
			sprite.graphics.lineStyle(4, 0x0099CC);
			sprite.graphics.moveTo(points[0].x, points[0].y);
			for (var i:int = 1; i < points.length; i++)
			{
				sprite.graphics.lineTo(points[i].x, points[i].y);
			}
			sprite.graphics.lineTo(points[0].x, points[0].y);
			
			sprite.graphics.lineStyle(1, 0xff0033);
			if (triangleNumber >= 1)
			{
				for (i = 0; i < triangleNumber; i++)
				{
					var A:Point = points[indices[i * 3]];
					var B:Point = points[indices[i * 3 + 1]];
					var C:Point = points[indices[i * 3 + 2]];
					sprite.graphics.moveTo(A.x, A.y);
					sprite.graphics.lineTo(B.x, B.y);
					sprite.graphics.lineTo(C.x, C.y);
					sprite.graphics.lineTo(A.x, A.y);
				}
			}
			
			sprite.graphics.endFill();
		}
	
	}

}