package game.editor 
{
	import criadone.utils.SimpleTracerPanel;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import game.LevelEditor;
	import geom.Triagulation;
	import gui.MouseEventManager;
	import gui.MouseEventObject;
	import gui.RectGraphicButton;
	import math.MinMax;
	import objects.library.StaticGround;
	import resources.Resources;
	
	/**
	 * ...
	 * @author 
	 */
	public class StaticGroundEditorWindow extends Sprite
	{
		
		private var _buttonOk:RectGraphicButton;
		
		private var _drawingObject:StaticGround;
		
		private var _drawingObjectDisplay:Sprite;
		private var _drawingObjectString:String;
		
		private var _points:Array;
		private var _firstPoint:Boolean=true;
		
		private var _maxX:Number;
		private var _minX:Number;
		private var _maxY:Number;
		private var _minY:Number;
		
		public var levelEditorRef:LevelEditor;
		
		public function StaticGroundEditorWindow() 
		{
			init();
		}
		
		public function show():void
		{
			_drawingObject=new StaticGround();
			_firstPoint=true;
			//_drawingObjectDisplay.graphics
			//
			visible=true;
			_drawingObjectDisplay.graphics.lineStyle(1,0xff0000,1);
			//_drawingObjectDisplay.graphics.beginFill(0x000000);
		}
		
		public function hide(accept:Boolean):void
		{
			if(accept)
			{
				if(_drawingObject.points.length>2)
				{
				levelEditorRef.currentLevelObjects.push(_drawingObject);
				Triagulation.triangulate(_drawingObject.points,_drawingObject.triangles);
				//
				// centralize object - fisrt. find min x,y & max x,y
				_maxX=MinMax.maxX_VectorP2d(_drawingObject.points);
				_maxY=MinMax.maxY_VectorP2d(_drawingObject.points);
				_minX=MinMax.minX_VectorP2d(_drawingObject.points);
				_minY=MinMax.minY_VectorP2d(_drawingObject.points);
				// move vertices
				for(var i:int=0;i< _drawingObject.points.length;i++)
				{
					_drawingObject.points[i].x-=(_maxX-_minX)/2+_minX;
					_drawingObject.points[i].y-=(_maxY-_minY)/2+_minY;
				}
				_drawingObject.position.x=Main.appWidth/2+levelEditorRef.cameraScrollX*2;
				_drawingObject.position.y = Main.appHeight / 2;
				
				SimpleTracerPanel.traceString(""+_drawingObject.position.x.toFixed(1)+" "+levelEditorRef.cameraScrollX.toFixed(1));
				//
				}
			}
			else
			{
				
			}
			_drawingObjectDisplay.graphics.clear();
			//
			visible=false;
		}
		
		// ________________________________________________________________________-- EVENTS
		
		private function onButtonOk_Click(me:MouseEvent):void
		{
			hide(true);
		}
		
		private function onMouseClick(me:MouseEvent):void
		{
			// draw
			if(me.target!=_buttonOk)
			{
			if(_firstPoint)
			{
				_drawingObjectDisplay.graphics.moveTo(me.localX,me.localY);
				_drawingObjectDisplay.graphics.drawCircle(me.localX,me.localY,2);
			}
			else
			{
				_drawingObjectDisplay.graphics.lineTo(me.localX,me.localY);
				_drawingObjectDisplay.graphics.drawCircle(me.localX,me.localY,2);
			}
			_drawingObject.addPoint(me.localX,me.localY);
			//
			_firstPoint=false;
			//
			}
		}
		
		
		// ________________________________________________________________________-- PRIVATE
		
		private function init():void
		{
			_points=new Array();
			graphics.beginFill(0xffffff);
			/*var btm:Bitmap = new Resources.player_image();
			graphics.beginBitmapFill(btm.bitmapData, null, true, false);*/
			graphics.drawRect(0,0,500,400);
			graphics.endFill();
			
			graphics.lineStyle(1, 0x000000, 1);
			for (var i:int = 0; i < 10; i++)
			{
				graphics.moveTo(0, (400 / 10) * i);
				graphics.lineTo(500, (400 / 10) * i);
			}
			for (i = 0; i < 10; i++)
			{
				graphics.moveTo((500 / 10) * i, 0);
				graphics.lineTo((500 / 10) * i, 400);
			}
			
			
			addEventListener(MouseEvent.CLICK,onMouseClick);
			//ok
			_buttonOk=new RectGraphicButton();
			_buttonOk.scaleX=_buttonOk.scaleY=0.3;
			_buttonOk.addEventListener(MouseEvent.CLICK, onButtonOk_Click);
			addChild(_buttonOk);
			//
			_drawingObjectDisplay = new Sprite();
			addChild(_drawingObjectDisplay);
			//
			
			MouseEventManager.addElement(new MouseEventObject(this, MouseEvent.CLICK, onMouseClick));
			MouseEventManager.addElement(new MouseEventObject(_buttonOk, MouseEvent.CLICK, onButtonOk_Click));
			
		}
		
	}
}