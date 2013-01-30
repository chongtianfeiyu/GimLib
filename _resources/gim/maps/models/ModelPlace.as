package gim.maps.models
{
	
	/**
	 * ...
	 * @author Gamba
	 */
	public class ModelPlace extends Model
	{
		/*
		 *
		   <place id="83">
		   <nodeID>2012-11-09_17:08:26_5753_9581</nodeID>
		   <number>A004A</number>
		   <textColor>0</textColor>
		   <color>6737049</color>
		   <textX>0</textX>
		   <textY>-10</textY>
		   <iconX>0</iconX>
		   <iconY>10</iconY>
		   <textMapping>False</textMapping>
		   <iconMapping>False</iconMapping>
		   <iconScale>1</iconScale>
		   <textScale>1</textScale>
		   <iconRotate>0</iconRotate>
		   <textRotate>0</textRotate>
		   <level>0</level>
		   <order>71</order>
		   <area>0,585.5,958.5|1,598.25,999|1,621.75,992.75|1,609.25,951.5</area>
		   <placeTypeID>1</placeTypeID>
		   <floorID>1</floorID>
		   <name>
		   <value languageID="1">
		   </value>
		   <value languageID="2">
		   </value>
		   </name>
		   </place>
		 * */
		
		public var id:String;
		public var nodeID:String;
		public var number:String;
		public var textColor:String;
		public var color:String;
		public var textX:String;
		public var textY:String;
		public var iconX:String;
		public var iconY:String;
		public var textMapping:String;
		public var iconMapping:String;
		public var iconScale:String;
		public var textScale:String;
		public var iconRotate:String;
		public var textRotate:String;
		public var level:String;
		public var order:String;
		public var area:String;
		public var placeTypeID:String;
		public var floorID:String;
		public var name:Object;
		
		public function ModelPlace(xml:XML)
		{
			this.id = xml.@id;
			this.nodeID = xml.nodeID;
			this.number = xml.number;
			this.textColor = xml.textColor;
			this.color = xml.color;
			this.textX = xml.textX;
			this.textY = xml.textY;
			this.iconX = xml.iconX;
			this.iconY = xml.iconY;
			this.textMapping = xml.textMapping;
			this.iconMapping = xml.iconMapping;
			this.iconScale = xml.iconScale;
			this.textScale = xml.textScale;
			this.iconRotate = xml.iconRotate;
			this.textRotate = xml.textRotate;
			this.level = xml.level;
			this.order = xml.order;
			this.area = xml.area;
			this.placeTypeID = xml.placeTypeID;
			this.floorID = xml.floorID;
			this.name = getValuesByLanguageID(xml.name.children());
		}
	
	}

}