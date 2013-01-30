package core
{
	import core.structs.*;
	
	import gim.fileSystem.GimFileSystemTools;
	import gim.parsers.GimXmlParser;
	
	public class DataProvider
	{
		//data
		public var XMLs:Object;
		public var ObjPlaceType:Object;
		public var ObjShops:Object;
		public var ObjPlaces:Object;
		public var ObjCategories:Object;
		public var ObjFloors:Object;
		public var ObjParts:Object;
		public var ObjNewsTypes:Object;
		public var ObjNewsList:Object;
		public var ObjLanguages:Object;
		public var ObjAds:Object;
		
		public var adUrls:Array = [];
		public var adLogos:Array = [];
		
		public function DataProvider()
		{
			_config = AppConfig.instance;
		}
		private var _config:AppConfig;
		
		public function init(onInitComplete:Function):void
		{
			_onInitComplete = onInitComplete;
			
			var xmlPathes:Array = [];
			for each(var cmd:WebServiceCommand in _config.webServiceCommands)
			{
				var path:String = _config.cache + "xmls/" + cmd.localFilePath;
				xmlPathes.push(path);
			}
			
			GimFileSystemTools.loadStringsLinear(xmlPathes,onXmlsLoaded);
		}
		private var _onInitComplete:Function;
		
		private function onXmlsLoaded(obj:Object):void
		{
			XMLs = {};
			for each(var cmd:WebServiceCommand in _config.webServiceCommands)
			{
				var path:String = _config.cache + "xmls/" + cmd.localFilePath;
				XMLs[cmd.commandName] = new XML(obj[path]);
			}
			
//			var url:String = _config.cache + ad.sourceURL;
//			url = url.replace("//","/");
//			adUrls.push(url);
//			floorImgs.push(_config.cache + floor.image);
//			newsPaperImages.push(_config.cache + newsPaper.image);
//			if(news.image) newsImages.push(_config.cache + news.image);
			
			ObjFloors 		= getObjs(XMLs[AppConfig.WEB_SERVICE_COMMAND_FLOORLIST],Floor);
			ObjCategories 	= getObjs(XMLs[AppConfig.WEB_SERVICE_COMMAND_CATEGORYLIST],Category);
			ObjParts 		= getObjs(XMLs[AppConfig.WEB_SERVICE_COMMAND_PARTLIST],Part);
			ObjNewsTypes 	= getObjs(XMLs[AppConfig.WEB_SERVICE_COMMAND_NEWSTYPE],NewsType);
			ObjLanguages 	= getObjs(XMLs[AppConfig.WEB_SERVICE_COMMAND_LANGUAGE],Language);
			
			var newsFunc:Function = function(obj:Object):void
			{
				if(ObjNewsTypes[obj.newsTypeID])
					ObjNewsTypes[obj.newsTypeID].subNews.push(obj);
			}
			ObjNewsList 	= getObjs(XMLs[AppConfig.WEB_SERVICE_COMMAND_NEWSLIST],News,newsFunc);
			
			var placeTypeFunc:Function = function(placeType:Object):void
			{
				//if(placeType.data == "shop") obj.shopTypeID = placeType.id;
			}
			ObjPlaceType 	= getObjs(XMLs[AppConfig.WEB_SERVICE_COMMAND_PLACETYPE],PlaceType,placeTypeFunc);//改变ObjNewsTypes
			
			var placeFunc:Function = function(place:Object):void
			{
				//设置place的placeTypeName
				if(ObjPlaceType[place.placeTypeID]) 
					place.placeTypeName = ObjPlaceType[place.placeTypeID].name;
			}
			ObjPlaces 		= getObjs(XMLs[AppConfig.WEB_SERVICE_COMMAND_PLACELIST],Place,placeFunc);	//要设置ObjPlaceType.shopTypeID
			
			var shopFunc:Function = function(shop:Object):void
			{
				//将dataProvider中的ObjPlace相对应的place中的shop设置为此shop
				if(ObjPlaces[shop.placeID])
				{
					ObjPlaces[shop.placeID].shop = shop;
					shop.place = ObjPlaces[shop.placeID] as Place;
				}
				//设置Categories中的subShops
				for each(var categoryID:String in shop.categories)
				{
					if(ObjCategories[categoryID])
						ObjCategories[categoryID].subShops.push(shop);
				}
			}
			ObjShops = getObjs(XMLs[AppConfig.WEB_SERVICE_COMMAND_SHOPLIST],Shop,shopFunc);	//要设置每一个place.placeTypeName
			
			var adFunc:Function = function(ad:Object):void
			{
				adUrls.push(_config.cache + ad.sourceURL);
				adLogos.push(_config.cache + ad.logoURL);
			}
			ObjAds = getObjs(XMLs[AppConfig.WEB_SERVICE_COMMAND_ADLIST],AD,adFunc);
			_onInitComplete();
		}
		
		/**
		 * 传入一个xml,解析为以传入的类的id属性为键值的类对象,并执行func函数的对象
		 * @param xml 待解析的XML对象,每个子对象当与类一一对应
		 * @param BaseStructClass 每个XML节点将要解析成的类对象
		 * @param func 执行以每个XML节点生成的对象为参数的函数,原型:function(obj:BaseStructClass):void;
		 * */
		private function getObjs(xml:XML,BaseStructClass:Class,func:Function = null):Object
		{
			var obj:Object = {};
			var length:Number = xml.children().length();
			for(var i:int = 0;i < length;i ++)
			{
				var subXml:XML = xml.children()[i];
				var baseClassObj:Object = new BaseStructClass(subXml);
				obj[baseClassObj.id] = baseClassObj;
				if(func != null) func(baseClassObj);
			}
			return obj;
		}
	}
}