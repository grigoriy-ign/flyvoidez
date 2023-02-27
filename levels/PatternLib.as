package levels 
{
	/**
	 * ...
	 * @author crd
	 */
	public class PatternLib 
	{
	
		/*
		 object types
		 BOU - border up
		 BOD - border down
		 BOT - border both
		 BOX - simple box form
		*/
		 
		/*
		  * easy - medium - hard
		*/
		public static function getRandomPattern():LevelPattern
		{
			var count:int = 0;
			var currentPatterns:Array;
			currentPatterns = easyPatterns;
			count = currentPatterns.length;
			var numb:int = Math.random() * count;
			return currentPatterns[numb];
		}//get random pattern
		
		public static function getPattern(ind:int):LevelPattern
		{
			
			var currentPatterns:Array;
			currentPatterns = easyPatterns;
			return currentPatterns[ind];
			
		}//get pattern
		
		
		// every row describes some objects. every object written like this: 	stg_s_0_(0,0)_(0,1,2)_(374,32)_bou
		public static var easyPatterns:Array = new Array
		(
			new LevelPattern("stg_b_11_3_(365,334)")
		);// easyPatterns
		
	}//class
}//pack








