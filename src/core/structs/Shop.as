package core.structs
{
	public class Shop extends Struct
	{
		public var id:String;
		public var logoURL:String;
		public var telephone:String;
		public var mobile:String;
		public var fax:String;
		public var link:String;
		public var email:String;
		public var placeID:String;
		public var order:String;
		public var images:Array;
		public var categories:Array;
		public var name:Object;
		public var description:Object;
		public var workTime:Object;
		public var address:Object;
		public var mainScope:Object;
		public var contact:Object;
		public var place:Place;
		/*
		<shop ID="18">
			<logoURL>upfiles/shop/logo/201212516112015657867460.png</logoURL>
			<telephone/>
			<mobile/>
			<fax/>
			<link/>
			<email/>
			<placeID>259</placeID>
			<order>0</order>
			<images>
				<image/>
				<image/>
				<image/>
				<image/>
				<image/>
			</images>
			<categories>
				<categoryID>11</categoryID>
				<categoryID>13</categoryID>
			</categories>
			<name>
				<value languageID="1">jeep im david bmw</value>
				<value languageID="2"/>
			</name>
			<description>
				<value languageID="1"/>
				<value languageID="2"/>
			</description>
			<workTime>
				<value languageID="1">10:00-22:00</value>
				<value languageID="2"/>
			</workTime>
			<address>
				<value languageID="1"/>
				<value languageID="2"/>
			</address>
			<mainScope>
				<value languageID="1"/>
				<value languageID="2"/>
			</mainScope>
			<contact>
				<value languageID="1"/>
				<value languageID="2"/>
			</contact>
		</shop>
		*/
		
		public function Shop(xml:XML)
		{
			this.id = xml.@ID;
			this.logoURL = xml.logoURL;
			this.telephone = xml.telephone;
			this.mobile = xml.mobile;
			this.fax = xml.fax;
			this.link = xml.link;
			this.email = xml.email;
			this.placeID = xml.placeID;
			this.order = xml.order;
			this.images = constructToArray(xml.images);
			this.categories = constructToArray(xml.categories);
			this.name = constructWithLanguageID(xml.name);
			this.description = constructWithLanguageID(xml.description);
			this.workTime = constructWithLanguageID(xml.workTime);
			this.address = constructWithLanguageID(xml.address);
			this.mainScope = constructWithLanguageID(xml.mainScope);
			this.contact = constructWithLanguageID(xml.contact);
		}
		
	}
}