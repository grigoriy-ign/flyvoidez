package gui 
{
	/**
	 * ...
	 * 
	 */
	public class MouseEventManager 
	{
		
		public static var allElements:Array = new Array();
		
		public static function addElement(e:MouseEventObject):void
		{
			allElements.push(e);
		}
		
		public static function disableMouseEvents():void
		{
			for (var i:int = 0; i < allElements.length; i++)
			{
				var curElem:MouseEventObject = allElements[i];
				removeListener(curElem.object, curElem.type, curElem.listener);
			}
		}
		
		public static function enableMouseEvents():void
		{
			for (var i:int = 0; i < allElements.length; i++)
			{
				var curElem:MouseEventObject = allElements[i];
				addListener(curElem.object, curElem.type, curElem.listener);
			}
		}
		
		public static function removeListener(object:*,type:String, listener:Function):void
		{
			if (object.hasEventListener(type))
			{
				object.removeEventListener(type, listener);
			}
		}//removeListener
		
		public static function addListener(object:*,type:String, listener:Function):void
		{
			if (!(object.hasEventListener(type)))object.addEventListener(type, listener);
		}//removeListener
		
	}//class

}//pack