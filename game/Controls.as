package game 
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author 
	 */
	public class Controls
	{
		
		public static var isKeyLeft:Boolean;
		public static var isKeyRight:Boolean;
		public static var isKeyDown:Boolean;
		public static var isKeyUp:Boolean;
		
		public static function init():void
		{
			isKeyLeft=false;
			isKeyRight=false;
			isKeyDown=false;
			isKeyUp=false;
		}
		
		public static function keyDown(ke:KeyboardEvent):void
		{
			switch(ke.keyCode)
			{
				case Keyboard.LEFT:
				isKeyLeft=true;
				break;
				
				case Keyboard.RIGHT:
				isKeyRight=true;
				break;
				
				case Keyboard.UP:
				isKeyUp=true;
				break;
				
				case Keyboard.DOWN:
				isKeyDown=true;
				break;
				
				default:break;
			}//sw
		}
		// key down
		
		public static function keyUp(ke:KeyboardEvent):void
		{
			switch(ke.keyCode)
			{
				case Keyboard.LEFT:
				isKeyLeft=false;
				break;
				
				case Keyboard.RIGHT:
				isKeyRight=false;
				break;
				
				case Keyboard.UP:
				isKeyUp=false;
				break;
				
				case Keyboard.DOWN:
				isKeyDown=false;
				break;
				
				default:break;
			}//sw
		}
		//key up
	
	//class
	}
}