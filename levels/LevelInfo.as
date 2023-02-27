package levels 
{
	/**
	 * ...
	 * @author 
	 */
	public class LevelInfo
	{
		public var levelLocation:String="winter";
		public var levelObjects:Array;
		public var levelObjectsStringArray:Array;
		public var time:int = 10;
		public var levelEnd:Number = 100;
		
		public function LevelInfo(levelObjs:Array,stringArray:Array,loc:String="winter",tm:int=10,levelEnding:Number=100) 
		{
			levelObjects=levelObjs;
			levelObjectsStringArray=stringArray;
			levelLocation = loc;
			time = tm;
			levelEnd = levelEnding;
		}
	
		
		//class
	}
}