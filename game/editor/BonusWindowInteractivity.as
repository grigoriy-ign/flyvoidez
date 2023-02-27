package game.editor 
{
	import flash.events.MouseEvent;
	import game.LevelEditor;
	import gui.MouseEventManager;
	import gui.MouseEventObject;
	/**
	 * ...
	 * @author 
	 */
	public class BonusWindowInteractivity
	{
		
		public static var editorRef:LevelEditor;
		
		public static var bonusWindow:BonusWindow;
		
		private static var _okButton:EditorButton;
		
		public static function init():void
		{
			_okButton=bonusWindow.getChildByName("okbutton") as EditorButton;
			_okButton.addEventListener(MouseEvent.CLICK, onOk_Click);
			_okButton.setCaption("OK");
			
			bonusWindow.b1.setCaption("star");
			bonusWindow.b2.setCaption("health");
			bonusWindow.b3.setCaption("time");
			bonusWindow.b4.setCaption("boost");
			bonusWindow.b5.setCaption("reverse");
			bonusWindow.b6.setCaption("random");
			
			bonusWindow.b1.addEventListener(MouseEvent.MOUSE_DOWN, clickStar);
			bonusWindow.b2.addEventListener(MouseEvent.MOUSE_DOWN, clickHealth);
			bonusWindow.b3.addEventListener(MouseEvent.MOUSE_DOWN, clickTime);
			bonusWindow.b4.addEventListener(MouseEvent.MOUSE_DOWN, clickBoost);
			bonusWindow.b5.addEventListener(MouseEvent.MOUSE_DOWN, clickReverse);
			bonusWindow.b6.addEventListener(MouseEvent.MOUSE_DOWN, clickRandom);
			
			MouseEventManager.addElement(new MouseEventObject(_okButton, MouseEvent.CLICK, onOk_Click));
			
			MouseEventManager.addElement(new MouseEventObject(bonusWindow.b1, MouseEvent.MOUSE_DOWN, clickStar));
			MouseEventManager.addElement(new MouseEventObject(bonusWindow.b2, MouseEvent.MOUSE_DOWN, clickHealth));
			MouseEventManager.addElement(new MouseEventObject(bonusWindow.b3, MouseEvent.MOUSE_DOWN, clickTime));
			MouseEventManager.addElement(new MouseEventObject(bonusWindow.b4, MouseEvent.MOUSE_DOWN, clickBoost));
			MouseEventManager.addElement(new MouseEventObject(bonusWindow.b5, MouseEvent.MOUSE_DOWN, clickReverse));
			MouseEventManager.addElement(new MouseEventObject(bonusWindow.b6, MouseEvent.MOUSE_DOWN, clickRandom));
			
		}//init
		
		private static function clickStar(me:MouseEvent):void
		{
			editorRef.bonusType = LevelEditor.BONUS_STAR;
		}//
		
		private static function clickHealth(me:MouseEvent):void
		{
			editorRef.bonusType = LevelEditor.BONUS_HEALTH;
		}//
		
		private static function clickTime(me:MouseEvent):void
		{
			editorRef.bonusType = LevelEditor.BONUS_TIME;
		}//
		
		private static function clickBoost(me:MouseEvent):void
		{
			editorRef.bonusType = LevelEditor.BONUS_BOOST;
		}//
		
		private static function clickReverse(me:MouseEvent):void
		{
			editorRef.bonusType = LevelEditor.BONUS_REVERSE;
		}//
		
		private static function clickRandom(me:MouseEvent):void
		{
			editorRef.bonusType = LevelEditor.BONUS_RANDOM;
		}//
	
		private static function onOk_Click(me:MouseEvent):void
		{
			bonusWindow.visible=false;
		}
		
	}//BonusWindowInteractivity
}//pack