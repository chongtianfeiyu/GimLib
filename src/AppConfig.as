package
{
	import core.DataProvider;
	import core.WebServiceCommand;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import gim.fileSystem.GimFileSystemTools;
	import gim.parsers.GimXmlParser;
	
	import core.components.Debugger;
	import core.components.PreLoader;

	public class AppConfig
	{
		protected static var _instance:AppConfig;
		
		public static function get instance():AppConfig
		{
			if(!_instance) _instance = new AppConfig();
			return _instance;
		}
		
		////////////////////////////////////////////////////////////
		public function AppConfig()
		{
		}
		
		public function loadConfig(configURL:String,onConfigComplete:Function):void
		{
			log("Load Config...");
			
			_onConfigComplete = onConfigComplete;
			GimFileSystemTools.loadString(configURL,onConfigXMLLoad);
		}
		private var _onConfigComplete:Function;
		
		private function onConfigXMLLoad(event:Event):void
		{
			xmlConfig = new XML(event.currentTarget.data);
			configApp();
		}
		
		private function configApp():void
		{
			log("App Configurating...");
			
			title 					= xmlConfig.title;
			server 					= xmlConfig.server;
			asmx 					= xmlConfig.asmx;
			cache 					= xmlConfig.cache;
			update 					= xmlConfig.update;
			initializeDeviceNodeID 	= xmlConfig.initializeDeviceNodeID;
			defaultRotationX 		= Number(xmlConfig.defaultRotationX) * Math.PI / 180;
			defaultRotationZ 		= Number(xmlConfig.defaultRotationZ) * Math.PI / 180;
			cameraDistance 			= Number(xmlConfig.cameraDistance);
			maxCameraDistance		= Number(xmlConfig.maxCameraDistance);
			minCameraDistance		= Number(xmlConfig.minCameraDistance);
			minRotationX 			= Number(xmlConfig.minRotationX) * Math.PI / 180;
			maxRotationX 			= Number(xmlConfig.maxRotationX) * Math.PI / 180;
			placeBaseHeight 		= Number(xmlConfig.placeBaseHeight);
			placeFocusColor			= uint(xmlConfig.placeFocusColor);
			adWaitTime				= int(xmlConfig.adWaitTime);
			
			preLoader.title = title;
//			preLoader.loaderTitle.text = title;
			log("Set WebCommands...");
//			preLoader.info.text = ;
			
			webServiceCommands = {};
			webServiceCommands[WEB_SERVICE_COMMAND_LANGUAGE] 		= new WebServiceCommand(WEB_SERVICE_COMMAND_LANGUAGE,"getLanguageList?");
			webServiceCommands[WEB_SERVICE_COMMAND_PLACETYPE] 		= new WebServiceCommand(WEB_SERVICE_COMMAND_PLACETYPE,"getPlaceType?");
			webServiceCommands[WEB_SERVICE_COMMAND_HALLLIST] 		= new WebServiceCommand(WEB_SERVICE_COMMAND_HALLLIST,"getHallList?");
			webServiceCommands[WEB_SERVICE_COMMAND_FLOORLIST] 		= new WebServiceCommand(WEB_SERVICE_COMMAND_FLOORLIST,"getFloorList?");
			webServiceCommands[WEB_SERVICE_COMMAND_PLACELIST]		= new WebServiceCommand(WEB_SERVICE_COMMAND_PLACELIST,"getPlaceList?");
			webServiceCommands[WEB_SERVICE_COMMAND_POINTLIST]		= new WebServiceCommand(WEB_SERVICE_COMMAND_POINTLIST,"PointList?FloorID=");
			webServiceCommands[WEB_SERVICE_COMMAND_PATHLIST]		= new WebServiceCommand(WEB_SERVICE_COMMAND_PATHLIST,"PathList?");
			webServiceCommands[WEB_SERVICE_COMMAND_SHOPLIST]		= new WebServiceCommand(WEB_SERVICE_COMMAND_SHOPLIST,"getShopList?");
			webServiceCommands[WEB_SERVICE_COMMAND_CATEGORYLIST]	= new WebServiceCommand(WEB_SERVICE_COMMAND_CATEGORYLIST,"getCategoryList?parentID=");
			webServiceCommands[WEB_SERVICE_COMMAND_NEWSTYPE]		= new WebServiceCommand(WEB_SERVICE_COMMAND_NEWSTYPE,"getNewsType?");
			webServiceCommands[WEB_SERVICE_COMMAND_NEWSLIST]		= new WebServiceCommand(WEB_SERVICE_COMMAND_NEWSLIST,"getNewsList?");
			webServiceCommands[WEB_SERVICE_COMMAND_PARTLIST]		= new WebServiceCommand(WEB_SERVICE_COMMAND_PARTLIST,"getPartList?");
			webServiceCommands[WEB_SERVICE_COMMAND_ADLIST]			= new WebServiceCommand(WEB_SERVICE_COMMAND_ADLIST,"getAdList?");
			
			log("Config Complete...");
			_onConfigComplete();
		}
		
		public function log(str:String):void
		{
			trace(str);
			if(preLoader.visible)
				preLoader.info.text = str;
			if(Debugger.getInstance().visible)
				Debugger.getInstance().print(str);
		}
		////////////////////////////////////////////////////////////
		public var webServiceCommands:Object;
		
		public static const WEB_SERVICE_COMMAND_LANGUAGE:String 		= "Language";
		public static const WEB_SERVICE_COMMAND_PLACETYPE:String 		= "PlaceType";
		public static const WEB_SERVICE_COMMAND_HALLLIST:String 		= "HallList";
		public static const WEB_SERVICE_COMMAND_FLOORLIST:String 		= "FloorList";
		public static const WEB_SERVICE_COMMAND_PLACELIST:String		= "PlaceList";
		public static const WEB_SERVICE_COMMAND_POINTLIST:String		= "PointList";
		public static const WEB_SERVICE_COMMAND_PATHLIST:String			= "PathList";
		public static const WEB_SERVICE_COMMAND_SHOPLIST:String			= "ShopList";
		public static const WEB_SERVICE_COMMAND_CATEGORYLIST:String		= "CategoryList";
		public static const WEB_SERVICE_COMMAND_NEWSTYPE:String			= "NewsType";
		public static const WEB_SERVICE_COMMAND_NEWSLIST:String			= "NewsList";
		public static const WEB_SERVICE_COMMAND_PARTLIST:String			= "PartList";
		public static const WEB_SERVICE_COMMAND_ADLIST:String			= "adList";
		
		////////////////////////////////////////////////////////////
		public var xmlConfig:XML;
		public var title:String;
		public var server:String;
		public var asmx:String;
		public var cache:String;
		public var update:String;
		public var currentLanguageID:String = "1";
		
		public var preLoader:PreLoader;
		public var dataProvider:DataProvider;
		public var initializeDeviceNodeID:String;
		public var placeFocusColor:uint;
		public var defaultRotationX:Number;
		public var defaultRotationZ:Number;
		public var cameraDistance:Number;
		public var maxCameraDistance:Number;
		public var minCameraDistance:Number;
		public var minRotationX:Number;
		public var maxRotationX:Number;
		public var placeBaseHeight:Number;
		public var backgroundUrl:String = "main/assist/imgs/background.png";
		[Bindable] public var adWaitTime:int;
	}
}