package objects 
{
	/**
	 * ...
	 * @author 
	 */
	public class LibObjectInfo
	{

		public var strdata:String="";
		public var objName:String="";
		public var index:int;
		
		public function LibObjectInfo(ind:int,str:String,objname:String) 
		{
			index=ind;
			strdata=str;
			objName=objname;
		}
		
	}

}