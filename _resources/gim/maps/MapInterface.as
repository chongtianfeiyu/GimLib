package gim.maps 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Gamba
	 */
	public interface MapInterface 
	{
		////////////////////////////////////////////////////
		//设置地图数据
		////////////////////////////////////////////////////
		function set xmlFloorList(xml:XML):void;
		function set xmlPlaceList(xml:XML):void;
		function set xmlPointList(xml:XML):void;
		function set xmlPathList(xml:XML):void;
		function set xmlShopList(xml:XML):void;
		function set backgroundUrl(value:String):void;
		function setMapSize(width:Number, height:Number):void;
		//寻路系统
		function set currentDiviceNodeID(value:String):void;
		function get currentDiviceNodeID():String;
		function set currentSelectedNodeID(value:String):void;
		function get currentSelectedNodeID():String;
		////////////////////////////////////////////////////
		//地图初始化
		////////////////////////////////////////////////////
		function init(onMapCreateComplete:Function):void;				//初始化地图,地图构建完成后执行无参数回调函数
		
		function reset():void;											//地图重置到当前点所在楼层,并锁定当前点
		function set placeTypeID(value:String):void;					//闪烁相应placeType
		
		function set floorID(value:String):void;						//切换到相应楼层
		function get floorID():String;									//返回当前楼层id
		
		function set mapPosition(point:Point):void;						//移动地图到指定点
		function get mapPosition():Point;								//返回地图位置
		
		function set mapScale(value:Number):void;						//设置地图缩放值
		function get mapScale():Number;									//返回地图缩放值
		
		function findPath(startNodeID:String, endNodeID:String,nodes:Object = null):void;	//寻路到指定地点,包括跨层寻路
		function showPath(foundPathNodes:Array):void;
		function hidePath():void;
		
		//function onPlaceClick(placeID:String):void;					//点击地点
		//function onFloorChange(floorID:String):void;					//切换楼层
		
		//以下是否改成事件方式返回
		function regFuncFloorChange(callbackFunction:Function):void;	//回调函数的参数为floorID,callbackFunction(floorID:String):void;
		function regFuncPlaceClick(callbackFunction:Function):void;		//回调函数的参数为placeID,callbackFunction(placeID:String):void;
		function regFuncMapDebug(callbackFunction:Function):void;		//回调函数的参数为info,func(info:String):void;
	}
	
}