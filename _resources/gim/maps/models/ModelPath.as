package gim.maps.models
{
	
	/**
	 * ...
	 * @author Gamba
	 */
	public class ModelPath extends Model
	{
		/*
		   <path id="1">
			<node1ID>2012-12-05_16:03:50_5961_2015</node1ID>
			<node2ID>2012-11-10_15:26:34_785_1333</node2ID>
		   </path>
		 * */
		
		public var id:String;
		public var node1ID:String;
		public var node2ID:String;
		
		public function ModelPath(xml:XML)
		{
			this.id = xml.@id;
			this.node1ID = xml.node1ID;
			this.node2ID = xml.node2ID;
		}
	
	}

}