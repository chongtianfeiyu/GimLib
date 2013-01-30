package alternativa.engine3d.primitives
{
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.BoundBox;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.resources.Geometry;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	use namespace alternativa3d;
	
	/**
	 * ...
	 * @author Gamba
	 */
	public class Polygon extends Mesh
	{
		public function Polygon(spacePoints:Array, isTwoSide:Boolean = false, material:Material = null)
		{
			var indices:Vector.<uint> = new Vector.<uint>();
			var vertices:ByteArray = new ByteArray(); //顶点数组
			vertices.endian = Endian.LITTLE_ENDIAN;
			var offsetAdditionalData:Number = 28; //额外偏移
			
			var boundBoxMinX:Number = 0;
			var boundBoxMinY:Number = 0;
			var boundBoxMinZ:Number = 0;
			var boundBoxMaxX:Number = 0;
			var boundBoxMaxY:Number = 0;
			var boundBoxMaxZ:Number = 0;
			for each (var arr:Array in spacePoints)
			{
				//取出一个三维点
				var x:Number = arr[0];
				var y:Number = arr[1];
				var z:Number = arr[2];
				
				//计算boundBox边界
				if (x < boundBoxMinX) boundBoxMinX = x;
				if (y < boundBoxMinY) boundBoxMinY = y;
				if (z < boundBoxMinZ) boundBoxMinZ = z;
				if (x > boundBoxMaxX) boundBoxMaxX = x;
				if (y > boundBoxMaxY) boundBoxMaxY = y;
				if (z > boundBoxMaxZ) boundBoxMaxZ = z;
				
				//写入一个点
				vertices.writeFloat(x);
				vertices.writeFloat(y);
				vertices.writeFloat(z);
				vertices.writeFloat(0); //u,暂为0
				vertices.writeFloat(1); //v,暂为1,即一个三角形显示全部贴图
				vertices.length = vertices.position += offsetAdditionalData; //这里应该验证三个点和四个点是否同样处理
			}
			var lastPosition:uint = vertices.position;
			//遍历所有三角形
			var numTriangle:int = spacePoints.length - 2;
			for (var i:int = 0; i < numTriangle; i++)
			{
				createFace(indices, vertices, 0, i + 1, i + 2, 0, 0, 1, 1, 0, 0, -1,isTwoSide);
			}
			
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
			addSurface(material, 0, indices.length / 3);
			
			boundBox = new BoundBox();
			boundBox.minX = boundBoxMinX;
			boundBox.minY = boundBoxMinY;
			boundBox.minZ =	boundBoxMinZ;
			boundBox.maxX = boundBoxMaxX;
			boundBox.maxY = boundBoxMaxY;
			boundBox.maxZ = boundBoxMaxZ;
		}
		
		//建立一个三角形
		//a,b,c为三个顶点的index
		private function createFace(indices:Vector.<uint>, vertices:ByteArray, a:int, b:int, c:int, nx:Number, ny:Number, nz:Number, tx:Number, ty:Number, tz:Number, tw:Number, twoSide:Boolean):void
		{
			//放入三个顶点的顺序
			indices.push(a);
			indices.push(b);
			indices.push(c);
			//这里可以放入逆序实现两面
			if (twoSide)
			{
				indices.push(c);
				indices.push(b);
				indices.push(a);
			}
			
			vertices.position = a * 48 + 20;
			vertices.writeFloat(nx);
			vertices.writeFloat(ny);
			vertices.writeFloat(nz);
			vertices.writeFloat(tx);
			vertices.writeFloat(ty);
			vertices.writeFloat(tz);
			vertices.writeFloat(tw);
			vertices.position = b * 48 + 20;
			vertices.writeFloat(nx);
			vertices.writeFloat(ny);
			vertices.writeFloat(nz);
			vertices.writeFloat(tx);
			vertices.writeFloat(ty);
			vertices.writeFloat(tz);
			vertices.writeFloat(tw);
			vertices.position = c * 48 + 20;
			vertices.writeFloat(nx);
			vertices.writeFloat(ny);
			vertices.writeFloat(nz);
			vertices.writeFloat(tx);
			vertices.writeFloat(ty);
			vertices.writeFloat(tz);
			vertices.writeFloat(tw);
		}
	
	}

}