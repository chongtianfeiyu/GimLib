package gim.gimA3D
{
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.BoundBox;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.resources.Geometry;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	use namespace alternativa3d;
	
	/**
	 * ...
	 * @author Gamba
	 */
	public class GimPolygon3D extends Mesh
	{
		public var centerPoint:Point;
		public var _height:Number;
		public function GimPolygon3D(gimPolygon:GimPolygon,height:Number = 20,isTwoSide:Boolean = false,material:Material = null)
		{
			centerPoint = calculateCenterPoint(gimPolygon.points);
			_height = height;
			
			var indices:Vector.<uint> = new Vector.<uint>(); //顶点索引
			var vertices:ByteArray = new ByteArray(); //顶点数组
			vertices.endian = Endian.LITTLE_ENDIAN;
			
			//根据spacePoints构建出底面,顶面和边面的顶点数组////////////////////////////////////////
			var bottomPointArr:Array = []; //底面
			var topPointArr:Array = []; //顶面
			var sidePointArr:Array = []; //边面
			for each (var p:Point in gimPolygon.points)
			{
				var vb:Vector3D = new Vector3D(p.x, - p.y, 0, 0); //y轴翻转
				bottomPointArr.push(vb);
				var vt:Vector3D = new Vector3D(p.x, - p.y, height, 0);
				topPointArr.push(vt);
				//每一个顶点,在其相邻的两个边面上,有三个下顶点,三个上顶点
				sidePointArr.push(vb); //正向边面,第一三角形第一点
				sidePointArr.push(vb); //正向边面,第二三角形第一点
				sidePointArr.push(vb); //逆向边面,第一三角形第二点
				sidePointArr.push(vt); //正向边面,第二三角形第三点
				sidePointArr.push(vt); //逆向边面,第一三角形第三点
				sidePointArr.push(vt); //逆向边面,第二三角形第二点
			}
			
			//写入顶点数据////////////////////////////////////////////////////////////////////////
			var allPointArray:Array = bottomPointArr.concat(topPointArr.concat(sidePointArr)); //底面,顶面,边面的所有点数组
			//vertices 顶点,每48字节为一个顶点,索引为顶点在vertices中的索引
			for (i = 0; i < allPointArray.length; i++)
			{
				//写入一个点
				var v:Vector3D = allPointArray[i];
				vertices.writeFloat(v.x);
				vertices.writeFloat(v.y);
				vertices.writeFloat(v.z);
				vertices.writeFloat(0); //u,暂为0
				vertices.writeFloat(1); //v,暂为1,即一个三角形显示全部贴图
				vertices.writeFloat(0); //nx
				vertices.writeFloat(0); //ny
				vertices.writeFloat(1); //nz
				vertices.writeFloat(-1);
				vertices.writeFloat(0);
				vertices.writeFloat(0);
				vertices.writeFloat(-1);
				
				setBoundBox(v.x, v.y, v.z); //顺便设置boundBox大小
			}
			
			//写入索引/////////////////////////////////////////////////////////////////////////////
			//放入底面的indices
			var indicesLength:int = gimPolygon.indices.length;
			var index:int;
			var i:int;
			for (i = 0; i < indicesLength; i++)
			{
				index = gimPolygon.indices[i];
				indices.push(index);
			}
			
			//放入顶面的indices
			//for (i = 0; i < indicesLength; i++)
			//{
				//index = gimPolygon.indices[i] + bottomPointArr.length; //这里每个index加上底面点个数,即为顶面index
				//indices.push(index);
			//}
			
			for (i = 0; i < gimPolygon.triangleNumber; i ++)
			{
				var a:int = gimPolygon.indices[i * 3] + bottomPointArr.length; 
				var b:int = gimPolygon.indices[i * 3 + 1] + bottomPointArr.length; 
				var c:int = gimPolygon.indices[i * 3 + 2] + bottomPointArr.length; 
				
				indices.push(a);
				indices.push(b);
				indices.push(c);
				if (isTwoSide)
				{
					indices.push(c);
					indices.push(b);
					indices.push(a);
				}
			}
			
			//放入边面的indices
			var length:int = bottomPointArr.length + topPointArr.length; //边面顶点数组前面顶点个数
			var sidePointLength:int = sidePointArr.length; //边面顶点个数
			var sideNumber:int = sidePointLength / 6; //边面矩形个数,每个矩形由6个顶点组成的两个三角形组成
			var sideVectorIndicesArray:Array = [];
			for (i = 0; i < sideNumber; i++) //一次性放入六个索引,分别为三个相等的底顶点的索引和三个相等的顶顶点的索引
			{
				var index_0:int;
				var index_1:int;
				var index_2:int;
				var index_3:int;
				var index_4:int;
				var index_5:int;
				if (i == 0)
				{
					index_0 = i * 6 + length;
					index_1 = i * 6 + 3 + length;
					index_2 = (sideNumber - 1) * 6 + 1 + length;
					index_3 = (sideNumber - 1) * 6 + 4 + length;
					index_4 = (sideNumber - 1) * 6 + 2 + length;
					index_5 = i * 6 + 5 + length;
				}
				else
				{
					index_0 = i * 6 + length;
					index_1 = i * 6 + 3 + length;
					index_2 = (i - 1) * 6 + 1 + length;
					index_3 = (i - 1) * 6 + 4 + length;
					index_4 = (i - 1) * 6 + 2 + length;
					index_5 = i * 6 + 5 + length;
				}
				
				sideVectorIndicesArray.push(index_0);
				sideVectorIndicesArray.push(index_1);
				sideVectorIndicesArray.push(index_2);
				sideVectorIndicesArray.push(index_3);
				sideVectorIndicesArray.push(index_4);
				sideVectorIndicesArray.push(index_5);
				
				if (isTwoSide)
				{
					sideVectorIndicesArray.push(index_5);
					sideVectorIndicesArray.push(index_4);
					sideVectorIndicesArray.push(index_3);
					sideVectorIndicesArray.push(index_2);
					sideVectorIndicesArray.push(index_1);
					sideVectorIndicesArray.push(index_0);
				}
				
				//这里设置光线向量,首先取得两个顶点
				var vStartIndex:int = index_0;
				var vEndIndex:int = index_2;
				var vStart:Vector3D = allPointArray[vStartIndex];
				var vEnd:Vector3D = allPointArray[vEndIndex];
				
				//相对于中线点的坐标
				//var sx:Number = vStart.x - centerPoint.x;
				//var sy:Number = vStart.y - centerPoint.y;
				//var ex:Number = vEnd.x - centerPoint.x;
				//var ey:Number = vEnd.y - centerPoint.y;
				//计算出两个点的中点坐标
				//var cx:Number = (sx + ex) / 2 * 0.01;
				//var cy:Number = (sy + ey) / 2 * 0.01;
				//缩放到[-1,1]区间
				
				//向量(cx,cy)指向哪里?
				//得到夹角
				var angle:Number = Math.atan2(vEnd.y - vStart.y, vEnd.x - vStart.x);
				var cx:Number  = Math.cos(angle + Math.PI / 2);
				var cy:Number = Math.sin(angle + Math.PI / 2);
				
				//写入光线向量,六个顶点的光线向量是一样的
				vertices.position = index_0 * 48 + 20;
				vertices.writeFloat(cx);
				vertices.writeFloat(cy);
				vertices.position = index_1 * 48 + 20;
				vertices.writeFloat(cx);
				vertices.writeFloat(cy);
				vertices.position = index_2 * 48 + 20;
				vertices.writeFloat(cx);
				vertices.writeFloat(cy);
				vertices.position = index_3 * 48 + 20;
				vertices.writeFloat(cx);
				vertices.writeFloat(cy);
				vertices.position = index_4 * 48 + 20;
				vertices.writeFloat(cx);
				vertices.writeFloat(cy);
				vertices.position = index_5 * 48 + 20;
				vertices.writeFloat(cx);
				vertices.writeFloat(cy);
			}
			
			for (i = 0; i < sideVectorIndicesArray.length; i++)
			{
				index = sideVectorIndicesArray[i];
				indices.push(index);
			}
			
			//构造图形//////////////////////////////////////////////////////////////////////
			var attributes:Array = [];
			attributes[0] = VertexAttributes.POSITION;
			attributes[1] = VertexAttributes.POSITION;
			attributes[2] = VertexAttributes.POSITION;
			attributes[3] = VertexAttributes.TEXCOORDS[0];
			attributes[4] = VertexAttributes.TEXCOORDS[0];
			attributes[5] = VertexAttributes.NORMAL;
			attributes[6] = VertexAttributes.NORMAL;
			attributes[7] = VertexAttributes.NORMAL;
			attributes[8] = VertexAttributes.TANGENT4;
			attributes[9] = VertexAttributes.TANGENT4;
			attributes[10] = VertexAttributes.TANGENT4;
			attributes[11] = VertexAttributes.TANGENT4;
			
			geometry = new Geometry();
			geometry._indices = indices;
			geometry.addVertexStream(attributes);
			geometry._vertexStreams[0].data = vertices;
			geometry._numVertices = vertices.length / 48;
			addSurface(material, 0, indices.length / 3);
			
			boundBox = new BoundBox();
			boundBox.minX = boundBoxMinX;
			boundBox.minY = boundBoxMinY;
			boundBox.minZ = boundBoxMinZ;
			boundBox.maxX = boundBoxMaxX;
			boundBox.maxY = boundBoxMaxY;
			boundBox.maxZ = boundBoxMaxZ;
		}
		
		private var boundBoxMinX:Number = 0;
		private var boundBoxMinY:Number = 0;
		private var boundBoxMinZ:Number = 0;
		private var boundBoxMaxX:Number = 0;
		private var boundBoxMaxY:Number = 0;
		private var boundBoxMaxZ:Number = 0;
		
		private function setBoundBox(x:Number, y:Number, z:Number):void
		{
			if (x < boundBoxMinX)
				boundBoxMinX = x;
			if (y < boundBoxMinY)
				boundBoxMinY = y;
			if (z < boundBoxMinZ)
				boundBoxMinZ = z;
			if (x > boundBoxMaxX)
				boundBoxMaxX = x;
			if (y > boundBoxMaxY)
				boundBoxMaxY = y;
			if (z > boundBoxMaxZ)
				boundBoxMaxZ = z;
		}
		
		private function calculateCenterPoint(points:Array):Point 
		{
			//几何中心算法
			//var allX:Number = 0;
			//var allY:Number = 0;
			//for each(var p:Point in points)
			//{
				//allX += p.x;
				//allY += p.y;
			//}
			//return new Point(allX / points.length, allY / points.length);
			
			//EMap3D算法
			var len:int = points.length;
			if (len<=2) return new Point();
			var len_1:int = len - 1, loc:Point = points[0];
			
			var __minX:Number, __maxX:Number, __minY:Number, __maxY:Number;
			
			var sumX:Number = 0;
			var sumY:Number = 0;
			__minX = __maxX = loc.x;
			__minY = __maxY = loc.y;
			for (var i:int=0;i<len;i++) {
				loc = points[i];
				sumX+=loc.x;
				sumY+=loc.y;
				if (loc.x<__minX) __minX = loc.x;
				if (loc.x>__maxX) __maxX = loc.x;
				if (loc.y<__minY) __minY = loc.y;
				if (loc.y>__maxY) __maxY = loc.y;
			}
			return new Point(((__maxX + __minX) * .5 + sumX / len) * .5,((__minY + __maxY) * .5 + sumY / len) * .5);
		}
	
	}

}