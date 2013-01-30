package core.structs
{
	public class Language extends Struct
	{
		public var id:String;
		public var name:String;
		public var data:String;
		public var path:String;
		
		/*XML结构如下:
			<language id="1">
				<name>中文</name>
				<data>0</data>
				<path></path>
			</language>
		*/
		public function Language(xml:XML)
		{
			this.id = xml.@id;
			this.name = xml.name;
			this.data = xml.data;
			this.path = xml.path;
		}
	}
}