package gim.maps
{
	import caurina.transitions.Tweener;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import gim.astar.GimAStar;
	import gim.maps.structs.Floor;
	import gim.maps.structs.Place;
	
	/**
	 * ...
	 * @author Gamba
	 */
	public class Map extends Sprite implements MapInterface
	{
		public function Map()
		{
			
		}
		
		///////////////////////////////////////////////////
		//Map data	地图数据
		///////////////////////////////////////////////////
		public var server:String = "";
		public var _xmlFloorList:XML;
		public var _xmlPlaceList:XML;
		public var _xmlPointList:XML;
		public var _xmlPathList:XML;
		public var _xmlShopList:XML;
		public var _xmlPlaceType:XML;
		
		public var floors:Object;
		public var nodes:Object;
		public var pathes:Object;
		public var shops:Object;
		public var placeTypes:Object;
		public var places:Object;
		
		public var _backgroundUrl:String;
		public var _mapWidth:Number;
		public var _mapHeight:Number;
		public var _onMapCreateCompleteFunc:Function;
		private var _onFloorChangeFunction:Function;
		private var _onPlaceClickFunction:Function;
		private var _currentMapScale:Number;
		private var _currentMapPosition:Point;
		private var _currentFloorID:String;
		private var _currentDiviceNodeID:String;
		private var _currentSelectedNodeID:String;
		public var currentDivicePlace:Place;
		
		///////////////////////////////////////////////////
		//Setters	数据准备
		///////////////////////////////////////////////////
		public function set xmlFloorList(xml:XML):void
		{
			this._xmlFloorList = xml;
		}
		
		public function set xmlPlaceList(xml:XML):void
		{
			this._xmlPlaceList = xml;
		}
		
		public function set xmlPointList(xml:XML):void
		{
			this._xmlPointList = xml;
		}
		
		public function set xmlPathList(xml:XML):void
		{
			this._xmlPathList = xml;
		}
		
		public function set xmlPlaceType(xml:XML):void
		{
			this._xmlPlaceType = xml;
		}
		
		public function set xmlShopList(xml:XML):void
		{
			this._xmlShopList = xml;
		}
		
		public function get currentDiviceNodeID():String
		{
			return this._currentDiviceNodeID;
		}
		
		public function set currentDiviceNodeID(value:String):void
		{
			this._currentDiviceNodeID = value;
		}
		
		public function set currentSelectedNodeID(value:String):void
		{
			this._currentSelectedNodeID = value;
		}
		
		public function get currentSelectedNodeID():String
		{
			return this._currentSelectedNodeID;
		}
		
		public function set backgroundUrl(value:String):void
		{
			this._backgroundUrl = value;
		}
		
		public function get backgroundUrl():String
		{
			return _backgroundUrl;
		}
		
		public function setMapSize(width:Number, height:Number):void
		{
			this._mapWidth = width;
			this._mapHeight = height;
		}
		
		///////////////////////////////////////////////////
		//Map initialize function	地图初始化
		///////////////////////////////////////////////////
		
		/**
		 * 初始化地图,完毕后调用onMapCreateComplete
		 * @param onMapCreateComplete 地图构建完毕后调用此函数
		 * */
		public function init(onMapCreateComplete:Function):void
		{
			this._onMapCreateCompleteFunc = onMapCreateComplete;
			if (!checkData())
				return;
				
			floors = { };
			nodes = { };
			pathes = { };
			shops = { };
			placeTypes = { };
			places = { };
		}
		
		public function checkData():Boolean
		{
			if (_xmlFloorList && _xmlPlaceList && _xmlPointList && _xmlPathList && _xmlPlaceType && _xmlShopList && _currentDiviceNodeID && _backgroundUrl && _mapWidth && _mapHeight)
			{
				trace("All Map Data Ready.");
				return true;
			}
			else
			{
				trace("Map Data Not Ready.");
				if (!_xmlFloorList)
					trace("xmlFloorList Not Set");
				if (!_xmlPlaceList)
					trace("xmlPlaceList Not Set");
				if (!_xmlPointList)
					trace("xmlPointList Not Set");
				if (!_xmlPathList)
					trace("xmlPathList Not Set");
				if (!_xmlShopList)
					trace("xmlShopList Not Set");
				if (!_xmlPlaceType)
					trace("xmlPlaceType Not Set");
				if (!_currentDiviceNodeID)
					trace("currentPlaceID Not Set");
				if (!_backgroundUrl)
					trace("backgroundUrl Not Set");
				if (!_mapWidth || !_mapHeight)
					trace("mapSize Not Set");
				return false;
			}
		}
		
		///////////////////////////////////////////////////
		//Operate functions	操作函数
		///////////////////////////////////////////////////
		//地图重置到当前点所在楼层,并锁定当前点
		public function reset():void
		{
		}
		
		//闪烁相应placeType
		public function set placeTypeID(value:String):void
		{
		}
		
		//切换到相应楼层
		public function set floorID(value:String):void
		{
			if (value == floorID) return;
			
			hideAllFloors();
			var floor:Floor = floors[value];
			if (floor)
			{
				floor.visible = true;
				floor.z = 300;
				Tweener.removeTweens(floor);
				Tweener.addTween(floor, {z: 0, time: 2});
				
				_currentFloorID = value;
			}
			
			hidePath();
			if(_onFloorChangeFunction != null)
				this._onFloorChangeFunction(floorID);
		}
		
		public function hideAllFloors():void
		{
			for each(var floor:Floor in floors)
			{
				Tweener.removeTweens(floor);
				floor.visible = false;
				floor.z = 0;
			}
		}
		
		public function get floorID():String
		{
			return _currentFloorID;
		}
		
		//移动地图到指定点
		public function set mapPosition(point:Point):void
		{
			_currentMapPosition = point;
		}
		
		public function get mapPosition():Point
		{
			return _currentMapPosition;
		}
		
		//设置地图缩放
		public function set mapScale(value:Number):void
		{
		}
		
		public function get mapScale():Number
		{
			return _currentMapScale;
		}
		
		//寻路到指定地点
		public function findPath(startNodeID:String,endNodeID:String,$nodes:Object = null):void
		{
			foundPathNodes = null;
			foundPathNodes = GimAStar.instance.findPath(startNodeID,endNodeID,$nodes ? $nodes : nodes);
		}
		protected var foundPathNodes:Array;
		
		public function showPath(foundPathNodes:Array):void
		{
			hidePath();
		}
		
		public function hidePath():void
		{
			
		}
		
		//点击地点
		public function onPlaceClick(placeNodeID:String):void
		{
			if(_onPlaceClickFunction != null)
				this._onPlaceClickFunction(placeNodeID);
		}
		
		/**
		 * 回调函数的参数为placeID,callbackFunction(placeID:String):void;
		 * */
		public function regFuncPlaceClick(onPlaceClickFunction:Function):void
		{
			this._onPlaceClickFunction = onPlaceClickFunction;
		}
		
		/**
		 * 回调函数的参数为floorID,callbackFunction(floorID:String):void;
		 * */
		public function regFuncFloorChange(onFloorChangeFunction:Function):void
		{
			this._onFloorChangeFunction = onFloorChangeFunction;
		}
		
		///////////////////////////////////////////////////
		//DEBUG functions	调试函数
		///////////////////////////////////////////////////
		
		//回调函数的参数为info,func(info:String):void{}
		public function regFuncMapDebug(func:Function):void
		{
		}
	
	}

}