package core
{
	public class WebServiceCommand
	{
		public var commandName:String;
		public var commandStr:String;
		public var localFilePath:String;
		
		public function WebServiceCommand($commandName:String,$commandStr:String)
		{
			commandName = $commandName;
			commandStr = $commandStr;
			localFilePath = commandName + ".xml";
		}
	}
}