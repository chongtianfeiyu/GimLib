package core.structs
{
	public class Struct
	{
		public function Struct()
		{
		}
		
		protected function constructWithLanguageID(xmlNode:XMLList):Object
		{
			var obj:Object = {};
			for(var i:int = 0;i < xmlNode.children().length();i ++)
			{
				var tmpXML:XML = xmlNode.children()[i];
				obj[tmpXML.@languageID] = tmpXML.toString();
			}
			return obj;
		}		
		
		protected function constructToArray(xmlNode:XMLList):Array
		{
			var arr:Array = [];
			for(var i:int = 0;i < xmlNode.children().length();i ++)
			{
				arr.push(xmlNode.children()[i].toString());
			}
			return arr;
		}
	}
}