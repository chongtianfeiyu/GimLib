package gim.parsers
{
	public class GimXmlParser
	{
		/**
		 * 将xml解析为一个object,请调用静态方法parse(xml)
		 * */
		public function GimXmlParser()
		{
		}
		
		/**
		 * 传入一个XML对象,解析后返回Object
		 * @param xml 传入的XML对象
		 * */
		public static function parse(xml:XML):Object
		{
			var obj:Object = {};
			for(var i:int = 0;i < xml.children().length();i++)
			{
				var subXml:XML = xml.children()[i];
				if(subXml.children().length() <= 1)
				{
					var str:String = subXml.@*.toString();
					if(str)
					{
						obj[str] = subXml.toString();
					}
					else
					{
						obj[subXml.name()] = subXml.toString();
					}
				}
				else
				{
					obj[subXml.name()] = parse(subXml);
				}
			}
			return obj;
		}
		
		/**
		 * 传入一个xml和后缀名列表,返回按后缀名过滤后的文件名数组,必须形如".swf"这种四个字符的后缀才可以,以后应该修改为任意长后缀都可以
		 * */
		public static function parseByFileType(xml:XML,filetypes:Array):Array
		{
			var urls:Array = [];
			
			var xmlLength:int = xml.children().length();
			for(var i:int = 0;i < xmlLength;i ++)
			{
				var subXml:XML = xml.children()[i];
				if(subXml.children().length() > 0)
				{
					urls = urls.concat(parseByFileType(subXml,filetypes));
				}
				else
				{
					var str:String = subXml.toString();
					var keyWord:String = str.substr(str.length - 4,4);
					if(filetypes.indexOf(keyWord) != -1)
					{
						urls.push(str);
					}
				}
			}
			
			return urls;
		}
	}
}