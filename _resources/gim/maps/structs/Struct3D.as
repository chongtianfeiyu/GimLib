package gim.maps.structs 
{
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import gim.gimA3D.GimPolygon;
	import gim.gimA3D.GimPolygon3D;
	import gim.maps.models.Model;
	/**
	 * ...
	 * @author Gamba
	 */
	public class Struct3D extends Object3D
	{
		public var spacePoints:Array;
		public var polygon:GimPolygon;
		public var polygon3D:GimPolygon3D;
		
		public function Struct3D() 
		{
			
		}
		
		protected function getSpacePoints(area:String):Array 
		{
			var spacePoints:Array = [];
			var pointArr:Array;
			pointArr = area.split("|");
			for each (var str:String in pointArr)
			{
				var arr:Array = str.split(",");
				spacePoints.push(new Point(arr[1], arr[2]));
			}
			return spacePoints;
		}
		
		public static function getStandardMaterial(color:uint = undefined):StandardMaterial
		{
			return new StandardMaterial(new BitmapTextureResource(new BitmapData(1, 1, false, color ? color : Math.random() * 0xffffff)), new BitmapTextureResource(new BitmapData(1, 1, false, 0x7F7Fff)));
		}
		
		public static function getTextureMaterial(bitmapData:BitmapData):TextureMaterial
		{
			var bitmapTextureResource:BitmapTextureResource = new BitmapTextureResource(bitmapData);
			var textureMaterial:TextureMaterial = new TextureMaterial(bitmapTextureResource);
			return textureMaterial;
		}
		
	}

}