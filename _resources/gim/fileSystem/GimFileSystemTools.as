package gim.fileSystem 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author BOB
	 */
	public class GimFileSystemTools 
	{
		
		public function GimFileSystemTools() 
		{
			
		}
		
		/**
		 * 如果没有文件夹则创建一个
		 * @param path 文件夹路径
		 * */
		static public function noDirThenCreate(path:String):void 
		{
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			if (!file.isDirectory)
			{
				file.createDirectory();
			}
		}
		
		/**
		 * 扫描本地文件夹,生成xml对象
		 * @param path 文件夹路径
		 * */
		static public function scanForLocalMediaXML(path:String,nodeName:String):XML 
		{
			var fileArr:Array = File.applicationDirectory.resolvePath(path).getDirectoryListing();
			var xmlString:String = "<nodes>";
			for (var i:int = 0; i < fileArr.length; i++) 
			{
				var file:File = fileArr[i];
				var tmpPath:String = file.url;
				tmpPath = tmpPath.substr("app:/".length);
				xmlString += "<node><"+nodeName+">" + file.url.substr("app:/".length) + "</"+nodeName+"></node>";
			}
			xmlString += "</nodes>"
			var xml:XML = XML(xmlString);
			return xml;
		}
		
		/**
		 * 将文件保存到本地
		 * @param path 保存文件的路径,可以带目录
		 * @param data 要保存的文件,如果为string,则保存为txt文件
		 * @param onSaveComplete 保存完毕后调用的函数,这个函数赋值后才能保证文件保存后能断开引用,才能对文件操作
		 * */
		static public function saveFileTo(path:String,data:Object,onSaveComplete:Function = null):void
		{
			if(isFileExists(path)) deleteFile(path);
			var myFile:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			var fileStream:FileStream = new FileStream();
			fileStream.openAsync(myFile, FileMode.UPDATE);
			if (data is String)
			{
				fileStream.writeUTFBytes(data as String);
			}else
			{
				fileStream.writeBytes(data as ByteArray);
			}
			fileStream.addEventListener(Event.CLOSE, onSaveComplete);
			fileStream.close();
		}
		
		/**
		 * 删除文件
		 * @param path 要删除的文件路径
		 * */
		static public function deleteFile(path:String):void 
		{
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			if (file.exists)
			{
				file.deleteFile();
//				trace("- GimFileSystemTools deleteFile:",path,"deleted.");
			}
		}
		
		/**
		 * 以二进制方式载入一个flv文件
		 * @param path 文件路径
		 * @param onLoadComplete 载入完毕后调用onLoadComplete(data);data为载入的二进制文件
		 * */
		static public function loadBinFile(path:String, onLoadComplete:Function):void 
		{
			var data:ByteArray;
			var myFile:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			var fileStream:FileStream = new FileStream();
			fileStream.openAsync(myFile, FileMode.UPDATE);
			fileStream.readBytes(data);
			fileStream.close();
			onLoadComplete(data);
		}
		
		/**
		 * 验证文件是否存在
		 * @param path 要验证的文件路径
		 * */
		public static function isFileExists(path:String):Boolean
		{
			// TODO Auto Generated method stub
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			return file.exists;
		}
		
		/**
		 * 载入字符串对象,回调函数中用参数Event中的Event.currenttarget.data取得字符串
		 * @param path 文件地址或者url
		 * @param onLoadComplete 监听函数,参数为Event对象,其载入的字符串为Event.currenttarget.data
		 * */
		public static function loadString(path:String, onLoadComplete:Function,onError:Function = null):void
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE,onLoadComplete);
			if(onError == null)
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void{
					trace("- GimFileSystem,133,IOErrorEvent:",e);
				});
			else
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onError);
			urlLoader.load(new URLRequest(path));
		}
		
		/**
		 * 线性载入字符串对象,回调函数中参数Object中以pathes为键值返回相应字符串
		 * @param pathes 文件地址或者url数组
		 * @param onLoadComplete 监听函数,参数为Object对象,Obj[path]对应包含相应的字符串
		 * */
		public static function loadStringsLinear(pathes:Array,onLoadComplete:Function,onError:Function = null):void
		{
			_loadStringLinearIndex = 0;
			_pathes = pathes;
			_loadStringLinearCompleteHandler = onLoadComplete;
			_onErrorHandler = onError;
			_stringObj = {};
			
			onloadStringLinearLoaded(null);
		}
		
		private static var _loadStringLinearIndex:int;
		private static var _loadStringLinearCompleteHandler:Function;
		private static var _onErrorHandler:Function;
		private static var _pathes:Array;
		private static var _stringObj:Object;
		
		private static function onloadStringLinearLoaded(e:Event):void
		{
			if(e == null)											//每次事件为空的时候
			{
				var path:String = _pathes[_loadStringLinearIndex];
				loadString(path,onloadStringLinearLoaded,_onErrorHandler);
				
				AppConfig.instance.log("Source " + _loadStringLinearIndex + " " + path + " loading...");
			}
			else													//有数据载入完成了
			{
				var str:String = e.currentTarget.data;
				_stringObj[_pathes[_loadStringLinearIndex]] = str;	//以路径为键值,放入载入后的字符串
				
				_loadStringLinearIndex ++;
				if(_loadStringLinearIndex < _pathes.length)			//Urls[index]还有数据,递归载入,否则调用完成函数跳出递归
				{
					onloadStringLinearLoaded(null);
				}
				else
				{
					_loadStringLinearCompleteHandler(_stringObj);
				}
			}
		}
	}

}