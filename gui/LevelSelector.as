package gui 
{
	import appsound.SoundManager;
	import criadone.utils.SimpleTracerPanel;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.ScoreData;
	import gui.RectGraphicButton;
	import levels.LevelList;
	import resources.Resources;
	
	/**
	 * ...
	 * @author 
	 */
	public class LevelSelector extends Sprite
	{
		public static const LEVELS_WINTER:int=1;
		public static const LEVELS_DESERT:int=2;
		public static const LEVELS_OCEAN:int=3;
		
		private var _width:int=600;
		private var _height:int=280;
		
		private var _mainSprite:Sprite;
		private var _locationSprite:Sprite;
		
		private var _locationWinter:RectGraphicButton;
		private var _locationDesert:RectGraphicButton;
		private var _locationOcean:RectGraphicButton;
		
		private var _levelsContainer:Sprite;
		private var _levelsButtonsArray:Array;
		
		private var _locationText:ExtText;
		private var locationDescText:ExtText;
		private var _levelsBackButton:RectGraphicButton;
		
		private var _currentLocationLevels:Array;
		
		private var _mainMenuRef:MainMenu;
		
		private var winterButtonImage:Bitmap = new Resources.winter_button();
		private var desertButtonImage:Bitmap = new Resources.desert_button();
		private var seaButtonImage:Bitmap = new Resources.sea_button();
		
		private var scoresInfo:ScoresInfo;
		
		public function LevelSelector(mainMenu:MainMenu) 
		{
			_mainMenuRef=mainMenu;
			init();
		}
		
		
		
		private function init():void
		{
			//main container
			_mainSprite=new Sprite();
			_mainSprite.graphics.beginFill(0xffffff,0.3);
			_mainSprite.graphics.drawRect(0,0,_width,_height);
			_mainSprite.graphics.endFill();
			addChild(_mainSprite);
			//
			_locationWinter=new RectGraphicButton(false,winterButtonImage);
			_locationDesert=new RectGraphicButton(false,desertButtonImage);
			_locationOcean=new RectGraphicButton(false,seaButtonImage);
			initLocationButton(0,_locationWinter);
			initLocationButton(1,_locationDesert);
			initLocationButton(2, _locationOcean);
			
			if(ScoreData.locationsLocked[0])_locationWinter.setLocked(false);
			if(ScoreData.locationsLocked[1])_locationDesert.setLocked(false);
			if(ScoreData.locationsLocked[2])_locationOcean.setLocked(false);
			
			addEventListener(Event.ENTER_FRAME, update);
			
			_locationWinter.addEventListener(MouseEvent.CLICK, onLocationWinter_Click);
			_locationDesert.addEventListener(MouseEvent.CLICK, onLocationDesert_Click);
			_locationOcean.addEventListener(MouseEvent.CLICK, onLocationOcean_Click);
			
			MouseEventManager.addElement(new MouseEventObject(_locationWinter, MouseEvent.CLICK, onLocationWinter_Click));
			MouseEventManager.addElement(new MouseEventObject(_locationDesert, MouseEvent.CLICK, onLocationDesert_Click));
			MouseEventManager.addElement(new MouseEventObject(_locationOcean, MouseEvent.CLICK, onLocationOcean_Click));
			
			_locationWinter.addEventListener(MouseEvent.MOUSE_OVER, onLocationWinter_Over);
			_locationDesert.addEventListener(MouseEvent.MOUSE_OVER, onLocationDesert_Over);
			_locationOcean.addEventListener(MouseEvent.MOUSE_OVER, onLocationOcean_Over);
			
			MouseEventManager.addElement(new MouseEventObject(_locationWinter, MouseEvent.MOUSE_OVER, onLocationWinter_Over));
			MouseEventManager.addElement(new MouseEventObject(_locationDesert, MouseEvent.MOUSE_OVER, onLocationDesert_Over));
			MouseEventManager.addElement(new MouseEventObject(_locationOcean, MouseEvent.MOUSE_OVER, onLocationOcean_Over));
			
			_locationWinter.addEventListener(MouseEvent.MOUSE_OUT, onLocationWinter_Out);
			_locationDesert.addEventListener(MouseEvent.MOUSE_OUT, onLocationDesert_Out);
			_locationOcean.addEventListener(MouseEvent.MOUSE_OUT, onLocationOcean_Out);
			
			MouseEventManager.addElement(new MouseEventObject(_locationWinter, MouseEvent.MOUSE_OUT, onLocationWinter_Out));
			MouseEventManager.addElement(new MouseEventObject(_locationDesert, MouseEvent.MOUSE_OUT, onLocationDesert_Out));
			MouseEventManager.addElement(new MouseEventObject(_locationOcean, MouseEvent.MOUSE_OUT, onLocationOcean_Out));
			
			//
			_locationText=new ExtText(0xffffff,"Arial",25);
			_locationText.setText("Choose Location");
			_locationText.setParams(20,50,400,35);
			_mainSprite.addChild(_locationText);
			//
			
			locationDescText = new ExtText(0xffffff, "Arial", 20);
			locationDescText.setText("");
			locationDescText.setParams(20,200,600,70);
			_mainSprite.addChild(locationDescText);
			
			_levelsContainer=new Sprite();
			_mainSprite.addChild(_levelsContainer);
			_levelsButtonsArray = new Array();
			var btnBitmap:Bitmap = new Resources.back_button();
			btnBitmap.smoothing = true;
			_levelsBackButton=new RectGraphicButton(false,btnBitmap,50,50);
			//_levelsBackButton.scaleX=_levelsBackButton.scaleY=0.5;
			_levelsBackButton.x=20;
			_levelsBackButton.y=90;
			_mainSprite.addChild(_levelsBackButton);
			_levelsBackButton.visible=false;
			_levelsBackButton.addEventListener(MouseEvent.CLICK, backToLocations_Click);
			//
			
			MouseEventManager.addElement(new MouseEventObject(_levelsBackButton, MouseEvent.CLICK, backToLocations_Click));
			
			scoresInfo = new ScoresInfo();
			//addChild(scoresInfo);
			
		}// init
		
		private function initLocationButton(ind:int,obj:RectGraphicButton):void
		{
			obj.y=280/2-50;
			obj.x=20+(ind*230);
			_mainSprite.addChild(obj);
		}
		
		private function hideLocations():void
		{
			_locationWinter.visible=false;
			_locationDesert.visible=false;
			_locationOcean.visible=false;
		}
		
		private function showLocations():void
		{
			_locationWinter.visible=true;
			_locationDesert.visible=true;
			_locationOcean.visible = true;
			updateLocationsView();
		}
		
		public function updateLocationsView():void
		{
			if(ScoreData.locationsLocked[0])_locationWinter.setLocked(true) else _locationWinter.setLocked(false);
			if(ScoreData.locationsLocked[1])_locationDesert.setLocked(true) else _locationDesert.setLocked(false);
			if(ScoreData.locationsLocked[2])_locationOcean.setLocked(true) else _locationOcean.setLocked(false);
		}
		
		private function showLevels(lvl:int):void
		{
			switch(lvl)
			{
			case LEVELS_WINTER:
			showLocationLevels(LevelList.levelsWinter,LEVELS_WINTER);
			break;
			case LEVELS_DESERT:
			showLocationLevels(LevelList.levelsDesert,LEVELS_DESERT);
			break;
			case LEVELS_OCEAN:
			showLocationLevels(LevelList.levelsOcean,LEVELS_OCEAN);
			break;
			default:
			}
			_locationText.setText("Choose Level");
			_levelsBackButton.visible=true;
		}
		
		private function hideLevels():void
		{
			for(var i:int=0;i<_levelsButtonsArray.length;i++)
			{
				_levelsButtonsArray[i].visible=false;
			}
			_levelsBackButton.visible=false;
			_locationText.setText("Choose Location");
			showLocations();
		}
		
		private function showLocationLevels(levelsArr:Array,locationIndex:int):void
		{
			scoresInfo.txt.text = "";
			scoresInfo.alpha = 0;
			
			var locationString:String = "";
			if (locationIndex == 1) locationString = "winter";
			if (locationIndex == 2) locationString = "desert";
			if (locationIndex == 3) locationString = "sea";
			
			var len:int=levelsArr.length;
			var buttonsLen:int = _levelsButtonsArray.length;
			
			var currentBtm:Bitmap;
			if (locationIndex == 1) currentBtm = winterButtonImage;
			if (locationIndex == 2) currentBtm = desertButtonImage;
			if (locationIndex == 3) currentBtm = seaButtonImage;
			
			for(var i:int=0;i< len;i++)
			{
				if(i>buttonsLen-1)
				{
					
					var newBtn:RectGraphicButton = new RectGraphicButton(true, currentBtm);
					newBtn.setLevelIndex(i + 1);
					_levelsButtonsArray.push(newBtn);
					_levelsContainer.addChild(newBtn);
				}
				else
				{
					newBtn = _levelsButtonsArray[i];
					newBtn.redraw(currentBtm);
					newBtn.setLevelIndex(i + 1);
					newBtn.visible=true;
				}
				newBtn.scaleX=newBtn.scaleY=0.5;
				newBtn.x=80+i*60;newBtn.y=100;
				newBtn.setLevelAssociation(this, locationIndex, i);
				if (ScoreData.isLevelLocked(locationString, newBtn.levelIndex))
				{
					newBtn.setLocked(true);
				}
				else
				{
					newBtn.setLocked(false);
				}
			}//end i
		}// end showLocationLevels
		
		
		
		
		private function update(e:Event):void
		{
			if (scoresInfo.alpha < 1) scoresInfo.alpha += 0.03;
		}//update
		
		internal function onLevelSelect_MouseOver(me:MouseEvent):void
		{
			var levelLoc:int = me.currentTarget.levelLocation;
			var levelInd:int = me.currentTarget.levelIndex;
			
			scoresInfo.txt.text = "" + ScoreData.getLevelScore(levelLoc, levelInd);
			scoresInfo.alpha = 0;
			
		}//onLevelSelect_MouseOver
		
		
		
		internal function onLevelSelect_Click(me:MouseEvent):void
		{
			Main.showAndHideBlackFg();
			// start game with level
			var levelLoc:int = me.currentTarget.levelLocation;
			var levelInd:int = me.currentTarget.levelIndex;
			// hide all main menus
			backToLocations_Click(null);
			_mainMenuRef.hideAllWindows();
			//_mainMenuRef.mainRef.blackStripes.closeFull();
			_mainMenuRef.playingGame=true;
			// level objects array
			switch(levelLoc)
			{
			case LEVELS_WINTER:
			_currentLocationLevels = LevelList.levelsWinter;
			break;
			
			case LEVELS_DESERT:
			_currentLocationLevels = LevelList.levelsDesert;
			break;
			
			case LEVELS_OCEAN:
			_currentLocationLevels = LevelList.levelsOcean;
			
			break;
			
			default:
			}
			// set level objects
			_mainMenuRef.mainRef.gameplay.levelIndex = levelInd;
			_mainMenuRef.mainRef.gameplay.currentLevelObjectsArray = _currentLocationLevels[levelInd].levelObjects;
			_mainMenuRef.mainRef.gameplay.currentLevelLocation = _currentLocationLevels[levelInd].levelLocation;
			_mainMenuRef.mainRef.gameplay.currentLevelObjectsStringArray = _currentLocationLevels[levelInd].levelObjectsStringArray;
			_mainMenuRef.mainRef.gameplay.leftSeconds = _currentLocationLevels[levelInd].time;
			_mainMenuRef.mainRef.gameplay.leftSecondsInitial = _currentLocationLevels[levelInd].time;
			_mainMenuRef.mainRef.gameplay.levelEnd = _currentLocationLevels[levelInd].levelEnd;
			_mainMenuRef.mainRef.gameplay.initLevel();
			//
			
			if (Main.helpShown == false)
			{
				_mainMenuRef.mainRef.gameplay.showHelpWindow();
				Main.helpShown = true;
			}//Main help shown
			
			SoundManager.mainMenuMusicPlaying = false;
			SoundManager.gameMusicPlaying = true;
			
			this.alpha = 0;
		}// select level click - end
		
		
		
		private function backToLocations_Click(me:MouseEvent):void
		{
			hideLevels();
			scoresInfo.txt.text = "";
			scoresInfo.alpha = 0;
			this.alpha = 0;
		}
		
		
		
		private function onLocationWinter_Click(me:MouseEvent):void
		{
			levelSelect(LEVELS_WINTER);
		}
		
		
		private function onLocationDesert_Click(me:MouseEvent):void
		{
			levelSelect(LEVELS_DESERT);
		}
		
		
		private function onLocationOcean_Click(me:MouseEvent):void
		{
			levelSelect(LEVELS_OCEAN);
		}
		
		
		private function onLocationWinter_Over(me:MouseEvent):void
		{
			locationDescText.setText("EASY - Mountains.\n Easy level for beginners.");
		}
		
		
		private function onLocationDesert_Over(me:MouseEvent):void
		{
			locationDescText.setText("MEDIUM - Desert.\n Less time. Twice more stars!");
		}
		
		
		private function onLocationOcean_Over(me:MouseEvent):void
		{
			locationDescText.setText("HARD - Ocean.\n Less time and more damage. Thrice more stars!");
		}
		
		
		private function onLocationWinter_Out(me:MouseEvent):void
		{
			locationDescText.setText("");
		}
		
		
		private function onLocationDesert_Out(me:MouseEvent):void
		{
			locationDescText.setText("");
		}
		
		
		private function onLocationOcean_Out(me:MouseEvent):void
		{
			locationDescText.setText("");
		}
		
		
		private function levelSelect(levelLoc:int):void
		{
			//SimpleTracerPanel.traceString("SELECTED LOCATION: " + levelLoc);
			Main.selectedLevelLocation = levelLoc;
			
			this.alpha = 0;
			Main.showAndHideBlackFg();
			var levelInd:int = 0;
			_mainMenuRef.hideAllWindows();
			_mainMenuRef.playingGame = true;
			// level objects array
			switch(levelLoc)
			{
			case LEVELS_WINTER:
			_currentLocationLevels = LevelList.levelsWinter;
			break;
			
			case LEVELS_DESERT:
			_currentLocationLevels = LevelList.levelsDesert;
			break;
			
			case LEVELS_OCEAN:
			_currentLocationLevels = LevelList.levelsOcean;
			break;
			
			default:
			}
			// set level objects
			
			_mainMenuRef.mainRef.gameplay.levelIndex = levelInd;
			_mainMenuRef.mainRef.gameplay.currentLevelObjectsArray = _currentLocationLevels[levelInd].levelObjects;
			_mainMenuRef.mainRef.gameplay.currentLevelLocation = _currentLocationLevels[levelInd].levelLocation;
			_mainMenuRef.mainRef.gameplay.currentLevelObjectsStringArray = _currentLocationLevels[levelInd].levelObjectsStringArray;
			_mainMenuRef.mainRef.gameplay.leftSeconds = _currentLocationLevels[levelInd].time;
			_mainMenuRef.mainRef.gameplay.leftSecondsInitial = _currentLocationLevels[levelInd].time;
			_mainMenuRef.mainRef.gameplay.levelEnd = _currentLocationLevels[levelInd].levelEnd;
			_mainMenuRef.mainRef.gameplay.initLevel();
			//
			
			if (Main.helpShown == false)
			{
				_mainMenuRef.mainRef.gameplay.showHelpWindow();
				Main.helpShown = true;
			}//Main help shown
			
			SoundManager.mainMenuMusicPlaying = false;
			SoundManager.gameMusicPlaying = true;
			
			this.alpha = 0;
			
		}//
		
	}//
	
}//