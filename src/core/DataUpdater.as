package core
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import gim.fileSystem.GimFileSystemTools;
	import gim.parsers.GimXmlParser;
	
	public class DataUpdater
	{
		/**
		 * 函数loadAndSaveXMLs()更新所有xml
		 * 更新所有xml之后更新所有媒体资源,过滤swf,png,jpg,flv等资源文件,然后下载并保存到本地.
		 * */
		public function DataUpdater()
		{
			_config = AppConfig.instance;
		}
		private var _config:AppConfig;
		
		/**
		 * 先更新XMLs,再更新资源文件,更新完成后调用原型为func():void;的回调函数
		 * */
		public function update(onUpdateComplete:Function):void
		{
			AppConfig.instance.log("Application Updating...");
			_onUpdateComplete = onUpdateComplete;
			loadAndSaveXMLs();
		}
		private var _onUpdateComplete:Function;
		
		/**
		 * 下载和保存xmls
		 * */
		public function loadAndSaveXMLs():void
		{
			AppConfig.instance.log("XMLs Updating...");
			
			var webCommandUrls:Array = [];
			for each(var webServiceCommand:WebServiceCommand in _config.webServiceCommands)
			{
				var url:String = _config.asmx + webServiceCommand.commandStr;
				webCommandUrls.push(url);
			}
			GimFileSystemTools.loadStringsLinear(webCommandUrls,onXMLLoaded,onIOError);
		}
		
		/**
		 * 网络异常和报错的处理,直接调用完成函数进行本地构建,使用在函数loadAndSaveXMLs()和函数loadAndSaveResources()中
		 * */
		private function onIOError(e:IOErrorEvent):void
		{
			AppConfig.instance.log("Net connect failed! Initialize Application locally" + e.toString());
			_onUpdateComplete();
		}
		
		/**
		 * 保存所有的xml
		 * */
		private function onXMLLoaded(xmlStrings:Object):void
		{
			savedXMLsNumber = 0;
			XMLsNumber = 0;
			XMLs = {};
			for each(var webServiceCommand:WebServiceCommand in _config.webServiceCommands)
			{
				XMLsNumber ++;
				var url:String = _config.asmx + webServiceCommand.commandStr;
				var localPath:String = _config.cache + "xmls/" + webServiceCommand.localFilePath;
				XMLs[webServiceCommand.commandName] = new XML(xmlStrings[url]);
				GimFileSystemTools.saveFileTo(localPath,xmlStrings[url],onXMLSave);
			}
		}
		private var savedXMLsNumber:int;
		private var XMLsNumber:int;
		private var XMLs:Object;
		
		private function onXMLSave(event:Event):void
		{
			AppConfig.instance.log("XML Saving..." + (savedXMLsNumber + 1) + "/" + XMLsNumber);
			
			savedXMLsNumber ++;
			if(savedXMLsNumber >= XMLsNumber)
			{
				allXMLsSaved();
			}
		}
		
		/**
		 * 所有xml保存完毕
		 * */
		private function allXMLsSaved():void
		{
			sourcesPathes = [];
			for each(var xml:XML in XMLs)
			{
				//将xml中所有以".swf",".flv",".png",".jpg"结尾的结点解析到sourcesPathes中
				sourcesPathes = sourcesPathes.concat(GimXmlParser.parseByFileType(xml,[".swf",".flv",".png",".jpg"]));
				/* 需考察GimXmlParser.parseByFileType函数能不能递归xml的子结点,如果可以就可以省略掉一个循环,待做 */
			}
			
			//过滤sourcesPathes,本地文件存在则删除其中的url
			var tmpUrls:Array = [];
			for each(var url:String in sourcesPathes)
			{
				var localUrl:String = _config.cache + url;
				if(!GimFileSystemTools.isFileExists(localUrl))
					tmpUrls.push(url);
			}
			sourcesPathes = tmpUrls;

			resourceSavedNumber = 0;
			loadAndSaveResources();
		}
		private var resourceSavedNumber:int;
		private var sourcesPathes:Array;
		
		/**
		 * 下载和保存资源
		 * */
		private function loadAndSaveResources():void
		{
			if(sourcesPathes.length == 0) 
			{
				allResourceSaved();
				return;
			}
			else
			{
				var url:String = _config.server + sourcesPathes[resourceSavedNumber];
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE,onResourceLoad);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onDownloadIOError);
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				urlLoader.load(new URLRequest(url));
				
				AppConfig.instance.log("Src Updating..." + (resourceSavedNumber + 1) + "/" + sourcesPathes.length + " " + _config.server + sourcesPathes[resourceSavedNumber]);
			}
		}
		
		/**
		 * 下载失败就进行下一个
		 * */
		private function onDownloadIOError(error:IOErrorEvent):void
		{
			onResourceSave(null);
		}
		
		private function onResourceLoad(event:Event):void
		{
			var urlLoader:URLLoader = event.currentTarget as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE,onResourceLoad);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onDownloadIOError);
			var data:ByteArray = event.currentTarget.data;
			var path:String = _config.cache + sourcesPathes[resourceSavedNumber];
			GimFileSystemTools.saveFileTo(path,data,onResourceSave);
		}
		
		private function onResourceSave(event:Event):void
		{
			resourceSavedNumber ++;
			if(resourceSavedNumber < sourcesPathes.length)
			{
				loadAndSaveResources();
			}
			else
			{
				allResourceSaved();
			}
		}
		
		private function allResourceSaved():void
		{
			AppConfig.instance.log("All Updated...");
			
			_onUpdateComplete();
		}
	}
}