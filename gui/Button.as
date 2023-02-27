package gui 
{
	import appsound.SoundManager;
	import criadone.utils.SimpleTracerPanel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import resources.Resources;
	/**
	 * ...
	 * @author 
	 */
	public class Button extends Sprite
	{
		
		private var _tf:TextField;
		private var _tfm:TextFormat;
		
		private var _glow:GlowFilter;
		private var _filters:Array;
		
		private var mouseOver:Boolean=false;
		
		public function Button() 
		{
			init();
		}
		
		public function setText(str:String):void
		{
			_tf.text = str;
			_tf.setTextFormat(_tfm);
		}
		
		//___________________________________________________________________________ PRIVATE
		
		private function init():void
		{
			//graphics.beginFill(0x505050);
			graphics.beginBitmapFill(Resources.button_bg_Bitmap.bitmapData,null,false,false);
			graphics.drawRect(0,0,204,48);
			graphics.endFill();
			//
			_tf=new TextField();
			_tf.selectable=false;
			//_tf.autoSize=TextFieldAutoSize.CENTER;
			_tf.width = 204;
			_tf.height = 40;
			_tf.border = true;
			_tf.y = 5;
			_tf.embedFonts = true;
			_tfm=new TextFormat("Arial",25,0xffffff,null,null,null,null,null,TextFormatAlign.CENTER);
			_tf.setTextFormat(_tfm);
			_tf.defaultTextFormat = _tfm;
			_tf.mouseEnabled = false;
			_tf.mouseWheelEnabled = false;
			_tf.cacheAsBitmap = true;
			addChild(_tf);
			//
			_glow=new GlowFilter(0xffffff,1,5,5,3,1);
			//
			_filters=new Array(_glow);
			//
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseClick);
			addEventListener(Event.ENTER_FRAME,EnterFrame);
			//
			
			MouseEventManager.addElement(new MouseEventObject(this, MouseEvent.MOUSE_OVER, onMouseOver));
			MouseEventManager.addElement(new MouseEventObject(this, MouseEvent.MOUSE_OUT, onMouseOut));
			MouseEventManager.addElement(new MouseEventObject(this, MouseEvent.MOUSE_DOWN, onMouseClick));
			
			_tf.setTextFormat(_tfm);
			
		}//init
		
		private function onMouseClick(me:MouseEvent):void
		{
			SoundManager.playSound(SoundManager.SND_CLICK);
		}//onMouseClick
		
		private function onMouseOver(me:MouseEvent):void
		{
			_tf.setTextFormat(_tfm);
			mouseOver=true;
		}
		
		private function onMouseOut(me:MouseEvent):void
		{
			_tf.setTextFormat(_tfm);
			mouseOver=false;
		}
		
		private function EnterFrame(e:Event):void
		{
			/*if(mouseOver)
			{
			if(_glow.blurX<50)_glow.blurX+=2;
			if(_glow.blurY<50)_glow.blurY+=2;
			scaleX+=0.01;
			_glow.strength++;
			}else{
			if(_glow.blurX>0)_glow.blurX-=5;
			if (_glow.blurY > 0)_glow.blurY -= 5;
			_glow.strength--;	
			}
			if (_glow.blurX < 1)
			{
				_tf.filters = null;
			}
			else
			{
				_tf.filters = _filters;
			}*/
		}//EnterFrame
		
	}//class
}//pack