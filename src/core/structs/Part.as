package core.structs
{
	public class Part extends Struct
	{
		public var id:String;
		public var parentID:String;
		public var visible:String;
		public var logo:String;
		public var partTypeID:String;
		public var name:Object;
		public var source:Object;
		
		/*XML结构如下:
		<part id="1">
			<parentID>0</parentID>
			<visible>False</visible>
			<logo>upfiles/part/活动速递.png</logo>
			<partTypeID>1</partTypeID>
			<name>
				<value languageID="1">活动速递</value>
				<value languageID="2"/>
			</name>
			<source>
				<value languageID="1"/>
				<value languageID="2"/>
			</source>
		</part>
		*/
		
		public function Part(xml:XML)
		{
			this.id = xml.@id;
			this.parentID = xml.parentID;
			this.visible = xml.visible;
			this.logo = xml.logo;
			this.partTypeID = xml.partTypeID;
			this.name = this.constructWithLanguageID(xml.name);
			this.source = this.constructWithLanguageID(xml.source);
		}
	}
}