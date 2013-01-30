package gim.gimA3D 
{
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.BoundBox;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.resources.Geometry;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	use namespace alternativa3d;
	/**
	 * 输入一组有序2D点(Point),计算出组成多边形的三角形,然后组成多边形
	 * @author Gamba
	 */
	public class GimPolygon2D extends Mesh
	{
		public function GimPolygon2D(gimPolygon:GimPolygon, isTwoSide:Boolean = false, material:Material = null) 
		{
			var vertices:ByteArray = new ByteArray(); 			//有序顶点数据
			vertices.endian = Endian.LITTLE_ENDIAN;
			var indices:Vector.<uint> = new Vector.<uint>();	//其中的每三个索引组成一个三角形
			var offsetAdditionalData:Number = 28; 				//额外偏移
			
			//将每个点的数据写入vertices中
			for each (var p:Point in gimPolygon.points)
			{
				//取出一个三维点
				var x:Number = p.x;
				var y:Number = - p.y;		//y轴翻转
				var z:Number = 0;
				
				//计算boundBox边界
				setBoundBox(x, y, z);
				
				//写入一个点
				vertices.writeFloat(x);
				vertices.writeFloat(y);
				vertices.writeFloat(z);
				vertices.writeFloat(0); 	//u,暂为0
				vertices.writeFloat(1); 	//v,暂为1,即一个三角形显示全部贴图
				vertices.writeFloat(0);		//nx
				vertices.writeFloat(0);		//ny
				vertices.writeFloat(1);		//nz,面的光照矢量指向Z方向
				vertices.writeFloat(1);		//tx,不清楚作用,需研究
				vertices.writeFloat(0);		//ty,不清楚作用,需研究
				vertices.writeFloat(0);		//tz,不清楚作用,需研究
				vertices.writeFloat(-1);	//tw
			}
			
			//建立三角形
			var a:int;
			var b:int;
			var c:int;
			for (var i:int = 0; i < gimPolygon.triangleNumber; i++)
			{
				//写入一个三角形,即应填写按次序的三个顶点的index
				a = gimPolygon.indices[i * 3];
				b = gimPolygon.indices[i * 3 + 1];
				c = gimPolygon.indices[i * 3 + 2];
				
				indices.push(a);
				indices.push(b);
				indices.push(c);
				if (isTwoSide)		//逆序实现两面
				{
					indices.push(c);
					indices.push(b);
					indices.push(a);
				}
			}
			
			//建立图形
			geometry = new Geometry();
			geometry._indices = indices;
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
			
			geometry.addVertexStream(attributes);
			geometry._vertexStreams[0].data = vertices;
			geometry._numVertices = vertices.length / 48;
			
			//应用材质
			addSurface(material, 0, indices.length / 3);
			
			//建立边界
			boundBox = new BoundBox();
			boundBox.minX = boundBoxMinX;
			boundBox.minY = boundBoxMinY;
			boundBox.minZ =	boundBoxMinZ;
			boundBox.maxX = boundBoxMaxX;
			boundBox.maxY = boundBoxMaxY;
			boundBox.maxZ = boundBoxMaxZ;
		}
		
		private	var boundBoxMinX:Number = 0;
		private	var boundBoxMinY:Number = 0;
		private	var boundBoxMinZ:Number = 0;
		private	var boundBoxMaxX:Number = 0;
		private	var boundBoxMaxY:Number = 0;
		private	var boundBoxMaxZ:Number = 0;
		
		private function setBoundBox(x:Number, y:Number, z:Number):void 
		{
			if (x < boundBoxMinX) boundBoxMinX = x;
			if (y < boundBoxMinY) boundBoxMinY = y;
			if (z < boundBoxMinZ) boundBoxMinZ = z;
			if (x > boundBoxMaxX) boundBoxMaxX = x;
			if (y > boundBoxMaxY) boundBoxMaxY = y;
			if (z > boundBoxMaxZ) boundBoxMaxZ = z;
		}
		
	}

}