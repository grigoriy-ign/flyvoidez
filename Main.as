package 
{
	import criadone.utils.SimpleTracerPanel;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import game.Gameplay;
	import game.LevelEditor;
	import geom.P2d;
	import gui.BlackStripes;
	import gui.MainMenu;
	import gui.MainMenuBackground;
	import gui.MouseEventManager;
	import net.hires.debug.Stats;
	import objects.LibObjectsConverter;
	import resources.Resources;
	
	/**
	 * ...
	 * @author
	 */
	public class Main extends Sprite
	{
		
		public static var debug:Boolean=false;
		
		public static var initLevelEditor:Boolean=true;
		
		public var blackStripes:BlackStripes;
		
		private var _levelEditor:LevelEditor;
		private var _mainBackground:MainMenuBackground;
		private var _mainMenu:MainMenu;
		private var _mainGameplay:Gameplay;
		
		private var _blackStripes:BlackStripes;
		
		public static var appWidth:int = 700;
		public static var appHeight:int = 500;
		
		public static var helpShown:Boolean = false;
		
		public static var blackSprite:Sprite;
		public static var isShowBlackFg:Boolean = false;
		
		public static var mainMask:Sprite = new Sprite();
		
		public static var selectedLevelLocation:int = 1;
		
		public function Main():void
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}// Main
		
		public static function showBlackFg():void
		{
			isShowBlackFg = true;
		}// showBlackBg
		
		public static function hideBlackFg():void
		{
			isShowBlackFg = false;
		}// showBlackBg
		
		public static function showAndHideBlackFg():void
		{
			isShowBlackFg = false;
			blackSprite.alpha = 1;
		}
		
		public function mainMenuBackgroundVisible(bool:Boolean):void
		{
			if(bool)
			{
				_mainBackground.visible=true;
				_mainGameplay.visible=false;
			}
			else
			{
				_mainBackground.visible=false;
				_mainGameplay.visible=true;
			}
		}//mainMenuBackgroundVisible
		
		public function get mainMenu():MainMenu
		{
			return _mainMenu;
		}//mainMenu
		
		public function get mainBackGround():MainMenuBackground
		{
			return _mainBackground;
		}
		
		public function get gameplay():Gameplay
		{
			return _mainGameplay;
		}
		
		// ___________________________________________________________________________ PRIVATE
		
		private function init(e:Event = null):void
		{
			// here we go :)
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.quality = StageQuality.HIGH;
			
			blackSprite = new Sprite();
			blackSprite.graphics.beginFill(0x000000, 1);
			blackSprite.graphics.drawRect(0, 0, Main.appWidth, Main.appHeight);
			blackSprite.graphics.endFill();
			blackSprite.mouseChildren = false;
			blackSprite.mouseEnabled = false;
			
			Resources.init();
			//
			initGame();
			var s:Stats = new Stats();
			//addChild(s);
			//
			addEventListener(Event.ENTER_FRAME,updateFrame);
			//
			mainMask.graphics.beginFill(0xffffff, 1);
			mainMask.graphics.drawRect(0, 0, Main.appWidth, Main.appHeight);
			mainMask.graphics.endFill();
			
			this.scrollRect = new Rectangle(0, 0, appWidth, appHeight);
			
			//addChild(mainMask);
			//this.mask = mainMask;
			
			//MouseEventManager.disableMouseEvents();
		}// init
		
		private function initGame():void
		{
			_mainBackground=new MainMenuBackground();
			_mainMenu=new MainMenu(this);
			_blackStripes=new BlackStripes();
			_mainGameplay=new Gameplay(this);
			
			//
			addChild(_mainBackground);
			
			addChild(_mainGameplay);
			_mainGameplay.visible=false;
			
			addChild(_mainMenu);
			_mainMenu.y=-70;
			
			//Black Stripes
			addChild(_blackStripes);
			//_blackStripes.closePart();
			blackStripes=_blackStripes;
			
			if(initLevelEditor)
			{
			_levelEditor=new LevelEditor();
			addChild(_levelEditor);
			}
			
			SimpleTracerPanel.create(this);
			SimpleTracerPanel.setSize(50,50);
			SimpleTracerPanel.setPosition(800,0);
			SimpleTracerPanel.setSymbolLimit(100000);
			SimpleTracerPanel.traceString("\n");
			
			addChild(blackSprite);
			
		}// initGame
		
		private function updateFrame(e:Event):void
		{
			_mainBackground.update();
			
			if (isShowBlackFg)
			{
				if(blackSprite.alpha<1.0)blackSprite.alpha += 0.05;
			}
			else 
			{
				if(blackSprite.alpha>0)blackSprite.alpha -= 0.025;
			}// isShowBlackFg
			
			if (blackSprite.alpha < 0.05)
			{
				blackSprite.visible = false;
			}
			else
			{
				blackSprite.visible = true;
			}// blackSprite visible
			
		}//updateFrame
		
	}//class
}//pack