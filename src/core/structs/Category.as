package core.structs
{
	public class Category extends Struct
	{
		public var id:String;
		public var depth:String;
		public var parentID:String;
		public var order:String;
		public var color:String;
		public var name:Object;
		public var subShops:Array;
		
		/*XML结构如下:
			<category id="2">
				<depth>0</depth>
				<parentID>0</parentID>
				<order>1</order>
				<color/>
				<name>
				<value languageID="1">主力店</value>
				<value languageID="2"/>
				</name>
			</category>
		*/
		public function Category(xml:XML)
		{
			this.id = xml.@id;
			this.depth = xml.depth;
			this.parentID = xml.parentID;
			this.order = xml.order;
			this.color = xml.color;
			this.name = this.constructWithLanguageID(xml.name);	//这里当解析name
			this.subShops = [];
		}
	}
}