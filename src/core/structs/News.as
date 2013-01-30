package core.structs
{
	public class News extends Struct
	{
		public var id:String;
		public var startDate:String;
		public var endDate:String;
		public var hasImage:String;
		public var newsTypeID:String;
		public var image:String;
		public var title:Object;
		public var contentPageURL:Object;
		/*
		<news id="1">
			<startDate>2012-11-12 10:59:45</startDate>
			<endDate>2012-11-30 17:22:14</endDate>
			<hasImage>False</hasImage>
			<newsTypeID>1</newsTypeID>
			<image/>
			<title>
				<value languageID="1">株洲神农·太阳城起航 湖南最大规模商业综合体崛起</value>
				<value languageID="2"/>
			</title>
			<contentPageURL>
				<value languageID="1">New.aspx?newsid=C106AEC0BF5A0D8F&amp;languageID=C106AEC0BF5A0D8F</value>
				<value languageID="2">New.aspx?newsid=C106AEC0BF5A0D8F&amp;languageID=163D8DA8618FEF98</value>
			</contentPageURL>
		</news>
		*/
		
		public function News(xml:XML)
		{
			this.id = xml.@id;
			this.startDate = xml.startDate;
			this.endDate = xml.endDate;
			this.hasImage = xml.hasImage;
			this.newsTypeID = xml.newsTypeID;
			this.image = xml.image;
			this.title = this.constructWithLanguageID(xml.title);
			this.contentPageURL = this.constructWithLanguageID(xml.contentPageURL);
		}
	}
}