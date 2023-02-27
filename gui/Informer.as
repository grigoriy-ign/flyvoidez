package gui 
{
	import criadone.utils.SimpleTracerPanel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * 
	 */
	public class Informer extends Sprite
	{
		
		public var messages:Array = new Array();
		public var txt:messageText;
		
		public var filtersArr:Array = null;
		
		public function Informer() 
		{
			init();
		}//Informer
		
		public function update():void
		{
			var curMsg:MovieClip;
			for (var i:int = 0; i < messages.length; i++)
			{
				curMsg = messages[i];
				if (curMsg.alpha>0.1)
				{
					curMsg.y -= 3;
					curMsg.alpha -= 0.02;
					curMsg.visible = true;
				}
				else
				{
					curMsg.visible = false;
				}
			}
		}//update
		
		public function addMessage(str:String,col:int=0xff0000):void
		{
			var curMsg:MovieClip;
			
			for (var i:int = 0; i < messages.length; i++)
			{
				curMsg = messages[i];
				if (curMsg.visible == false)
				{
					curMsg.y = 0;
					curMsg.alpha = 1;
					curMsg.visible = true;
					curMsg.txt.text = str;
					curMsg.txt.textColor = col;
					curMsg.txt.autoSize = TextFieldAutoSize.CENTER;
					
					break;
				}//visible == false
			}//end for i
		}//addMessage
		
		public function clearMessages():void
		{
			var curMsg:MovieClip;
			for (var i:int = 0; i < messages.length; i++)
			{
				curMsg = messages[i];
				curMsg.txt.text = "";
			}//end for i
		}// clearMessages
		
		//		PRIVATE
		
		private function init():void
		{
			for (var i:int = 0; i < 10; i++)
			{
				txt = new messageText();
				txt.alpha = 0;
				txt.filters = filtersArr;
				txt.scaleX = txt.scaleY = 1.3;
				txt.mouseChildren = false;
				txt.mouseEnabled = false;
				messages.push(txt);
				addChild(txt);
			}
		}//init
		
	}//class

}//pack