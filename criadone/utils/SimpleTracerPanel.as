package criadone.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import gui.MouseEventManager;

	public class SimpleTracerPanel
	{
		
		/**
		 * adds panel for info output
		 * @param	container
		 */
		public static function create(container:DisplayObjectContainer):void
		{
			_containerRef = container;
			createPanel();
			container.addChild(_panel);
		}
		
		/**
		 * outputs string
		 * @param	str
		 */
		public static function traceString(str:String):void
		{
			_mainTf.appendText(str + "\n");
			_mainTf.scrollV = _mainTf.maxScrollV;
			if (_mainTf.text.length > _limit)_mainTf.text = "";
		}
		
		/**
		 * outputs array
		 * @param	array
		 */
		public static function traceArray(array:Array):void
		{
			for (var i:int = 0; i < array.length; i++)
			{
				_mainTf.appendText("[" + i + "] " + array[i] + "\n");
				if (_mainTf.text.length > _limit)_mainTf.text = "";
			}
			_mainTf.scrollV = _mainTf.maxScrollV;
		}
		
		/**
		 * set position
		 * @param	x
		 * @param	y
		 */
		public static function setPosition(x:Number, y:Number):void
		{
			_panel.x = x;
			_panel.y = y;
		}
		
		/**
		 * set window size
		 * @param	width
		 * @param	height
		 */
		public static function setSize(width:Number, height:Number):void
		{
			_header.width = width;
			_background.width = width;
			_mainTf.width = width-20;
			_background.height = height;
			_mainTf.height = height - 20;
			_size.x = width - 20;
			_size.y = height - 20;
		}
		
		/**
		 * set transparency
		 * @param	a
		 */
		public static function setAlpha(a:Number):void
		{
			if (a > 1) a = 1;
			if (a < 0) a = 0;
			_panel.alpha = a;
		}
		
		/**
		 * sets symbol limit to clear window
		 * @param	limit
		 */
		public static function setSymbolLimit(limit:int):void
		{
			_limit = limit;
		}
		
		
		
		private static var _containerRef:DisplayObjectContainer;	// container
		
		private static var _panel:Sprite;		// panel
		private static var _background:Shape;	// panel bg
		private static var _header:Sprite;		// top line
		private static var _minimize:Sprite;	// minimize button
		private static var _size:Sprite;		// size change button
		private static var _mainTf:TextField;	// text input field
		
		private static var _limit:int = 10000;				// symbol limit
		
		private static var _isMinimized:Boolean = false;	// is pamel minimized
		private static var _isCreated:Boolean = false;		// is create() method called
		private static var _changingSize:Boolean = false;	// is size changing
		
		private static var _mainContextMenu:ContextMenu;						// main context menu
		private static var _mainContextMenuItemsArray:Array;					// menu items array
		private static var _mainContextMenu_itemSaveTextFile:ContextMenuItem;	// "save file" menu item
		
		private static var _fileRef:FileReference;								// file reference for saving files
		
		/**
		 * draws panel for info output
		 */
		private static function createPanel():void
		{
			if (!_isCreated)
			{
			_panel = new Sprite();
			_background = new Shape();
			_header = new Sprite();
			_minimize = new Sprite();
			_size = new Sprite();
			// bg
			var panelGraphics:Graphics = _background.graphics;
			panelGraphics.beginFill(0x505050, 1);
			panelGraphics.drawRect(0, 0, 100, 100);
			panelGraphics.endFill();
			_panel.addChild(_background);
			// top line
			panelGraphics = _header.graphics;
			panelGraphics.beginFill(0x404040, 1);
			panelGraphics.drawRect(0, 0, 100, 20);
			panelGraphics.endFill();
			_panel.addChild(_header);
			_header.addEventListener(MouseEvent.MOUSE_DOWN, onHeader_down);
			_header.addEventListener(MouseEvent.MOUSE_UP, onHeader_up);
			// minimize button
			panelGraphics = _minimize.graphics;
			panelGraphics.beginFill(0x606060, 1);
			panelGraphics.drawRect(0, 0, 20, 20);
			panelGraphics.endFill();
			_panel.addChild(_minimize);
			_minimize.buttonMode = true;
			_minimize.addEventListener(MouseEvent.CLICK, onMinimize_click);
			// size change button
			//panelGraphics = _size.graphics;
			panelGraphics.beginFill(0x606060, 1);
			panelGraphics.drawRect(0, 0, 20, 20);
			panelGraphics.endFill();
			_panel.addChild(_size);
			_size.addEventListener(MouseEvent.MOUSE_DOWN, onSize_down);
			_size.addEventListener(MouseEvent.MOUSE_UP, onSize_up);
			_containerRef.stage.addEventListener(MouseEvent.MOUSE_MOVE, onSize_move);
			_size.x = 80;
			_size.y = 80;
			//
			// text field
			_mainTf = new TextField();
			_mainTf.width = 100;
			_mainTf.height = 80;
			_mainTf.border = false;
			var tf:TextFormat = new TextFormat("Arial", 10, 0xffffff);
			_mainTf.setTextFormat(tf);
			_mainTf.defaultTextFormat = tf;
			_mainTf.text = "Player: "+Capabilities.version;
			_panel.addChild(_mainTf);
			_mainTf.y = 20;
			//
			
			// context menu
			_mainContextMenu = new ContextMenu();
			_mainContextMenuItemsArray = new Array();
			
			_mainContextMenu_itemSaveTextFile = new ContextMenuItem("Save Text", false, true, true);
			_mainContextMenu_itemSaveTextFile.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onSaveFile_Click);
			
			_mainContextMenuItemsArray.push(_mainContextMenu_itemSaveTextFile);
			_mainContextMenu.customItems=_mainContextMenuItemsArray;
			_panel.contextMenu = _mainContextMenu;
			//
			
			//file reference
			_fileRef = new FileReference();
			
			//
			}
			
			_isCreated = true;
			//
		}
		//end createPanel
		
		
		private static function onMinimize_click(me:MouseEvent):void
		{
			
			if (_isMinimized)
			{
				_background.visible = true;
				_header.visible = true;
				_mainTf.visible = true;
				_size.visible = true;
				_isMinimized = false;
			}
			else
			{
				_background.visible = false;
				_header.visible = false;
				_mainTf.visible = false;
				_size.visible = false;
				_isMinimized = true;
			}
			
		}
		// end onMinimize_click
		
		
		private static function onHeader_down(me:MouseEvent):void
		{
			_panel.startDrag();
		}
		
		
		private static function onHeader_up(me:MouseEvent):void
		{
			_panel.stopDrag();
		}
		
		
		private static function onSize_down(me:MouseEvent):void
		{
			_size.startDrag();
			_changingSize = true;
		}
		
		
		private static function onSize_up(me:MouseEvent):void
		{
			_size.stopDrag();
			_changingSize = false;
		}
		
		
		private static function onSize_move(me:MouseEvent):void
		{
			if (_changingSize)
			{
				var sx:Number = _size.x + 20;
				var sy:Number = _size.y + 20;
				if (sx < 40) 
				{
					sx = 40;
					_size.stopDrag();
					_changingSize = false;
				}
				if (sy < 40)
				{
					sy = 40;
					_size.stopDrag();
					_changingSize = false;
				}
				setSize(sx, sy);
			}
		}
		
		
		private static function onSaveFile_Click(ce:ContextMenuEvent):void
		{
			_fileRef.save(_mainTf.text, "traced_text.txt");
		}
		
	}
	
}