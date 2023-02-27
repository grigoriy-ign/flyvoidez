package gui 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import resources.Resources;
	/**
	 * ...
	 * @author 
	 */
	public class Window extends Sprite
	{
		
		private var _showing:Boolean=false;
		private var _showx:int=0;
		private var _hidex:int=1500;
		private var _spd:Number = 5;
		
		private var _drwMatrix:Matrix;
		
		private var i:int=0;
		
		public var _closeButton:Button;
		
		public var opening:Boolean = false;
		
		public var closeBtnRef:Button;
		
		public function Window() 
		{
			init();
		}
		
		public function show(n:int):void
		{
			_showing=true;
			_showx = n;
			opening = true;
		}
		
		public function hide(n:int):void
		{
			_showing=false;
			_hidex = n;
			opening = false;
		}
		
		public function setBackButtonCaption(str:String):void
		{
			_closeButton.setText(str);
		}
		
		
		
		
		private function update(e:Event):void
		{
			if(_showing)
			{
				visible = true;
				for(i=0;i<10;i++)
				{
					if(x>_showx)x-=_spd;
				}
			}
			else
			{
				for(i=0;i<10;i++)
				{
					if (x < _hidex)
					{
						x+=_spd;
					}
					else
					{
						visible = false;
					}
				}
			}
		}
		
		
		private function init():void
		{
			_drwMatrix=new Matrix();
			_drwMatrix.tx=650/2;
			_drwMatrix.ty=398/2;
			graphics.beginBitmapFill(Resources.gradient_background_Bitmap.bitmapData,_drwMatrix,true,false);
			graphics.drawRoundRect(-650/2,-398/2,650,398,10,10);
			graphics.endFill();
			//
			addEventListener(Event.ENTER_FRAME,update);
			x=_hidex;
			//
			_closeButton=new Button();
			_closeButton.setText("OK");
			_closeButton.x=-_closeButton.width/2*0.7;
			_closeButton.y=150;
			_closeButton.scaleX=_closeButton.scaleY=0.7;
			addChild(_closeButton);
			_closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			//
			
			MouseEventManager.addElement(new MouseEventObject(_closeButton, MouseEvent.CLICK, onCloseClick));
			
			closeBtnRef = _closeButton;
		}
		
		
		private function onCloseClick(me:MouseEvent):void
		{
			hide(_hidex);
		}
		
	}
}