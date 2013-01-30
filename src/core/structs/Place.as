package core.structs
{
	public class Place extends Struct
	{
		public var shop:Shop;
		
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
		public var categories:String;
		public var placeTypeID:String;
		public var floorID:String;
		public var name:Object;
		public var placeTypeName:Object;
		/*
		<place id="1">
			<nodeID>2012-11-08_14:27:42_398_2374</nodeID>
			<number>A022B</number>
			<textColor>0</textColor>
			<color>6737151</color>
			<textX>0</textX>
			<textY>-10</textY>
			<iconX>0</iconX>
			<iconY>10</iconY>
			<textMapping>True</textMapping>
			<iconMapping>True</iconMapping>
			<iconScale>1</iconScale>
			<textScale>1</textScale>
			<iconRotate>0</iconRotate>
			<textRotate>0</textRotate>
			<level>0</level>
			<order>58</order>
			<area>0,2130.75,628.65|1,2090.5,710.25|1,2165.3,751.25|1,2206.65,748.2|1,2204,667.75</area>
			<placeTypeID>1</placeTypeID>
			<floorID>1</floorID>
			<name>
				<value languageID="1">A022B</value>
				<value languageID="2"/>
			</name>
		</place>
		*/
		
		public function Place(xml:XML)
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
			this.categories = xml.categories;
			this.placeTypeID = xml.placeTypeID;
			this.floorID = xml.floorID;
			this.name = constructWithLanguageID(xml.name);
		}
		
	}
}