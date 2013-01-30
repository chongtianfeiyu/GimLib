package gim.maps.models
{
	
	/**
	 * ...
	 * @author Gamba
	 */
	public class ModelPlaceType extends Model
	{
		/*
		   <placeType id="3">
		   <parentID>0</parentID>
		   <depth>0</depth>
		   <order>13</order>
		   <logoURL></logoURL>
		   <data>ground</data>
		   <visible>False</visible>
		   <name>
		   <value languageID="1">地形/Terrain</value>
		   <value languageID="2">Ground</value>
		   </name>
		   </placeType>
		 * */
		
		public var id:String;
		public var parentID:String;
		public var depth:String;
		public var order:String;
		public var logoURL:String;
		public var data:String;
		public var visible:String;
		public var name:Object;
		
		public function ModelPlaceType(xml:XML)
		{
			this.id = xml.@id;
			this.parentID = xml.parentID;
			this.depth = xml.depth;
			this.order = xml.order;
			this.logoURL = xml.logoURL;
			this.data = xml.data;
			this.visible = xml.visible;
			this.name = getValuesByLanguageID(xml.name.children());
		}
	
	}

}