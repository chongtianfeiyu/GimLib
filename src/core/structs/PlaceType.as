package core.structs
{
	public class PlaceType extends Struct
	{
		/*
		<placeType id="1">
			<parentID>0</parentID>
			<depth>0</depth>
			<order>1</order>
			<logoURL/>
			<data>shop</data>
			<visible>False</visible>
			<name>
				<value languageID="1">店铺</value>
				<value languageID="2">shop</value>
			</name>
		</placeType> 
		*/
		public var id:String;
		public var parentID:String;
		public var depth:String;
		public var order:String;
		public var logoURL:String;
		public var data:String;
		public var visible:String;
		public var name:Object;
		
		public function PlaceType(xml:XML)
		{
			this.id = xml.@id;
			this.parentID = xml.parentID;
			this.depth = xml.depth;
			this.order = xml.textColor;
			this.logoURL = xml.order;
			this.data = xml.data;
			this.visible = xml.visible;
			this.name = constructWithLanguageID(xml.name);
		}
	}
}