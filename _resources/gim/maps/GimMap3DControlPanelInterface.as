package gim.maps
{
	public interface GimMap3DControlPanelInterface
	{
		function setMap(mapInstance:MapInterface):void;
		function setMapScaleLimits(curValue:Number,maxLimit:Number,minLimit:Number):void;
		function setMapFloorID(floorID:String):void;
		function setMapScale(value:Number):void;
		function setMapPlaceType(placeTypeID:String):void;
		function setMapMoveMode(isMoveMod:Boolean):void;
		function resetMap():void;
	}
}