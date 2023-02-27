package gui 
{
	import appsound.SoundManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import game.ScoreData;
	import resources.Resources;
	
	
	
	public class MainMenu extends Sprite
	{
		
		private var _buttonCredits:Button;
		private var _buttonSettings:Button;
		private var _buttonPlay:Button;
		
		private var _copyrightText:TextField;
		private var _copyrightShadow:DropShadowFilter;
		private var _filters:Array;
		
		private var _creditsWindow:Window;
		private var _optionsWindow:Window;
		private var _playWindow:Window;
		
		private var _levelSelect:LevelSelector;
		
		private var scoreBestInfo:ScoresInfo;
		
		public var mainRef:Main;
		public var playingGame:Boolean = false;
		
		public var creditsTextMc:MovieClip = new creditsMc();
		public var helpTextMc:MovieClip = new HelpText_mc();
		
		public var soundOn:RectGraphicButton;
		public var soundOff:RectGraphicButton;
		
		public function MainMenu(main:Main) 
		{
			mainRef=main;
			init();
			addEventListener(Event.ENTER_FRAME, updateFrame);
		}
		
		public function hideAllWindows():void
		{
			_creditsWindow.hide(1500);
			_optionsWindow.hide(1500);
			_playWindow.hide(1500);
		}
		
		
		
		private function init():void
		{
			_levelSelect=new LevelSelector(this);
			// PLAY
			_buttonPlay=new Button();
			_buttonPlay.setText("play");
			_buttonPlay.x=Main.appWidth/2-_buttonPlay.width/2;
			_buttonPlay.y=Main.appHeight/2-_buttonPlay.height/2;
			_buttonPlay.addEventListener(MouseEvent.CLICK, onPlay_Click);
			
			MouseEventManager.addElement(new MouseEventObject(_buttonPlay, MouseEvent.CLICK, onPlay_Click));
			
			// SETTINGS
			_buttonSettings=new Button();
			_buttonSettings.setText("options");
			_buttonSettings.x=Main.appWidth/2-_buttonSettings.width/2;
			_buttonSettings.y=Main.appHeight/2-_buttonSettings.height/2+50;
			_buttonSettings.addEventListener(MouseEvent.CLICK, onSettings_Click);
			
			MouseEventManager.addElement(new MouseEventObject(_buttonSettings, MouseEvent.CLICK, onSettings_Click));
			
			// CREDITS
			_buttonCredits=new Button();
			_buttonCredits.setText("credits");
			_buttonCredits.x=Main.appWidth/2-_buttonCredits.width/2;
			_buttonCredits.y=Main.appHeight/2-_buttonCredits.height/2+100;
			_buttonCredits.addEventListener(MouseEvent.CLICK, onCredits_Click);
			
			MouseEventManager.addElement(new MouseEventObject(_buttonCredits, MouseEvent.CLICK, onCredits_Click));
			
			// adding childs
			addChild(_buttonPlay);
			addChild(_buttonSettings);
			addChild(_buttonCredits);
			
			// sound control buttons
			
			soundOn = new RectGraphicButton(false, new Resources.icon_sound_off(), 50, 50);
			soundOn.x = Main.appWidth / 2-25;
			soundOn.y = 400;
			soundOn.addEventListener(MouseEvent.MOUSE_DOWN, soundOn_Click);
			addChild(soundOn);
			soundOn.visible = false;
			
			MouseEventManager.addElement(new MouseEventObject(soundOn, MouseEvent.MOUSE_DOWN, soundOn_Click));
			
			soundOff = new RectGraphicButton(false, new Resources.icon_sound_on(), 50, 50);
			soundOff.x = Main.appWidth / 2-25;
			soundOff.y = 400;
			soundOff.addEventListener(MouseEvent.MOUSE_DOWN, soundOff_Click);
			addChild(soundOff);
			
			MouseEventManager.addElement(new MouseEventObject(soundOff, MouseEvent.MOUSE_DOWN, soundOff_Click));
			
			//copyright text
			_copyrightShadow=new DropShadowFilter(3,45,0x000000,1,5,5,1,1);
			_filters=new Array(_copyrightShadow);
			_copyrightText=new TextField();
			_copyrightText.width=Main.appWidth;
			var format:TextFormat=new TextFormat("Arial",20,0xffffff,null,null,null,null,null,TextFormatAlign.CENTER);
			_copyrightText.setTextFormat(format);
			_copyrightText.defaultTextFormat=format;
			_copyrightText.text = "";
			_copyrightText.visible = false;
			_copyrightText.selectable=false;
			_copyrightText.x=0;
			_copyrightText.y=460;
			_copyrightText.filters=_filters;
			addChild(_copyrightText);
			//
			
			//credits window
			_creditsWindow=new Window();
			_creditsWindow.hide(1500);
			_creditsWindow.y=320;
			_creditsWindow.scaleX = _creditsWindow.scaleY = 0.9;
			_creditsWindow.addChild(creditsTextMc);
			creditsTextMc.mouseEnabled = false;
			creditsTextMc.mouseChildren = false;
			creditsTextMc.scaleX = creditsTextMc.scaleY = 0.7;
			addChild(_creditsWindow);
			
			//options window
			HelpTextControl.init();
			HelpTextControl.setActiveHelpText(helpTextMc);
			_optionsWindow=new Window();
			_optionsWindow.hide(1500);
			_optionsWindow.y=320;
			_optionsWindow.scaleX = _optionsWindow.scaleY = 0.9;
			_optionsWindow.addChild(helpTextMc);
			helpTextMc.y = -180;
			helpTextMc.x = -315;
			helpTextMc.scaleX = helpTextMc.scaleY = 0.9;			
			addChild(_optionsWindow);
			
			//play window
			_playWindow=new Window();
			_playWindow.hide(1500);
			_playWindow.y=320;
			
			_levelSelect.x=-_levelSelect.width/2;
			_levelSelect.y=-_levelSelect.height/2;
			_playWindow.addChild(_levelSelect);
			//_levelSelect.setMask();
			
			_playWindow.scaleX=_playWindow.scaleY=0.9;
			_playWindow.setBackButtonCaption("back");
			addChild(_playWindow);
			
			// scores
			
			scoreBestInfo = new ScoresInfo();
			addChild(scoreBestInfo);
			scoreBestInfo.x = 30;
			scoreBestInfo.y = 500;
			scoreBestInfo.txt.text = "0";
			
			SoundManager.init();
			SoundManager.setCollisionVolume(0);
			SoundManager.playMainMenuMusic();
			SoundManager.playGameSound();
			SoundManager.setGameMusVolume(0.0);
			SoundManager.setMenuMusVolume(0.0);
			SoundManager.mainMenuMusicPlaying = true;
			SoundManager.gameMusicPlaying = false;
			
		}//end init
		
		// ________________________________________________________________________________________ - EVENTS
		
		private function soundOn_Click(me:MouseEvent):void
		{
			soundOff.visible = true;
			soundOn.visible = false;
			SoundManager.soundOn();
		}// soundOn_Click
		
		private function soundOff_Click(me:MouseEvent):void
		{
			soundOff.visible = false;
			soundOn.visible = true;
			SoundManager.soundOff();
		}// soundOff_Click
		
		private function updateFrame(e:Event):void
		{
			
			if(playingGame)
			{
				visible=false;
				mainRef.mainMenuBackgroundVisible(false);
			}
			else
			{
				visible=true;
				mainRef.mainMenuBackgroundVisible(true);
				scoreBestInfo.txt.text = "" + ScoreData.getTotalScore();
			}
			
			if (_levelSelect.alpha < 1)_levelSelect.alpha += 0.05;
			
			// MUSIC CONTROL
			if (SoundManager.mainMenuMusicPlaying)
			{
				if (SoundManager.getMenuMusVolume() < 1)
				{
					SoundManager.setMenuMusVolume(SoundManager.getMenuMusVolume() + 0.01);
				}
			}
			else
			{
				if (SoundManager.getMenuMusVolume() > 0)
				{
					SoundManager.setMenuMusVolume(SoundManager.getMenuMusVolume() - 0.01);
				}
			} // MUSIC CONTROL - MAIN MENU
			
			if (SoundManager.gameMusicPlaying)
			{
				if (SoundManager.getGameMusVolume() < 1)
				{
					SoundManager.setGameMusVolume(SoundManager.getGameMusVolume() + 0.01);
				}
			}
			else
			{
				if (SoundManager.getGameMusVolume() > 0)
				{
					SoundManager.setGameMusVolume(SoundManager.getGameMusVolume() - 0.01);
				}
			}// MUSIC CONTROL - GAME MUSIC
			
		}//updateFrame
		
		private function onCredits_Click(me:MouseEvent):void
		{
			_creditsWindow.show(Main.appWidth/2);
		}
		
		private function onSettings_Click(me:MouseEvent):void
		{
			_optionsWindow.show(Main.appWidth/2);
		}
		
		private function onPlay_Click(me:MouseEvent):void
		{
			_levelSelect.updateLocationsView();
			_playWindow.show(Main.appWidth/2);
		}
		
		
	}//class
}//pack