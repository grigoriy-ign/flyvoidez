package game 
{
	import criadone.utils.SimpleTracerPanel;
	import fl.controls.List;
	import flash.display.Stage;
	import flash.net.FileReference;
	import flash.text.TextFieldType;
	import game.editor.BonusWindowInteractivity;
	import game.editor.LibWindowInteractivity;
	import game.editor.TextureSelector;
	import game.editor.TextureSelectorWindow;
	import geom.P2d;
	import geom.Triangle;
	import gui.MouseEventManager;
	import gui.MouseEventObject;
	import gui.Window;
	import levels.LevelParser;
	import levels.PatternLib;
	import levels.UniqPatternLib;
	import objects.library.StaticGround;
	
	import display.Render;
	import display.RenderEditor;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	import game.editor.StaticGroundEditorWindow;
	import game.editor.TransformationTools;
	
	import gui.Button;
	import levels.LevelSaver;
	import objects.IngameObject;
	import resources.Resources;
	
	/**
	 * ...
	 * @author 
	 */
	public class LevelEditor extends Sprite
	{
		
		public static const TOOL_STATIC_GROUND:int=1;		
		public static const TOOL_LIBRARY:int=2;		
		public static const TOOL_BONUS:int=3;		
		
		public var stageRef:Main;
		
		// GUI
		
		private var _background:Sprite;						
		
		private var _menuToolButtons:Sprite;				
		private var _btnToolStaticGround:Button;			
		private var _btnToolLibrary:Button;			
		private var _btnToolBonus:Button;			
		
		private var _selectedTool:int=0;										
		
		private var _transTools:TransformationTools;		
		
		private var _staticGroundEditorWindow:StaticGroundEditorWindow;			
		private var _libraryWindow:LibWindow;
		private var _bonusWindow:BonusWindow;
		
		private var texSelector:TextureSelector=new TextureSelector();
		private var texturesWindow:TextureSelectorWindow;
		
		private var _propertiesWindow:PropertiesWindow;
		
		private var _levelSavingResultWindow:TextFieldWindow=new TextFieldWindow();
		private var _levelSavingResultWindowTextField:TextField;
		
		// open & edit
		private var openPatternButton:Button = new Button();
		private var openPatternWindow:Window = new Window();
		private var openPatternTextData:TextField = new TextField();
		
		
		// CONTROLS
		
		private var _mouseDown:Boolean=false;				
		private var _mouseMovingUp:Boolean=false;			
		
		private var mouseYPrev:Number = 0;					
		
		public var cameraScrollX:Number = 0;
		
		// BONUS
		public var bonusType:int = 1;
		public static var BONUS_STAR:int = 1;
		public static var BONUS_HEALTH:int = 2;
		public static var BONUS_TIME:int = 3;
		public static var BONUS_BOOST:int = 4;
		public static var BONUS_REVERSE:int = 5;
		public static var BONUS_RANDOM:int = 6;
		
		// DATA
		
		private var _currentLevelObjects:Array;				
		private var _currentLevelObjectsSaved:String;			
		private var _currentObject:IngameObject;				
		
		private var _selectedObjectIndex:int=0;				
		
		// __________________________________________________________________________________ PUBLIC
		
		public function LevelEditor() 
		{
			init();
		}
		
		public function get currentLevelObjects():Array
		{
			return _currentLevelObjects;
		}
		
		public function get selectedObject():IngameObject
		{
			return _currentObject;
		}
		
		//__________________________________________________________________________________ EVENTS
		
		private function updateFrame(e:Event):void
		{
			redrawBackground();					
			
			Render.viewport=_background;		
			Render.checkPoint.x=mouseX;			
			Render.checkPoint.y=mouseY;			
			
			Render.renderObjects(_currentLevelObjects,true,cameraScrollX);	
			

			
		}//updateFrame
		
		
		private function toolButtonStaticGround_Click(me:MouseEvent):void
		{
			_selectedTool=TOOL_STATIC_GROUND;
			showStaticGroundEditorWindow();
		}
		
		private function toolButtonLibrary_Click(me:MouseEvent):void
		{
			_selectedTool=TOOL_LIBRARY;
			_libraryWindow.visible=true;
		}
		
		private function toolButtonBonus_Click(me:MouseEvent):void
		{
			_selectedTool=TOOL_BONUS;
			_bonusWindow.visible=true;
		}
		
		
		private function onEditor_Click(me:MouseEvent):void
		{
			
			(_currentLevelObjects.length>0)
			{
				
				if(_transTools.currentTool==TransformationTools.TOOL_SELECT)
				{
				_selectedObjectIndex=Render.intersectionObjectIndex;		
				clearSelection();												
					try
					{
					_currentLevelObjects[_selectedObjectIndex].selected=true;	
					_currentObject=_currentLevelObjects[_selectedObjectIndex];
					updatePropertiesWindow();
					}
					catch(e:Error)
					{
					
					}
				}//if tool select
				
				if (_selectedTool == TOOL_BONUS)
				{
					
					//SimpleTracerPanel.traceString("place bonus: " + bonusType);
					
					var bonusObj:IngameObject = new StaticGround();
					bonusObj.points.push(new P2d( 0, 0));
					bonusObj.points.push(new P2d( 20, 0));
					bonusObj.points.push(new P2d( 20, 20));
					bonusObj.points.push(new P2d( 0, 20));
					bonusObj.triangles.push(new Triangle(0, 1, 2));
					bonusObj.triangles.push(new Triangle(0, 3, 2));
					
					bonusObj.isBonus = true;
					bonusObj.bonusType = bonusType;
					bonusObj.bitmapindex = 10+bonusType;
					bonusObj.mobility = false;
					bonusObj.position.x = me.stageX+cameraScrollX*2;
					bonusObj.position.y = me.stageY;
					bonusObj.rotation = 0;
					bonusObj.visible = true;
			
					currentLevelObjects.push(bonusObj);
				}// if tool bonus
				
			}// if length > 0
		}
		// end editor_Click
		
		
		private function onMouse_Down(me:MouseEvent):void
		{	
			_mouseDown=true;
			stage.focus=this;
			stage.stageFocusRect=false;
			focusRect=null;
		}
		
		
		private function onMouse_Up(me:MouseEvent):void
		{
			_mouseDown=false;
		}
		
		
		private function onMouse_Move(me:MouseEvent):void
		{
			
			
			if(mouseYPrev-mouseY>0)_mouseMovingUp=true else _mouseMovingUp=false;
			mouseYPrev=mouseY;
			//
			
			if(_currentLevelObjects.length>0)	//
			{
				_currentObject=_currentLevelObjects[_selectedObjectIndex];
				
				moveSelected();
				
				
				rotateSelected();
				
				
				scaleSelected();
				
			}// end
		}
		// end onMouse_Move
		
		private function onKeyDown(ke:KeyboardEvent):void
		{
			if(ke.keyCode==Keyboard.TAB)
			{
				saveLevel();
			}
			if(ke.keyCode==Keyboard.SPACE)_transTools.onSelect_Click(null);
			if(ke.keyCode==90)_transTools.onMove_Click(null);
			if(ke.keyCode==88)_transTools.onRotate_Click(null);
			if(ke.keyCode==67)_transTools.onScale_Click(null);
			if(ke.keyCode==81)_transTools.onDuplicate_Click(null);
			if (ke.keyCode == Keyboard.DELETE)_transTools.onRemove_Click(null);
			
			if (ke.keyCode == Keyboard.LEFT) scrollLevel( -10);
			if (ke.keyCode == Keyboard.RIGHT) scrollLevel( 10);
		}
		
		private function onWheel(me:MouseEvent):void
		{
			if (me.delta < 0)
			{
				if (_transTools.currentTool == TransformationTools.TOOL_SELECT) scrollLevel(-50);
				if (_transTools.currentTool == TransformationTools.TOOL_ROTATE) _currentObject.setRotation(_currentObject.rotation-5);
				if (_transTools.currentTool == TransformationTools.TOOL_SCALE) _currentObject.scale(0.95,0.95);
			}
			else
			{
				if (_transTools.currentTool == TransformationTools.TOOL_SELECT) scrollLevel( +50);
				if (_transTools.currentTool == TransformationTools.TOOL_ROTATE) _currentObject.setRotation(_currentObject.rotation + 5);
				if (_transTools.currentTool == TransformationTools.TOOL_SCALE) _currentObject.scale(1.05,1.05);
			}
		}//onWheel
		
		//_______________________________________________________________________________ PRIVATE
		
		private function init():void
		{
			//general
			_currentLevelObjects=new Array();
			//
			//background
			_background=new Sprite();
			_background.graphics.beginFill(0x202020);
			_background.graphics.drawRect(0,0,Main.appWidth,Main.appHeight);
			_background.graphics.endFill();
			addChild(_background);
			//menu tools
			_menuToolButtons=new Sprite();
			addChild(_menuToolButtons);
			// buttons - tools - static ground
			_btnToolStaticGround=new Button();
			_btnToolStaticGround.scaleX=_btnToolStaticGround.scaleY=0.5;
			_btnToolStaticGround.setText("Static Ground");
			_btnToolStaticGround.addEventListener(MouseEvent.CLICK, toolButtonStaticGround_Click);
			
			MouseEventManager.addElement(new MouseEventObject(_btnToolStaticGround, MouseEvent.CLICK, toolButtonStaticGround_Click));
			
			_menuToolButtons.addChild(_btnToolStaticGround);
			//
			_btnToolLibrary=new Button();
			_btnToolLibrary.scaleX=_btnToolLibrary.scaleY=0.5;
			_btnToolLibrary.setText("Objects Library");
			_btnToolLibrary.addEventListener(MouseEvent.CLICK, toolButtonLibrary_Click);
			
			MouseEventManager.addElement(new MouseEventObject(_btnToolLibrary, MouseEvent.CLICK, toolButtonLibrary_Click));
			
			_btnToolLibrary.y=30;
			_menuToolButtons.addChild(_btnToolLibrary);
			//
			_btnToolBonus=new Button();
			_btnToolBonus.scaleX=_btnToolBonus.scaleY=0.5;
			_btnToolBonus.setText("Bonus Objects");
			_btnToolBonus.addEventListener(MouseEvent.CLICK, toolButtonBonus_Click);
			
			MouseEventManager.addElement(new MouseEventObject(_btnToolBonus, MouseEvent.CLICK, toolButtonBonus_Click));
			
			_btnToolBonus.y=60;
			_menuToolButtons.addChild(_btnToolBonus);
			//
			
			_menuToolButtons.addChild(openPatternButton);
			openPatternButton.setText("Open");
			openPatternButton.scaleX = openPatternButton.scaleY = 0.5;
			openPatternButton.y = 90;
			openPatternButton.addEventListener(MouseEvent.MOUSE_DOWN, onOpenPatternClick);
			
			MouseEventManager.addElement(new MouseEventObject(openPatternButton, MouseEvent.MOUSE_DOWN, onOpenPatternClick));
			
			_menuToolButtons.x=30;
			_menuToolButtons.y=130;
			
			//	object manipulations
			_transTools=new TransformationTools();
			_transTools.x=50;
			_transTools.y=450;
			_transTools.editroRef=this;
			addChild(_transTools);
			
			texturesWindow=new TextureSelectorWindow(texSelector);
			
			//	properties widow
			_propertiesWindow=new PropertiesWindow();
			_propertiesWindow.x=730;
			_propertiesWindow.y=50;
			addChild(_propertiesWindow);
			_propertiesWindow.addEventListener(MouseEvent.CLICK, onPropertiesClick);
			texSelector.addEventListener(MouseEvent.CLICK, onBitmapSelector_Click);
			
			MouseEventManager.addElement(new MouseEventObject(_propertiesWindow, MouseEvent.CLICK, onPropertiesClick));
			MouseEventManager.addElement(new MouseEventObject(texSelector, MouseEvent.CLICK, onBitmapSelector_Click));
			
			_propertiesWindow.addChild(texSelector);
			texSelector.x=28;
			texSelector.y=28;
			texSelector.texturesSelWindowRef=texturesWindow;
			texSelector.levelEditorRef=this;
			texturesWindow.visible=false;
			texturesWindow.x=400;
			texturesWindow.y=250;
			addChild(texturesWindow);
			
			// bitmap selector init
			
			
			//	static ground editor window
			_staticGroundEditorWindow = new StaticGroundEditorWindow();
			_staticGroundEditorWindow.levelEditorRef = this;
			addChild(_staticGroundEditorWindow);
			_staticGroundEditorWindow.visible=false;
			_staticGroundEditorWindow.levelEditorRef=this;
			
			//	library window
			_libraryWindow=new LibWindow();
			addChild(_libraryWindow);
			_libraryWindow.x=Main.appWidth/2;
			_libraryWindow.y=Main.appHeight/2;
			_libraryWindow.visible=false;
			
			//	bonus window
			_bonusWindow=new BonusWindow();
			addChild(_bonusWindow);
			_bonusWindow.x=Main.appWidth/2;
			_bonusWindow.y=Main.appHeight/2;
			_bonusWindow.visible=false;
			BonusWindowInteractivity.bonusWindow=_bonusWindow;
			BonusWindowInteractivity.init();
			BonusWindowInteractivity.editorRef = this;
			
			LibWindowInteractivity.libWindow=_libraryWindow;
			LibWindowInteractivity.init();
			LibWindowInteractivity.levelEditorRef = this;
			
			addChild(openPatternWindow);
			openPatternWindow.y = Main.appHeight / 2;
			openPatternWindow.addChild(openPatternTextData);
			
			openPatternTextData.type = TextFieldType.INPUT;
			openPatternTextData.width = 500;
			openPatternTextData.height = 300;
			openPatternTextData.multiline = true;
			openPatternTextData.border = true;
			openPatternTextData.background = true;
			openPatternTextData.x = 0 - openPatternTextData.width / 2;
			openPatternTextData.y = 0 - openPatternTextData.height / 2;
			openPatternWindow.closeBtnRef.addEventListener(MouseEvent.MOUSE_DOWN, onOpenPatternDown);
			
			MouseEventManager.addElement(new MouseEventObject(openPatternWindow.closeBtnRef, MouseEvent.MOUSE_DOWN, onOpenPatternDown));
			
			// level saving result
			addChild(_levelSavingResultWindow);
			_levelSavingResultWindow.x=Main.appWidth/2;
			_levelSavingResultWindow.y=Main.appHeight/2;
			_levelSavingResultWindow.visible=false;
			var levelSavingOkButton:DisplayObject=_levelSavingResultWindow.getChildByName("okButton");
			levelSavingOkButton.addEventListener(MouseEvent.CLICK, saveLevelOk_Click);
			
			MouseEventManager.addElement(new MouseEventObject(levelSavingOkButton, MouseEvent.CLICK, saveLevelOk_Click));
			
			_levelSavingResultWindowTextField=_levelSavingResultWindow.getChildByName("text_content") as TextField;
			_levelSavingResultWindowTextField.multiline=true;
			
			// EVENTS
			_background.addEventListener(MouseEvent.CLICK, onEditor_Click);
			_background.addEventListener(MouseEvent.MOUSE_MOVE, onMouse_Move);
			_background.addEventListener(MouseEvent.MOUSE_DOWN, onMouse_Down);
			_background.addEventListener(MouseEvent.MOUSE_UP, onMouse_Up);
			_background.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			
			MouseEventManager.addElement(new MouseEventObject(_background, MouseEvent.CLICK, onEditor_Click));
			MouseEventManager.addElement(new MouseEventObject(_background, MouseEvent.MOUSE_MOVE, onMouse_Move));
			MouseEventManager.addElement(new MouseEventObject(_background, MouseEvent.MOUSE_DOWN, onMouse_Down));
			MouseEventManager.addElement(new MouseEventObject(_background, MouseEvent.MOUSE_UP, onMouse_Up));
			MouseEventManager.addElement(new MouseEventObject(_background, MouseEvent.MOUSE_WHEEL, onWheel));
			
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(Event.ENTER_FRAME, updateFrame);
			//
		}
		
		/
		private function onOpenPatternClick(me:MouseEvent):void
		{
			
			if (openPatternWindow.opening)
			{
				// close
				openPatternWindow.hide(1500);
			}
			else
			{
				// open
				openPatternWindow.show(Main.appWidth / 2);
			}
			
		}// onOpenPatternClick
		
		// calling when you clicking "OK" in the open pattern window
		// method opens pattern and adds it to the editor. so i can edit pattern.
		private function onOpenPatternDown(me:MouseEvent):void
		{
			
			if ((openPatternTextData.text != null) || (openPatternTextData.text != ""))
			{	
				var mode:String = "uniq"; // stan
				var first:String = openPatternTextData.text.charAt(0);
				if (first == "-") mode = "uniq" else mode = "stan";
				var ind:int = Math.abs(int(openPatternTextData.text));
				_currentLevelObjects = [];
			
			if (mode == "uniq")
			{
				LevelParser.parseLevel(UniqPatternLib.getPattern(ind), _currentLevelObjects, 0);
			}
			else
			{
				LevelParser.parsePattern(PatternLib.getPattern(ind).objects, _currentLevelObjects, 0);
			}
			
			}//end if
			
		}// onOpenPatternDown
		
		
		
		private function saveLevel():void
		{
			var start:int=getTimer();
			SimpleTracerPanel.traceString("Save Level Start");
			_levelSavingResultWindow.visible=true;
			//_levelSavingResultWindowTextField.text=LevelSaver.savePattern(_currentLevelObjects,_currentLevelObjectsSaved);	// saving std pattern
			_levelSavingResultWindowTextField.text=LevelSaver.saveLevel(_currentLevelObjects,_currentLevelObjectsSaved);		// saving unique pattern
			SimpleTracerPanel.traceString("Save Level Finished "+(getTimer()-start)+" ms");
		}
		
		private function saveLevelOk_Click(me:MouseEvent):void
		{
			_levelSavingResultWindow.visible = false;
			var fref:FileReference = new FileReference();
			fref.save(_levelSavingResultWindowTextField.text, "level"+Math.random()+".txt");
		}
		
		
		private function redrawBackground():void
		{
			_background.graphics.clear();
			_background.graphics.beginFill(0x202020);
			_background.graphics.drawRect(0,0,Main.appWidth,Main.appHeight);
			_background.graphics.endFill();
		}
		
		
		private function showStaticGroundEditorWindow():void
		{
			_staticGroundEditorWindow.show();
			_staticGroundEditorWindow.x=(Main.appWidth/2)-(_staticGroundEditorWindow.width/2);
			_staticGroundEditorWindow.y=(Main.appHeight/2)-(_staticGroundEditorWindow.height/2);
		}
		
		
		private function clearSelection():void
		{
			for(var i:int=0;i< _currentLevelObjects.length;i++)
			{
				_currentLevelObjects[i].selected=false;
			}
		}
		
		
		private function onPropertiesClick(me:MouseEvent):void
		{
			try
			{
				if(_propertiesWindow.isDynamicChecker.checked)
				{
					_currentObject.mobility=true;
					_currentObject.positionSecond.x=parseFloat(_propertiesWindow.sposX.text);
					_currentObject.positionSecond.y=parseFloat(_propertiesWindow.sposY.text);
					_currentObject.movingSpeed=parseFloat(_propertiesWindow.sp.text);
					_currentObject.rotatingSpeed=parseFloat(_propertiesWindow.rsp.text);
				}
				else
				{
					_currentObject.mobility=false;
				}
				
				_currentObject.position.x=parseFloat(_propertiesWindow.posX.text);
				_currentObject.position.y=parseFloat(_propertiesWindow.posY.text);
			
			}
			catch(e:Error)
			{
				
			}
		}
		
		private function onBitmapSelector_Click(me:MouseEvent):void
		{
			if(Main.debug)SimpleTracerPanel.traceString("onBitmapSelector_Click");
			if(texturesWindow.visible)
			{
				texturesWindow.visible=false;
			}
			else
			{
				texturesWindow.visible=true;
			}
		}
		
		
		private function updatePropertiesWindow():void
		{
			try
			{
			_propertiesWindow.posX.text=String(_currentObject.position.x);
			_propertiesWindow.posY.text=String(_currentObject.position.y);
			_propertiesWindow.sposX.text=String(_currentObject.positionSecond.x);
			_propertiesWindow.sposY.text=String(_currentObject.positionSecond.y);
			_propertiesWindow.sp.text=String(_currentObject.movingSpeed);
			_propertiesWindow.rsp.text=String(_currentObject.rotatingSpeed);
			
			if(_currentObject.mobility)
			{
				_propertiesWindow.isDynamicChecker.check();
			}
			else
			{
				_propertiesWindow.isDynamicChecker.uncheck();
			}
			
			if(_propertiesWindow.isDynamicChecker.checked)
			{
				_propertiesWindow.sposX.visible=true;
				_propertiesWindow.sposY.visible=true;
				_propertiesWindow.sp.visible=true;
				_propertiesWindow.rsp.visible=true;
			}
			else
			{
				_propertiesWindow.sposX.visible=false;
				_propertiesWindow.sposY.visible=false;
				_propertiesWindow.sp.visible=false;
				_propertiesWindow.rsp.visible=false;
			}
			
			}
			catch(e:Error)
			{
				
			}
		}
		
		// scrolls level from left to right
		public function scrollLevel(dir:int = 1):void
		{
			cameraScrollX += dir;
		}//scrollLevel
		
		
		private function moveSelected():void
		{
			if((_mouseDown)&&(_transTools.currentTool==TransformationTools.TOOL_MOVE))
			{
				_currentObject.position.x=mouseX+cameraScrollX*2;
				_currentObject.position.y=mouseY;
				updatePropertiesWindow();
			}
		}
		
		
		private function rotateSelected():void
		{
			if((_mouseDown)&&(_transTools.currentTool==TransformationTools.TOOL_ROTATE))
			{
				updatePropertiesWindow();
			if(_mouseMovingUp)
				{
					_currentObject.setRotation(_currentObject.rotation-1);
				}
				else
				{
					_currentObject.setRotation(_currentObject.rotation+1);
				}
			}
		}
		
		
		private function scaleSelected():void
		{
			if((_mouseDown)&&(_transTools.currentTool==TransformationTools.TOOL_SCALE))
				{
					updatePropertiesWindow();
					if(_mouseMovingUp)
					{
						_currentObject.scale(1.02,1.02);
					}
					else
					{
						_currentObject.scale(0.98,0.98);
					}
				}
		}//		scale selected
		
		public function duplicateSelected():void
		{
			if(_currentObject!=null)
			{
			var dupObject:IngameObject=new StaticGround();
			
			for(var i:int=0;i< _currentObject.points.length;i++)
			{
				var curpoint:P2d=_currentObject.points[i];
				dupObject.points.push(new P2d(curpoint.x,curpoint.y));
			}
			
			for(i=0;i<  _currentObject.triangles.length;i++)
			{
				var curtri:Triangle=_currentObject.triangles[i];
				dupObject.triangles.push(new Triangle(curtri.p1,curtri.p2,curtri.p3));
			}
			
			dupObject.bitmapindex=_currentObject.bitmapindex;
			dupObject.mobility=_currentObject.mobility;
			dupObject.position.x=_currentObject.position.x+30;
			dupObject.position.y=_currentObject.position.y+30;
			dupObject.rotation=_currentObject.rotation;
			dupObject.visible=_currentObject.visible;
			
			currentLevelObjects.push(dupObject);
			}// if current object != null
			
		}//		duplicate selected
		
		public function removeSelected():void
		{
			try
			{
				currentLevelObjects.splice(_selectedObjectIndex,1);
				clearSelection();												
			}
			catch(e:Error)
			{
				
			}
		}
		
	}//class
}//pack