package gim.maps.models
{
	
	/**
	 * ...
	 * @author Gamba
	 */
	public class ModelShop extends Model
	{
		/*
		 *<shop ID="192">
		   <logoURL>upfiles/shop/logo/201212271028066791dd051404f154aa5bd54d90b83c0ffaa.jpg</logoURL>
		   <telephone></telephone>
		   <mobile></mobile>
		   <fax></fax>
		   <link></link>
		   <email></email>
		   <placeID>603</placeID>
		   <order>8</order>
		   <images>
			<image> upfiles/shop/actual/201212271028066798f5b7921cc274fc8a855e32b9ddb8b29.bmp </image>
			<image> upfiles/shop/actual/2012122710280669571e12e7e8d5645c0b43363e0d6ea2f9b.bmp </image>
		   </images>
		   <categories>
			<categoryID>3</categoryID>
		   </categories>
		   <name>
			<value languageID="1">Banniere佰酿酒窝</value>
			<value languageID="2"></value>
		   </name>
		   <description>
			<value languageID="1">佰酿酒窖是众富佰酿公司旗下面向直接客户的品牌，整体运营方向为：佰酿酒窖专卖店、佰酿酒窖、佰酿酒窖旗舰店（会所）， </value>
			<value languageID="2"></value>
		   </description>
		   <workTime>
			<value languageID="1">10:00-22:00</value>
			<value languageID="2"></value>
		   </workTime>
		   <address>
			<value languageID="1"></value>
			<value languageID="2"></value>
		   </address>
		   <mainScope>
			<value languageID="1"></value>
			<value languageID="2"></value>
		   </mainScope>
		   <contact>
			<value languageID="1"></value>
			<value languageID="2"></value>
		   </contact>
		   </shop>
		 * */
		
		public var id:String;
		public var logoURL:String;
		public var telephone:String;
		public var mobile:String;
		public var fax:String;
		public var link:String;
		public var email:String;
		public var placeID:String;
		public var order:String;
		public var images:Object;
		public var categories:Object;
		public var name:Object;
		public var description:Object;
		public var workTime:Object;
		public var address:Object;
		public var mainScope:Object;
		public var contact:Object;
		
		public function ModelShop(xml:XML)
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
			this.images = getValuesByLanguageID(xml.images.children());
			this.categories = getValuesByLanguageID(xml.categories.children());
			this.name = getValuesByLanguageID(xml.name.children());
			this.description = getValuesByLanguageID(xml.description.children());
			this.workTime = getValuesByLanguageID(xml.workTime.children());
			this.address = getValuesByLanguageID(xml.address.children());
			this.mainScope = getValuesByLanguageID(xml.mainScope.children());
			this.contact = getValuesByLanguageID(xml.contact.children());
		}
	
	}

}