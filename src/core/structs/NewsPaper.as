package core.structs
{
	public class NewsPaper extends Struct
	{
		public var id:String;
		public var startTime:String;
		public var endTime:String;
		public var image:String;
		public var rank:String;
		public var name:Object;
		/*
		<NewsPaper id="2">
			<startTime>2013/1/24 10:44:58</startTime>
			<endTime>2013/1/31 10:44:58</endTime>
			<image>upfiles/shop/active/20130124104458836311079901f104587b9e45dfa83a908f2.jpg</image>
			<rank>1</rank>
			<name>
				<value languageID="1">1</value>
				<value languageID="2"></value>
			</name>
		</NewsPaper>
		*/
		
		public function NewsPaper(xml:XML)
		{
			this.id = xml.@id;
			this.startTime = xml.startTime;
			this.endTime = xml.endTime;
			this.image = xml.image;
			this.rank = xml.rank;
			this.name = this.constructWithLanguageID(xml.name);
		}
	}
}