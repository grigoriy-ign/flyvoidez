package gui 
{
	import criadone.utils.SimpleTracerPanel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * 
	 */
	public class HelpTextControl 
	{
		
		public static var helpText:MovieClip;
		
		public static var pagesText:Array = new Array();
		public static var pagesSpecial:Array = new Array();
		
		private static var currentPage:int = 0;
		
		public static function init():void
		{
			pagesText.push("");
			pagesText.push("");
			pagesText.push("");
		
			pagesSpecial.push("It is a SPECIAL PAGE! Level Begins! You must fly! Fly!");
			
		}//init
		
		public static function setActiveHelpText(ht:MovieClip):void
		{
			helpText = ht;
			goToPage(0);
			if (!(ht.scrDown.hasEventListener(MouseEvent.MOUSE_DOWN)))
			{
				ht.scrDown.addEventListener(MouseEvent.MOUSE_DOWN, nextClick);
			}
			if (!(ht.scrUp.hasEventListener(MouseEvent.MOUSE_DOWN)))
			{
				ht.scrUp.addEventListener(MouseEvent.MOUSE_DOWN, prevClick);
			}
			if (!(ht.hasEventListener(Event.ENTER_FRAME)))
			{
				ht.addEventListener(Event.ENTER_FRAME, update);
			}
			helpText.scrUp.visible = true;
			helpText.scrDown.visible = true;
			helpText.txt.mouseEnabled = false;
		}// setActiveHelpText
		
		public static function goToPage(n:int=0):void
		{
			helpText.txt.text = pagesText[n];
			helpText.scrUp.visible = true;
			helpText.scrDown.visible = true;
			helpText.txt.alpha = 0;
			currentPage = n;
		}// goToPage
		
		public static function goSpecialPage(n:int):void
		{
			helpText.txt.text = pagesSpecial[n];
			helpText.scrUp.visible = false;
			helpText.scrDown.visible = false;
		}// setSpecialPage
		
		public static function goNext():void
		{
			currentPage++;
			if (currentPage > pagesText.length - 1) currentPage = 0;
			goToPage(currentPage);
		}// goNext
		
		public static function goBack():void
		{
			currentPage--;
			if (currentPage < 0) currentPage = pagesText.length - 1;
			goToPage(currentPage);
		}// goBack
		
		public static function nextClick(me:MouseEvent):void
		{
			goNext();
		}// nextClick
		
		public static function prevClick(me:MouseEvent):void
		{
			goBack();
		}// prevClick
		
		public static function update(e:Event):void
		{
			if (helpText.txt.alpha < 1) helpText.txt.alpha += 0.01;
		}// update
		
	}//

}//