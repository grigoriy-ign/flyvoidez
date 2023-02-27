package game.editor 
{
	/**
	 * ...
	 * @author 
	 */
	
	import criadone.utils.SimpleTracerPanel;
	import display.Render;
	import fl.controls.List;
	import fl.controls.listClasses.CellRenderer;
	import fl.data.DataProvider;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import game.LevelEditor;
	import gui.MouseEventManager;
	import gui.MouseEventObject;
	import levels.LevelParser;
	import objects.Lib;
	import objects.LibObjectInfo;
	import objects.library.StaticGround;
	 
	public class LibWindowInteractivity
	{
		
		public static const CAT_SIDES:int=1;
		public static const CAT_BOX:int=2;
		public static const CAT_WALL:int=3;
		
		public static var libWindow:LibWindow;
		public static var levelEditorRef:LevelEditor;
		
		private static var _db:DataProvider;
		private static var _objlist:List;
		private static var _objInfoArray:Array;
		
		private static var _canvas:Sprite;
		
		private static var _curLibObjInfo:LibObjectInfo;
		
		private static var _displaySelectedStaticObj:StaticGround;
		
		private static var _okbutton:EditorButton;
		
		public static function init():void
		{
			_objlist=libWindow.list;
			//
			_db=new DataProvider();
			_objInfoArray=new Array();
			
			_objlist.dataProvider=_db;
			_objlist.addEventListener(MouseEvent.CLICK,onList_Click);
			//
			_canvas=libWindow.getChildByName("canvas") as Sprite;
			_okbutton=libWindow.getChildByName("okbutton") as EditorButton;
			
			_okbutton.addEventListener(MouseEvent.CLICK, onOk_Click);
			
			libWindow.getChildByName("b1").addEventListener(MouseEvent.MOUSE_DOWN, onB1Down);
			libWindow.getChildByName("b2").addEventListener(MouseEvent.MOUSE_DOWN, onB2Down);
			libWindow.getChildByName("b3").addEventListener(MouseEvent.MOUSE_DOWN, onB3Down);
			
			MouseEventManager.addElement(new MouseEventObject(_objlist, MouseEvent.CLICK, onList_Click));
			MouseEventManager.addElement(new MouseEventObject(_okbutton, MouseEvent.CLICK, onOk_Click));
			
			MouseEventManager.addElement(new MouseEventObject(libWindow.getChildByName("b1"), MouseEvent.MOUSE_DOWN, onB1Down));
			MouseEventManager.addElement(new MouseEventObject(libWindow.getChildByName("b2"), MouseEvent.MOUSE_DOWN, onB2Down));
			MouseEventManager.addElement(new MouseEventObject(libWindow.getChildByName("b3"), MouseEvent.MOUSE_DOWN, onB3Down));
			
			_displaySelectedStaticObj=new StaticGround();
			
			fillLabel(CAT_SIDES);
			
		}
		
		private static function onB1Down(me:MouseEvent):void
		{
			fillLabel(CAT_SIDES);
		}
		
		private static function onB2Down(me:MouseEvent):void
		{
			fillLabel(CAT_BOX);
		}
		
		private static function onB3Down(me:MouseEvent):void
		{
			fillLabel(CAT_WALL);
		}
		
		private static function onB4Down(me:MouseEvent):void
		{
			//fillLabel(CAT_BOX);
		}
		
		private static function onB5Down(me:MouseEvent):void
		{
			//fillLabel(CAT_BOX);
		}
		
		private static function onB6Down(me:MouseEvent):void
		{
			//fillLabel(CAT_BOX);
		}
		
		public static function fillLabel(cat:int):void
		{
			switch (cat) 
			{
				case CAT_SIDES:
				fillList(Lib.sides);
				break;
				
				case CAT_BOX:
				fillList(Lib.boxes);
				break;
				
				case CAT_WALL:
				fillList(Lib.walls);
				break;
				
				default:
			}
		}
		// end fill label
		
		// ____________________________________________________________________________ EVENTS
		
		private static function onList_Click(me:MouseEvent):void
		{
			var clicked:CellRenderer = me.target as CellRenderer;
			var clickedStr:String = clicked.data.label;
			
			var ind:int=clicked.data.index;
			
			_curLibObjInfo=_objInfoArray[ind];
			
			// parsing
			_displaySelectedStaticObj=LevelParser.parseStaticGround(_curLibObjInfo.strdata);
			// drawing
			_canvas.graphics.clear();
			Render.renderSingleObject(_canvas, _displaySelectedStaticObj);
			//
		}// onList_Click
		
		private static function onOk_Click(me:MouseEvent):void
		{
			_displaySelectedStaticObj.position.x=Main.appWidth/2+levelEditorRef.cameraScrollX*2;
			_displaySelectedStaticObj.position.y=Main.appHeight/2;
			levelEditorRef.currentLevelObjects.push(_displaySelectedStaticObj);
		}
		
		
		// ____________________________________________________________________________ PRIVATE
		
		private static function fillList(arr:Array):void
		{
				_db.removeAll();
				
			for (var i:int = 0; i < arr.length; i++)
			{
				_curLibObjInfo=arr[i];
				_db.addItem({index:i,label:_curLibObjInfo.objName});
			}
			
			_objInfoArray=arr;
			
			//
		}
		
	}
}