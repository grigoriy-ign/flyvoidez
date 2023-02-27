package gui 
{
	/**
	 * ...
	 * 
	 */
	public class MouseEventObject 
	{
		
		public var object:*;
		public var type:String;
		public var listener:Function;
		
		public function MouseEventObject(obj:*,typ:String,listen:Function) 
		{
			object = obj;
			type = typ;
			listener = listen;
		}//MouseEventObject
		
	}

}