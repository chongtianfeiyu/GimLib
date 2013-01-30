package core.structs
{
	public class AD extends Struct
	{
		public var id:String;
		public var name:String;
		public var order:String;
		public var startTime:String;
		public var endTime:String;
		public var startData:String;
		public var endData:String;
		public var logoURL:String;
		public var sourceURL:String;
		public var type:String;
		public var adTime:String;
		
		/*XML结构如下:
		<AD>
			<ID>12</ID>
			<name>情人节海报</name>
			<order>3</order>
			<startTime>08:00</startTime>
			<endTime>18:00</endTime>
			<startData>2012-12-27 12:05:17</startData>
			<endData>2013-3-15 12:05:17</endData>
			<logoURL>upfiles/ad/logo/20130106101203578d388914116d946d2b1526ea7c4569311.jpg</logoURL>
			<sourceURL>upfiles/ad/20121227130345195e602513aa653464db0f9ea92b5872826.jpg</sourceURL>
			<type>photo</type>
			<adTime>5</adTime>
		</AD>
		*/
		public function AD(xml:XML)
		{
			this.id = xml.ID;
			this.name = xml.name;
			this.order = xml.order;
			this.startTime = xml.startTime;
			this.endTime = xml.endTime;
			this.startData = xml.startData;
			this.endData = xml.endData;
			this.logoURL = xml.logoURL;
			this.sourceURL = xml.sourceURL;
			this.type = xml.type;
			this.adTime = xml.adTime;
		}
	}
}