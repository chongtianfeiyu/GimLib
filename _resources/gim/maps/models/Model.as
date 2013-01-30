package gim.maps.models 
{
	/**
	 * ...
	 * @author Gamba
	 */
	public class Model 
	{
		
		public function Model() 
		{
			
		}
		
		protected function getValuesByLanguageID(xmlList:XMLList):Object
		{
			var obj:Object = { };
			for each(var xml:XML in xmlList)
			{
				obj[xml.@languageID] = xml.toString();
			}
			return obj;
		}
		
	}

}