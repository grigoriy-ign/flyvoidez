package game 
{
	import criadone.utils.SimpleTracerPanel;
	/**
	 * ...
	 * 
	 */
	public class ScoreData 
	{
		
		private static var totalScore:int = 0;
		
		public static function setTotalScore(sc:int):void
		{
			if (sc > totalScore)
			{
				totalScore = sc;
			}
		}
		
		public static function getTotalScore():int
		{
			return totalScore;
		}
		
		
		// ________________________________________________________________
		
		public static var levelsScoreInfo:Array = new Array
		(
			new Array(0,1,0),
			new Array(0, 1, 1),
			
			new Array(0,2,0),
			new Array(0, 2, 1),
			
			new Array(0,3,0),
			new Array(0,3,1)
		);
		
		public static var levelLockInfo:Array = new Array
		(
			new Array(false,1,0),
			new Array(false, 1, 1),
			
			new Array(false,2,0),
			new Array(false, 2, 1),
			
			new Array(false,3,0),
			new Array(false,3,1)
		);
		
		public static var locationsLocked:Array = new Array(false, false, false); // three locations
		
		public static function isLevelLocked(locationStr:String, levelInd:int, doUnlock:Boolean=false):Boolean
		{
			var locationInd:int = 0;
			if (locationStr == "winter") locationInd = 1;
			if (locationStr == "desert") locationInd = 2;
			if (locationStr == "sea") locationInd = 3;
			var curLevelArray:Array;
			for(var i:int = 0; i < levelLockInfo.length; i++) // levels count
			{
				curLevelArray = levelLockInfo[i];
				if (curLevelArray[1] == locationInd) // location
				{
					if (curLevelArray[2] == levelInd) // level
					{
						if (doUnlock) curLevelArray[0] = false;
						return curLevelArray[0];
					}// level
				}// location
			}// end i
			return false;
		}// isLevelLocked
		
		public static function addScores(scr:int, locationStr:String, levelInd:int):void
		{
			var locationInd:int = 0;
			if (locationStr == "winter") locationInd = 1;
			if (locationStr == "desert") locationInd = 2;
			if (locationStr == "sea") locationInd = 3;
			var curLevelArray:Array;
			for(var i:int = 0; i < levelsScoreInfo.length; i++) // levels count
			{
				curLevelArray = levelsScoreInfo[i];
				if (curLevelArray[1] == locationInd) // location
				{
					if (curLevelArray[2] == levelInd) // level
					{
						if (scr > curLevelArray[0])
						{
							curLevelArray[0] = scr;
							SimpleTracerPanel.traceString("better result : " + scr);
						}
						else
						{
							SimpleTracerPanel.traceString("no better scores, best result is:"+curLevelArray[0]);
						}
					}//
				}//
			}//end i
		}// addScores
		
		public static function getLevelScore(locInd:int, levInd:int):int
		{
			var curLevelArray:Array;
			for(var i:int = 0; i < levelsScoreInfo.length; i++) // levels count
			{
				curLevelArray = levelsScoreInfo[i];
				if (curLevelArray[1] == locInd) // location
				{
					if (curLevelArray[2] == levInd) // level
					{
						return curLevelArray[0];
					}//lev
				}//loc
			}// i
			return -1;
		}// getStaticScores
		
		public static function getTotalScores():int
		{
			var res:int = 0;
			
			var curLevelArray:Array;
			for(var i:int = 0; i < levelsScoreInfo.length; i++) // levels count
			{
				curLevelArray = levelsScoreInfo[i];
				res += curLevelArray[0];
			}//end i
			
			return res;
		}// getTotalScores
		
	}//class

}//pack