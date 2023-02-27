package gui 
{
	import appsound.SoundManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import resources.Resources;
	
	/**
	 * ...
	 * @author 
	 */
	public class RectGraphicButton extends Sprite
	{
		
		public static var lockImg:Bitmap = new Resources.icon_locked();
		
		private var mouseOver:Boolean=false;
		
		private var _etf:ExtText;
		
		private var _levelSelectrorRef:LevelSelector;
		private var _levelLocation:int;
		private var _levelIndex:int;
		
		private var bgBitmapData:BitmapData;
		
		private var sx:int = 100;
		private var sy:int = 100;
		
		public var isLocked:Boolean = false;
		
		public function RectGraphicButton(hasLevelIndexText:Boolean=false,bg:Bitmap=null,sizex:int=100,sizey:int=100)
		{
			mouseChildren = false;
			sx = sizex;
			sy = sizey;
			if (bg != null)
			{
				bgBitmapData = bg.bitmapData;
			}
			init();
			if(hasLevelIndexText)inittext();
		}
		
		public function setLevelAssociation(levelSelectorRef:LevelSelector,location:int,index:int):void
		{
			_levelSelectrorRef=levelSelectorRef;
			_levelLocation=location;
			_levelIndex=index;
			addEventListener(MouseEvent.CLICK, _levelSelectrorRef.onLevelSelect_Click);
			addEventListener(MouseEvent.MOUSE_OVER, _levelSelectrorRef.onLevelSelect_MouseOver);
			
			MouseEventManager.addElement(new MouseEventObject(this, MouseEvent.CLICK, _levelSelectrorRef.onLevelSelect_Click));
			MouseEventManager.addElement(new MouseEventObject(this, MouseEvent.MOUSE_OVER, _levelSelectrorRef.onLevelSelect_MouseOver));
		}
		
		public function get levelLocation():int
		{
			return _levelLocation;
		}
		
		public function get levelIndex():int
		{
			return _levelIndex;
		}
		
		public function setLocked(b:Boolean):void
		{
			isLocked = b;
			redraw();
		}// setLocked
		
		public function setLevelIndex(li:int):void
		{
			if (li<  10)
			{
				_etf.setText("0"+li);
			}
			else
			{
				_etf.setText(""+li);
			}
		}//setLevelIndex
		
		private var redrawMtr:Matrix = new Matrix();
		public function redraw(bg:Bitmap=null):void
		{
			if (bg != null)
			{
				bgBitmapData = bg.bitmapData;
			}
			graphics.clear();
			if (bgBitmapData != null)
			{
				graphics.beginBitmapFill(bgBitmapData, null, false, true);
			}
			else
			{
				graphics.beginFill(0x50ff50);
			}
			//
			graphics.drawRect(0,0,sx,sy);
			graphics.endFill();
			
			if (isLocked)
			{
				redrawMtr.a = sx / 100;
				redrawMtr.d = sy / 100;
				graphics.beginBitmapFill(lockImg.bitmapData, redrawMtr, false, true);
				graphics.drawRect(0, 0, sx, sy);
				graphics.endFill();
			}
			
		}
		
		
		
		private function init():void
		{
			if (bgBitmapData != null)
			{
				graphics.beginBitmapFill(bgBitmapData,null,false,true);
			}
			else
			{
				graphics.beginFill(0x50ff50);
			}
			//
			graphics.drawRect(0,0,sx,sy);
			graphics.endFill();
			//
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			addEventListener(Event.ENTER_FRAME,EnterFrame);
			//
			
			
			MouseEventManager.addElement(new MouseEventObject(this, MouseEvent.MOUSE_OVER, onMouseOver));
			MouseEventManager.addElement(new MouseEventObject(this, MouseEvent.MOUSE_OUT, onMouseOut));
			MouseEventManager.addElement(new MouseEventObject(this, MouseEvent.MOUSE_DOWN, onMouseDown));
			
		}//init
		
		private function inittext():void
		{
			_etf=new ExtText(0x000000,"Arial",50);
			_etf.setParams(25,25,100,100);
			_etf.setText("00");
			addChild(_etf);
		}
		
		private function onMouseDown(me:MouseEvent):void
		{
			SoundManager.playSound(SoundManager.SND_CLICK);
		}
		
		private function onMouseOver(me:MouseEvent):void
		{
			mouseOver=true;
		}
		
		private function onMouseOut(me:MouseEvent):void
		{
			mouseOver=false;
		}
		
		private function EnterFrame(e:Event):void
		{
			if(mouseOver)
			{
			
			//scaleX+=0.01;
			//_glow.strength++;
			}else{
			
			//_glow.strength--;	
			}
			
		}
		
	}//class
}