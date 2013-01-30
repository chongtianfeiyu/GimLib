package gim.maps.structs
{
	import alternativa.engine3d.core.Object3D;
	import gim.gimA3D.GimPolygon;
	import gim.gimA3D.GimPolygon3D;
	import gim.maps.models.ModelFloor;
	import gim.maps.models.ModelPlace;
	
	/**
	 * ...
	 * @author Gamba
	 */
	public class Floor extends Struct3D
	{
		public var model:ModelFloor;
		private var patios:Array;
		private var places:Array;
		public var nodes:Object;
		
		public function Floor($model:ModelFloor)
		{
			this.model = $model;
			this.spacePoints = getSpacePoints(model.area);
			this.patios = [];
			this.places = [];
			this.nodes = { };
		}
		
		public function init():void
		{
			this.polygon = new GimPolygon(spacePoints, patios);
			this.polygon3D = new GimPolygon3D(polygon, -4, true, getStandardMaterial(0xFFFFFF));
			this.addChild(polygon3D);
			for each(var place:Place in places)
			{
				this.addChild(place);
			}
		}
		
		public function addPatio(patioModel:ModelPlace):void
		{
			patios.push(getSpacePoints(patioModel.area));
		}
		
		public function addPlace(place:Place):void
		{
			places.push(place);
		}
		
	}

}