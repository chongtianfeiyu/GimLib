package core.structs
{
	public class NewsType extends Struct
	{
		public var id:String;
		public var color:String;
		public var logoURL:String;
		public var name:Object;
		public var subNews:Array;
		/*
		<newsType id="1">
			<order>1</order>
			<color>#000000</color>
			<logoURL/>
			<name>
				<value languageID="1">商城动态</value>
				<value languageID="2"/>
			</name>
		</newsType>
		*/
		
		public function NewsType(xml:XML)
		{
			this.id = xml.@id;
			this.color = xml.color;
			this.logoURL = xml.logoURL;
			this.name = constructWithLanguageID(xml.name);
			this.subNews = [];
		}
		
	}
}