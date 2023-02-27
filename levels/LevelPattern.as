package levels 
{
	/**
	 * ...
	 * @author crd
	 */
	public class LevelPattern 
	{
		
		public var objects:Array = new Array();
		
		public function LevelPattern(...rest)
		{
			for (var i:int = 0; i < rest.length; i++)
			{
				objects.push(rest[i]);
			}//end for i
		}//constr
		
	}//LevelPattern

}//pack