package levels 
{
	import levels.desert.*;
	import levels.ocean.*;
	import levels.winter.*;
	/**
	 * ...
	 * @author 
	 */
	public class LevelList
	{

		public static var levelsWinter:Array=new Array
		(
		new LevelInfo(LevelWinter_001.levelobjects,LevelWinter_001.levelObjectsStringArray,LevelWinter_001.location,LevelWinter_001.time,LevelWinter_001.levelEnd),
		new LevelInfo(LevelWinter_002.levelobjects,LevelWinter_002.levelObjectsStringArray,LevelWinter_002.location,LevelWinter_002.time,LevelWinter_002.levelEnd)
		);
		
		public static var levelsDesert:Array=new Array
		(
		new LevelInfo(LevelDesert_001.levelobjects,LevelDesert_001.levelObjectsStringArray,LevelDesert_001.location,LevelDesert_001.time,LevelDesert_001.levelEnd),
		new LevelInfo(LevelDesert_002.levelobjects,LevelDesert_002.levelObjectsStringArray,LevelDesert_002.location,LevelDesert_002.time,LevelDesert_002.levelEnd)
		);
		
		public static var levelsOcean:Array=new Array
		(
		new LevelInfo(LevelOcean_001.levelobjects,LevelOcean_001.levelObjectsStringArray,LevelOcean_001.location,LevelOcean_001.time,LevelOcean_001.levelEnd),
		new LevelInfo(LevelOcean_002.levelobjects,LevelOcean_002.levelObjectsStringArray,LevelOcean_002.location,LevelOcean_002.time,LevelOcean_002.levelEnd)
		);
		
	}//class
}