package gui 
{
	import criadone.utils.SimpleTracerPanel;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class BlackStripes extends Sprite
	{
		/*
		
		private var _up:Sprite;
		private var _down:Sprite;
		
		private var _closeState:int=3;
		
		public var spd:Number=5;
		
		public var closedFull:Boolean=false;
		
		public function BlackStripes() 
		{
			init();
			addEventListener(Event.ENTER_FRAME, updateFrame);
		}
		
		public function closeFull():void
		{
			SimpleTracerPanel.traceString("close full call");
			_closeState=3;
		}
		
		public function closePart():void
		{
			_closeState=2;
		}
		
		public function closeNone():void
		{
			_closeState=1;
		}
		
		// ___________________________________________________________________________- EVENTS
		
		private function updateFrame(e:Event):void
		{
			
			SimpleTracerPanel.traceString("update frame call ");
			if(_closeState==3) // FULL
			{
				if(_up.height<250)
				{
					SimpleTracerPanel.traceString("1");
					_up.height+=spd;
					closedFull=false;
				}
				else
				{
					SimpleTracerPanel.traceString("2");
					closedFull=true;
					_up.height=245;
				}
				
				if(_down.height<250)
				{
					SimpleTracerPanel.traceString("3");
					_down.height+=spd;
					closedFull=false;
				}
				else
				{
					SimpleTracerPanel.traceString("4");
					closedFull=true;
					_down.height=245;
				}
			}
			SimpleTracerPanel.traceString("closedFull "+closedFull);
			
			if(_closeState==2) // PART
			{
				closedFull=false;
				if(_up.height<50-spd)_up.height+=spd;
				if(_up.height>50+spd)_up.height-=spd;
				if((_up.height>50-spd)&&(_up.height<50+spd))_up.height=50;
				
				if(_down.height<50-spd)_down.height+=spd;
				if(_down.height>50+spd)_down.height-=spd;
				if((_down.height>50-spd)&&(_down.height<50+spd))_down.height=50;
			}
			
			if(_closeState==1) // NONE
			{
				closedFull=false;
				if(_up.height>0)_up.height-=spd;
				if(_down.height>0)_down.height-=spd;
			}
			
			
		}//updateFrame end
		
		// ___________________________________________________________________________- PRIVATE
		
		private function init():void
		{
			_up=new Sprite();
			_down=new Sprite();
			
			_up.graphics.beginFill(0x000000);
			_up.graphics.drawRect(0,0,Main.appWidth,250);
			_up.graphics.endFill();
			
			_down.graphics.beginFill(0x000000);
			_down.graphics.drawRect(0,0,Main.appWidth,-250);
			_down.graphics.endFill();
			
			//_down.scaleY=-1;
			_down.y=500;
			
			addChild(_up);
			addChild(_down);
		}
		*/
		
	}
}