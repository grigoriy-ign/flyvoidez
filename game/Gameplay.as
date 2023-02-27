package game 
{
	import adobe.utils.CustomActions;
	import appsound.SoundManager;
	import criadone.utils.SimpleTracerPanel;
	import display.effects.BuffEffect;
	import display.effects.CollisionEffect;
	import display.effects.ExplosionEffect;
	import display.effects.FireTurboEffect;
	import display.effects.GravityEffect;
	import display.Render;
	import display.RenderEffects;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import geom.P2d;
	import gui.Button;
	import gui.ExtText;
	import gui.HelpTextControl;
	import gui.Informer;
	import gui.MouseEventManager;
	import gui.MouseEventObject;
	import gui.RectGraphicButton;
	import gui.Window;
	import levels.LevelList;
	import levels.LevelParser;
	import levels.PatternLib;
	import levels.UniqPatternLib;
	import objects.IngameObject;
	import objects.library.StaticGround;
	import resources.Resources;
	/**
	 * ...
	 * @author 
	 */
	public class Gameplay extends Sprite
	{
		
		private var _width:int=Main.appWidth;
		private var _height:int=500;
		
		public var mainRef:Main;
		public var openStripes:Boolean;
		
		public var levelIndex:int = 0;
		public var currentLevelObjectsArray:Array;
		public var currentLevelObjectsStringArray:Array;
		public var currentLevelLocation:String = "winter";
		public var currentLocationRenderIndex:int = 0;
		
		public var scrollCounter:int = 0;
		
		// gameplay objects
		private var _playerShipObject:StaticGround;
		private var _playerShip:PlayerShip;
		
		public var paused:Boolean = true;
		//
		
		// SCORE
		public static var gameStars:int = 0;
		public var levelEnd:Number = 100;
		public var levelCompleted:Boolean = false;
		
		// game GUI
		private var guiMc:MovieClip;
		private var scoresMc:ScoresInfo;
		private var hpMc:HpBar;
		private var timeMc:TimeMc;
		private var messageMc:messageText;
		
		// calc data
		private var damageDivider:Number = 5;	// damage divided with this value
		
		// effects
		private var effectsArray:Array = new Array();
		private var damageLayer:Sprite;
		private var explosionLayer:Sprite = new Sprite();
		
		// bonus
		public static var lastCollisionBonusType:int = 1;
		public static var lastCollisionObjIndex:int = 0;
		
		public var buffBoostEnergy:int = 0;
		public var buffReverseEnergy:int = 0;
		
		private var additionalTimeAdded:Boolean = false;
		private var additionalHealthAdded:Boolean = false;
		
		// timing
		private var ticker:Timer = new Timer(1000, 0);
		
		public function Gameplay(main:Main) 
		{
			mainRef=main;
			init();
			initEffetcs();
			addEventListener(Event.ENTER_FRAME, updateFrame);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(KeyboardEvent.KEY_DOWN, Controls.keyDown);
			addEventListener(KeyboardEvent.KEY_UP, Controls.keyUp);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			MouseEventManager.addElement(new MouseEventObject(this, MouseEvent.MOUSE_DOWN, onMouseDown));
			
			Render.viewport = this;
			//
			_playerShip=new PlayerShip();
			_playerShipObject=new StaticGround();
			//
			Controls.init();
			initGameGui();
			
			ticker.addEventListener(TimerEvent.TIMER, onTick);
			
			//this.mouseChildren = false;
			//this.mouseEnabled = false;
			
		}//constr
		
		public function initLevel():void
		{
			//stage.focus=this;
			//stage.stageFocusRect=false;
			//focusRect = null;
			
			currentLevelObjectsArray = [];
			//
			LevelParser.parsePattern(PatternLib.getRandomPattern().objects,currentLevelObjectsArray, 1600);
			//SimpleTracerPanel.traceString(currentLevelLocation);
			// determine textures
			if(currentLevelLocation=="winter")
			{
				Render.currentLevelTexturesArrayRef = Resources.texturesWinter;
				currentLocationRenderIndex = 1;
			}
			else if(currentLevelLocation=="desert")
			{
				Render.currentLevelTexturesArrayRef = Resources.texturesDesert;
				currentLocationRenderIndex = 2;
			}
			else if(currentLevelLocation=="sea")
			{
				Render.currentLevelTexturesArrayRef = Resources.texturesSea;
				currentLocationRenderIndex = 3;
			}
			else
			{
				SimpleTracerPanel.traceString("Gameplay -> InitLevel : Unknown location "+currentLevelLocation);
			}
			
			// add player ship object
			_playerShipObject.points=_playerShip.pointsData;
			_playerShipObject.triangles = _playerShip.trianglesData;
			_playerShipObject.bitmapindex = 10;
			//currentLevelObjectsArray.push(_playerShipObject);
			//SimpleTracerPanel.traceString(""+currentLevelObjectsArray.length);
			//
			
			_playerShipObject.position.x = 500; scrollCounter = 500;
			_playerShipObject.position.y = 250;
			
			levelCompleted = false;
			
		}// initLevel
		
		private function restartLevel():void
		{
			levelCompleted = false;
			_playerShip.health = 100;
			_playerShipObject.visible = true;
			_playerShipObject.position.x = 500; scrollCounter = 500;
			_playerShipObject.position.y = 250;
			Gameplay.gameStars = 0;
			buffBoostEnergy = 0;
			buffReverseEnergy = 0;
			
			escWindowDesc.setText("");
			
			//effects restart
			explosionEffect.boomed = false;
			explosionLayer.width = explosionLayer.height = 501;
			explosionLayer.alpha = 0;
			explosionEffect.hideEffect();
			fireTurboEffect.visible = true;
			
			//time
			leftSeconds = leftSecondsInitial;
			
			//GUI
			gameOverEscShown = false;
			informer.clearMessages();
			
			// logic
			lastCollisionObjIndex = 0;
			lastCollisionBonusType = 1;
			
			// show all objects
			var currentObj:StaticGround;
			for (var i:int = 0; i < currentLevelObjectsArray.length; i++)
			{
				currentObj = currentLevelObjectsArray[i];
				currentObj.visible = true;
			}//end for i
			
			currentLevelObjectsArray = [];
			
		}//restartLevel
		
		// ____________________________________________________________________________ EVENTS
		
		public function updateFrame(e:Event):void
		{
			//var startTime:int = getTimer();
			var addAmount:int = 200;
			//var frameInfo:String = "";
			// add new objects
			if (scrollCounter > Main.appWidth+addAmount)
			{
				additionalHealthAdded = false;
				additionalTimeAdded = false;
				
				var typeRand:Number = Math.random();
				if (typeRand <= 1.0)
				{
					// get unique pattern
					LevelParser.parseLevel(UniqPatternLib.getRandomPattern(),currentLevelObjectsArray,_playerShipObject.position.x+1600+addAmount);
				}
				else
				{
					// get generated pattern
					LevelParser.parsePattern(PatternLib.getRandomPattern().objects,currentLevelObjectsArray,_playerShipObject.position.x+1600+addAmount);
				}// typeRand
				
				//frameInfo += " PARSE LEVEL ";
				
				scrollCounter = 0;
				//currentLevelObjectsArray.push(_playerShipObject);
				
				//SimpleTracerPanel.traceString("total objects: "+currentLevelObjectsArray.length);
				
				//SimpleTracerPanel.traceString("" + currentLevelObjectsArray.length);
				if (currentLevelObjectsArray.length > 100)
				{
					//SimpleTracerPanel.traceString("objects removing "+currentLevelObjectsArray.length);
					currentLevelObjectsArray = currentLevelObjectsArray.slice(currentLevelObjectsArray.length - 70, currentLevelObjectsArray.length);
					//SimpleTracerPanel.traceString("objects removed "+currentLevelObjectsArray.length);
					//frameInfo += " | CLEAR ARRAY ";
				}
				
				// add additional items to balance gameplay
				var i:int = 0;
				var curObj:IngameObject;
				if ((leftSeconds < 30)&&(!additionalTimeAdded))
				{
					// add new bonus
					for (i = currentLevelObjectsArray.length-1; i > 0; i--)
					{
						curObj = currentLevelObjectsArray[i];
						if ((curObj.isBonus)&&(additionalTimeAdded==false))
						{
							curObj.bonusType = LevelEditor.BONUS_TIME;
							curObj.bitmapindex = 10 + LevelEditor.BONUS_TIME;
							additionalTimeAdded = true;
						}
					}
					//frameInfo += " | ADD OBJECT TIME ";
				}//leftSeconds
				
				if ((_playerShip.health < 30)&&(!additionalHealthAdded))
				{
					//add new healt bonus
					for (i = currentLevelObjectsArray.length - 1; i > 0; i--)
					{
						curObj = currentLevelObjectsArray[i];
						if ((curObj.isBonus) && (additionalHealthAdded==false))
						{
							curObj.bonusType = LevelEditor.BONUS_HEALTH;
							curObj.bitmapindex = 10 + LevelEditor.BONUS_HEALTH;
						}
						additionalHealthAdded = true;
					}//end for i
					// add new health bonus
					//frameInfo += " | ADD OBJECT HEALTH ";
				}
				
			}// scrollCounter > 500
			
			x = 0; y = 0;
			if ((paused == false)&&(mainRef.mainMenu.playingGame==true))
			{
				// buffs
			if (buffBoostEnergy > 0) buffBoostEnergy--;
			if (buffReverseEnergy > 0) buffReverseEnergy--;
			
			// controls
			handleControls();
			
			var result:int = GamePhysics.checkIntersectionObject(_playerShipObject, currentLevelObjectsArray, currentLevelObjectsArray);
			var isGroundContact:Boolean=false;
			if (result == GamePhysics.COLLISION_GROUND) isGroundContact = true;
			calcDamage(isGroundContact);
			
			if (result == GamePhysics.COLLISION_BONUS)
			{
				if (_playerShip.health > 0)
				{
					var collisionObj:StaticGround = currentLevelObjectsArray[lastCollisionObjIndex];
					addBuff(lastCollisionBonusType);
					buffEffect.boomed = false;
					buffEffect.boom(lastCollisionBonusType);
					collisionObj.visible = false;
					SoundManager.playSound(SoundManager.SND_BONUS);
				}
			}//end if result collision bonus
			
			updateEffects();
			
			redrawBack();
			updateGUI();
			Render.renderObjects(currentLevelObjectsArray, false, _playerShipObject.position.x, currentLocationRenderIndex);
			Render.renderObject(_playerShipObject,_playerShipObject.position.x);
			RenderEffects.render(effectsArray, this);
			}// end if not paused
			//var endTime:int = getTimer();
			//SimpleTracerPanel.traceString(String(endTime-startTime)+" - "+frameInfo);
			
		}//endUpdateFrame
		
		private function onKeyDown(ke:KeyboardEvent):void
		{
			//SimpleTracerPanel.traceString("key down "+ke.keyCode);
			if (ke.keyCode == Keyboard.DELETE) MouseEventManager.disableMouseEvents();
			if(ke.keyCode==27) // ESC
			{
				// show pause menu
				// EXIT to main menu temp
				if (paused == false)
				{
					escWindow.show(Main.appWidth/2);
					pauseGame();
				}
				else
				{
					if ((_playerShip.health > 0)&&(levelCompleted==false))
					{
						escWindow.hide(1500);
						unpauseGame();
						messageMc.visible = false;
					}
				}//
			}//end if ESC
			
			if (ke.keyCode == 80) // P key
			{
				if (escWindow.x < 1500)
				{
					
				}
				else
				{
				if (paused)
				{
					unpauseGame();
					messageMc.visible = false;
				}//paused
				else
				{
					pauseGame();
					messageMc.visible = true;
					messageMc.txt.text = "Game Paused";
				}//else
				}
				
			}//end if P key
			
		}//onKeyDown
		
		private function pauseGame():void
		{
			paused = true;
			ticker.stop();
			SoundManager.setCollisionVolume(0);
			SoundManager.gameMusicPlaying = false;
			// decrease left seconds when ESC or pause clicked
			leftSeconds--;
		}//pauseGame
		
		private function unpauseGame():void
		{
			paused = false;
			messageMc.visible = false;
			ticker.start();
			SoundManager.gameMusicPlaying = true;
		}//unpauseGame
		
		private function onMouseDown(me:MouseEvent):void
		{
			stage.stageFocusRect=false;
			focusRect=null;
			stage.focus=this;
		}//onMouseDown
		
		// _______________________________________________________________________ PRIVATE
		
		
		// _______________________
		// 		TIMING CONTROL
		// _______________________
		
		public var leftSeconds:int = 300;
		public var leftSecondsInitial:int = 300;
		private var timerStoppedDealy:int = 0;
		
		private function onTick(te:TimerEvent):void
		{
			if (mainRef.mainMenu.playingGame)
			{
			if (leftSeconds > 0) 
			{
				leftSeconds--;
				if (leftSeconds == 0)
				{
					_playerShip.health = 0;
					leftSeconds = 0;
					ScoreData.setTotalScore(Gameplay.gameStars);
					escWindowDesc.setText("Time Ended! "+Gameplay.gameStars+" stars.");
				}
				if ((leftSeconds < 10)&&(leftSeconds>0))
				{
					informer.addMessage("TIME ENDING! " + leftSeconds, 0xff0000);
					SoundManager.playSound(SoundManager.SND_CLICK);
				}
			}
			if (leftSeconds == 0)
			{
				
			}
			}//end if (mainRef.mainMenu.playingGame)
		}//
		
		// _______________________
		//		CONTROLS BEGIN
		// _______________________
		
		private var gameOverEscShown:Boolean = false;	// TRUE if ESC window already shown when player loses
		private var speedyTemp:Number = 0;
		private function handleControls():void
		{
			
			//SimpleTracerPanel.traceString("mouse "+mouseX+" "+mouseY);
			
			if (_playerShip.health > 0)
			{
				if (buffBoostEnergy > 0)
				{
					// buff boost speed
					_playerShip.speedX = 10 + ((550) / 200) + (buffBoostEnergy / 120);
				}
				else
				{
					_playerShip.speedX = 10 + ((mouseX - 150) / 200);
				}
				
				// buff reverse
				if (buffReverseEnergy > 0)
				{
					_playerShip.speedY = ((mouseY - _playerShipObject.position.y) / 30);
				}
				else
				{
					_playerShip.speedY = ((mouseY - _playerShipObject.position.y) / 15);
				}
			}//if health > 0
			
			// limit speed
			if (_playerShip.speedY < 0)
			{
				if (_playerShip.speedY < -15)_playerShip.speedY = -15;
			}
			if (_playerShip.speedY > 0)
			{
				if (_playerShip.speedY > 15)_playerShip.speedY = 15;
			}
			// end limit speed
			
			if (_playerShip.health <= 0)
			{
				if (_playerShip.speedX > 0)_playerShip.speedX -= 0.1;
				if (_playerShip.speedY > 0)_playerShip.speedY -= 0.1;
				if (_playerShip.speedX <= 0)_playerShip.speedX = 0;
				if (_playerShip.speedY <= 0)_playerShip.speedY = 0;
				if (gameOverEscShown == false)
				{
					if (_playerShip.speedX <= 0)
					{
						if (paused == false)
						{
							escWindow.show(Main.appWidth/2);
							pauseGame();
							gameOverEscShown = true;
						}
					}
				}//end if gameOverEscShown
			}// end if _playerShip.health <= 0)
			
			_playerShipObject.position.x += _playerShip.speedX; scrollCounter += _playerShip.speedX;
			_playerShipObject.position.y += _playerShip.speedY;
			
			if (_playerShipObject.position.y < 10)_playerShipObject.position.y = 10;
			if (_playerShipObject.position.y > 490)_playerShipObject.position.y = 490;
			
		}
		//handle controls
		
		// _______________________
		//		CONTROLS END
		// _______________________
		
		// _______________________
		//		PHYSICS BEGIN
		// _______________________
		
		private function calcDamage(contact:Boolean):void
		{
			if (contact)
			{
				
			var damage:Number = ((Math.abs(_playerShip.speedX) + Math.abs(_playerShip.speedY)) / damageDivider)*(Main.selectedLevelLocation/2);
			//_playerShip.health -= damage;
			//SimpleTracerPanel.traceString("DAMAGE: "+damage);
			
			// collision sound control
			var volum:Number = damage / 5;
			if (volum > 1) volum = 1;
			if (_playerShip.health > 0)
			{
				SoundManager.setCollisionVolume(volum);
			}
			else
			{
				SoundManager.setCollisionVolume(0);
			}
			// end collision sound control
			
				if (_playerShip.health < 0)
				{
					_playerShip.health = 0;
					if (explosionEffect.boomed == false)
					{
						damageLayer.alpha = 1;
						explosionLayer.width = explosionLayer.height = 10;
						explosionLayer.alpha = 1;
						SoundManager.playSound(SoundManager.SND_EXPLOSION);
					}
					explosionEffect.boom();
					_playerShipObject.visible = false;
					fireTurboEffect.visible = false;
					ticker.stop();
					ScoreData.setTotalScore(Gameplay.gameStars);
					escWindowDesc.setText("Crashed! "+Gameplay.gameStars+" stars.");
					//GameEffects.shakeSprite(this, damage * 2);
				}
				else
				{
					GameEffects.shakeSprite(this, damage * 2);
					damageLayer.alpha = damage / 2;
					collisionEffect.active = true;
					collisionEffect.power = damage * 10;
				}
			}//contact
			else
			{
				SoundManager.setCollisionVolume(0);
				collisionEffect.active = false;
			}
		}//calcDamage
		
		// _______________________
		//		EFFECTS INIT ETC
		// _______________________
		
		private var fireTurboEffect:FireTurboEffect;
		private var collisionEffect:CollisionEffect;
		private var explosionEffect:ExplosionEffect;
		private var buffEffect:BuffEffect;
		private var gravityEffect:GravityEffect;
		private function initEffetcs():void
		{
			effectsArray = new Array();
			
			fireTurboEffect = new FireTurboEffect();
			fireTurboEffect.sizeXOrig = 70;
			fireTurboEffect.sizeYOrig = 22;
			fireTurboEffect.sizeX = 35;
			fireTurboEffect.sizeY = 11;
			
			collisionEffect = new CollisionEffect();
			collisionEffect.posX = 100;
			collisionEffect.posY = 100;
			collisionEffect.sizeXOrig = 100;
			collisionEffect.sizeYOrig = 100;
			collisionEffect.sizeX = 100;
			collisionEffect.sizeY = 100;
			
			explosionEffect = new ExplosionEffect();
			explosionEffect.posX = 100;
			explosionEffect.posY = 100;
			explosionEffect.sizeXOrig = 100;
			explosionEffect.sizeYOrig = 100;
			explosionEffect.sizeX = 100;
			explosionEffect.sizeY = 100;
			
			buffEffect = new BuffEffect();
			buffEffect.posX = 100;
			buffEffect.posY = 100;
			buffEffect.sizeXOrig = 100;
			buffEffect.sizeYOrig = 100;
			buffEffect.sizeX = 100;
			buffEffect.sizeY = 100;
			
			gravityEffect = new GravityEffect();
			gravityEffect.posX = 100;
			gravityEffect.posY = 100;
			gravityEffect.sizeXOrig = 100;
			gravityEffect.sizeYOrig = 100;
			gravityEffect.sizeX = 100;
			gravityEffect.sizeY = 100;
			gravityEffect.active = false;
			
			effectsArray.push(fireTurboEffect);
			effectsArray.push(collisionEffect);
			effectsArray.push(explosionEffect);
			effectsArray.push(buffEffect);
			effectsArray.push(gravityEffect);
			
			// explosion layer
			GameEffects.drawExplosionLayerEffect(explosionLayer);
			//addChild(explosionLayer);
			explosionLayer.width =201;
			explosionLayer.height = 201;
			explosionLayer.alpha = 0;
			
			// damage layer red
			damageLayer = new Sprite();
			GameEffects.drawDamageLayerEffect(damageLayer);
			//addChild(damageLayer);
			damageLayer.width = Main.appWidth;
			damageLayer.height = Main.appHeight;
			damageLayer.alpha = 0;
			
		}//initEffetcs
		
		//animates effects on enter new frame
		private function updateEffects():void
		{
			// effect - damage layer
			if (damageLayer.alpha < 0.1) damageLayer.visible = false else damageLayer.visible = true;
			if (damageLayer.alpha > 0) damageLayer.alpha -= 0.05;
			
			if (damageLayer.alpha > 1) damageLayer.alpha = 1.0;
			
			// fire turbo effect
			fireTurboEffect.sizeX = _playerShip.speedX*3;
			fireTurboEffect.posX = 45-fireTurboEffect.sizeX;
			fireTurboEffect.posY = _playerShipObject.position.y - 3;
			
			// collision effect
			collisionEffect.posX = 100;
			collisionEffect.posY = _playerShipObject.position.y;
			
			// explosion effect
			explosionEffect.posX = 100;
			explosionEffect.posY = _playerShipObject.position.y;
			explosionLayer.x = 100;
			explosionLayer.y = _playerShipObject.position.y;
			if (explosionLayer.alpha < 0.1) explosionLayer.visible = false else explosionLayer.visible = true;
			if (explosionLayer.width < 500)
			{
				explosionLayer.width += 10;
				if (explosionLayer.alpha > 0) explosionLayer.alpha -= 0.02;
				explosionLayer.height = explosionLayer.width;
			}//end if
			
			// buff effect
			buffEffect.posX = 100;
			buffEffect.posY = _playerShipObject.position.y;
			
			gravityEffect.posX = 90;
			gravityEffect.posY = _playerShipObject.position.y - 10;
			
			if (( buffReverseEnergy <= 0)||(_playerShip.health<=0))
			{
				gravityEffect.active = false;
			}
			
		}//updateEffects
		
		private var randomBuff:int = 0;
		private function addBuff(type:int):void
		{
			if (type == LevelEditor.BONUS_RANDOM)
			{
				randomBuff = 1 + Math.random() * 5;
				addBuff(randomBuff);
			}
			else if (type == LevelEditor.BONUS_STAR)
			{
				var buffBoostAdd:int = 0; if (buffBoostEnergy > 0) buffBoostAdd = int(_playerShip.speedX/2);
				var scoresToAdd:int = (Math.abs(_playerShip.speedX - (_playerShip.speedX / 2) + buffBoostAdd))*Main.selectedLevelLocation;
				
				//SimpleTracerPanel.traceString("add: " + _playerShip.speedX.toFixed(1) + " - " + (_playerShip.speedX / 2).toFixed(1) + " + " + buffBoostAdd + " * "+Main.selectedLevelLocation+" = "+scoresToAdd);
				
				Gameplay.gameStars+=scoresToAdd;
				informer.addMessage("+"+scoresToAdd,0xffff00);
			}
			else if (type == LevelEditor.BONUS_TIME)
			{
				leftSeconds += 10;
				informer.addMessage("+10 sec.",0xffffff);
			}
			else if (type == LevelEditor.BONUS_HEALTH)
			{
				_playerShip.health += 30;
				informer.addMessage("+30 HP",0x00ff00);
				if (_playerShip.health > 100)_playerShip.health = 100;
			}
			else if (type == LevelEditor.BONUS_BOOST)
			{
				buffBoostEnergy = 200;
				informer.addMessage("SPEED!",0xff0000);
			}
			else if (type == LevelEditor.BONUS_REVERSE)
			{
				buffReverseEnergy = 200;
				gravityEffect.active = true;
				informer.addMessage("OVERLOAD!",0x000000);
			}
		}//addBuff
		
		// _______________________
		//		OTHER GRAPHICS
		// _______________________
		
		private function redrawBack():void
		{
			graphics.clear();
			graphics.beginFill(0x606060);
			graphics.drawRect(0,0,_width,_height);
			graphics.endFill();
		}//redrawBack
		
		private function init():void
		{
			graphics.beginFill(0x606060);
			graphics.drawRect(0,0,_width,_height);
			graphics.endFill();
			currentLevelObjectsArray = new Array();
		}//init
		
		public var helpWindow:Window = new Window();
		public var escWindow:Window = new Window();
		public var escWindowButtonMain:Button = new Button();
		public var escWindowButtonRestart:Button = new Button();
		public var escWindowButtonNext:Button = new Button();
		public var informer:Informer;
		public var helpWindowText:HelpText_mc = new HelpText_mc();
		public var escWindowDesc:ExtText;
		private function initGameGui():void
		{
			guiMc = new MovieClip();
			
			scoresMc = new ScoresInfo();
			scoresMc.x = 100;
			scoresMc.y = 30;
			
			hpMc = new HpBar();
			hpMc.x = 20;
			hpMc.y = 480;
			
			timeMc = new TimeMc();
			timeMc.x = Main.appWidth / 2;
			timeMc.y = 30;
			timeMc.mouseChildren = false;
			timeMc.mouseEnabled = false;
			
			messageMc = new messageText();
			messageMc.x = Main.appWidth / 2;
			messageMc.y = 200;
			messageMc.visible = false;
			
			informer = new Informer();
			informer.x = Main.appWidth / 2;
			informer.y = 400;
			
			guiMc.addChild(scoresMc);
			guiMc.addChild(hpMc);
			guiMc.addChild(timeMc);
			guiMc.addChild(messageMc);
			guiMc.addChild(informer);
			
			addChild(guiMc);
			guiMc.mouseEnabled = false;
			
			// help window button OK
			helpWindow.show(Main.appWidth/2);
			helpWindow.y = 250;
			helpWindow.addChild(helpWindowText);
			helpWindowText.mouseEnabled = false;
			helpWindowText.mouseChildren = false;
			helpWindowText.scaleX = helpWindowText.scaleY = 0.8;
			helpWindowText.x = -(helpWindowText.width/2)*0.8;
			helpWindowText.y = -180;
			helpWindow._closeButton.addEventListener(MouseEvent.MOUSE_DOWN, helpWindowOkClick);
			
			MouseEventManager.addElement(new MouseEventObject(helpWindow._closeButton, MouseEvent.MOUSE_DOWN, helpWindowOkClick));
			
			// esc window
			escWindow.y = 250;
			escWindow._closeButton.visible = false;
			
			escWindowButtonRestart.setText("Restart");
			escWindowButtonRestart.x = -escWindowButtonRestart.width / 2;
			escWindowButtonRestart.y = 0;
			escWindow.addChild(escWindowButtonRestart);
			escWindowButtonRestart.addEventListener(MouseEvent.MOUSE_DOWN, escWindowRestartButtonClick);
			MouseEventManager.addElement(new MouseEventObject(escWindowButtonRestart, MouseEvent.MOUSE_DOWN, escWindowRestartButtonClick));
			
			escWindowButtonNext.setText("Next Level");
			escWindowButtonNext.x = -escWindowButtonRestart.width / 2;
			escWindowButtonNext.y = 50;
			escWindow.addChild(escWindowButtonNext);
			escWindowButtonNext.addEventListener(MouseEvent.MOUSE_DOWN, escWindowNextButtonClick);
			MouseEventManager.addElement(new MouseEventObject(escWindowButtonNext, MouseEvent.MOUSE_DOWN, escWindowNextButtonClick));
			
			escWindowButtonMain.setText("Main Menu");
			escWindowButtonMain.x = -escWindowButtonMain.width / 2;
			escWindowButtonMain.y = 100;
			escWindow.addChild(escWindowButtonMain);
			escWindowButtonMain.addEventListener(MouseEvent.MOUSE_DOWN, escWindowMainMenuButtonClick);
			MouseEventManager.addElement(new MouseEventObject(escWindowButtonMain, MouseEvent.MOUSE_DOWN, escWindowMainMenuButtonClick));
			
			// desc
			escWindowDesc = new ExtText(0xff0000, "Arial", 25);
			escWindowDesc.setParams(-200, -35, 400, 50);
			escWindowDesc.setText("");
			escWindowDesc.setAlign(TextFormatAlign.CENTER);
			escWindow.addChild(escWindowDesc);
			
			addChild(helpWindow);
			addChild(escWindow);
			
		}//initGameGui
		
		private function helpWindowOkClick(me:MouseEvent):void
		{
			// unpause here
			unpauseGame();
			Main.showAndHideBlackFg();
		}//helpWindowOkClick
		
		private function escWindowMainMenuButtonClick(me:MouseEvent):void
		{
			ScoreData.setTotalScore(Gameplay.gameStars);
			if (levelCompleted)
			{
				//ScoreData.addScores(Gameplay.gameStars, currentLevelLocation, levelIndex);
				
				
				
				// unlock next level
				// determine new level and location indices
				var newLevelLocation:String = "";
				var newLevelIndex:int = 0;
				var currentLocationLevelsCount:int = 0;
				if (currentLevelLocation == "winter")currentLocationLevelsCount = LevelList.levelsWinter.length;
				if (currentLevelLocation == "desert")currentLocationLevelsCount = LevelList.levelsDesert.length;
				if (currentLevelLocation == "sea") currentLocationLevelsCount = LevelList.levelsOcean.length;
				
				if (levelIndex >= (currentLocationLevelsCount - 1))
				{
				// next location
				if (currentLevelLocation == "winter") 
				{
					newLevelLocation = "desert";
					ScoreData.locationsLocked[1] = false;
				}
				if (currentLevelLocation == "desert") 
				{
					newLevelLocation = "sea";
					ScoreData.locationsLocked[2] = false;
				}
				if (currentLevelLocation == "sea")
				{
					newLevelLocation = "sea";
					//SimpleTracerPanel.traceString("GAME COMPLETED!");
				}
				newLevelIndex = 0;
				}
				else
				{
					// just next level
					newLevelLocation = currentLevelLocation;
					newLevelIndex = levelIndex + 1;
				}
				//
				ScoreData.isLevelLocked(newLevelLocation, newLevelIndex, true);
				
			}// levelCompleted
			HelpTextControl.setActiveHelpText(mainRef.mainMenu.helpTextMc);
			restartLevel();
			escWindow.hide(1500);
			unpauseGame();
			this.visible = false;
			mainRef.mainMenu.visible=true;
			mainRef.mainBackGround.visible=true;
			mainRef.mainMenu.playingGame = false;
			Main.showAndHideBlackFg();
			
			SoundManager.mainMenuMusicPlaying = true;
			SoundManager.gameMusicPlaying = false;
			
		}//escWindowMainMenuButtonClick
		
		private function escWindowRestartButtonClick(me:MouseEvent):void
		{
			restartLevel();
			unpauseGame();
			escWindow.hide(1500);
			Main.showAndHideBlackFg();
		}//escWindowRestartButtonClick
		
		private var newLocationLevels:Array;
		private function escWindowNextButtonClick(me:MouseEvent):void
		{
			var gameCompleted:Boolean = false;
			escWindow.hide(1500);
			ScoreData.addScores(Gameplay.gameStars, currentLevelLocation, levelIndex);
			//SimpleTracerPanel.traceString("total scores :"+ScoreData.getTotalScores());
			// determine new level and location indices
			var newLevelLocation:String = "";
			var newLevelIndex:int = 0;
			//SimpleTracerPanel.traceString("current level index: "+levelIndex);
			//SimpleTracerPanel.traceString("current level location: " + currentLevelLocation);
			var currentLocationLevelsCount:int = 0;
			if (currentLevelLocation == "winter")currentLocationLevelsCount = LevelList.levelsWinter.length;
			if (currentLevelLocation == "desert")currentLocationLevelsCount = LevelList.levelsDesert.length;
			if (currentLevelLocation == "sea") currentLocationLevelsCount = LevelList.levelsOcean.length;
			//SimpleTracerPanel.traceString("current location levels count: " + currentLocationLevelsCount);
			if (levelIndex >= (currentLocationLevelsCount - 1))
			{
				// next location
				if (currentLevelLocation == "winter") 
				{
					newLevelLocation = "desert";
					ScoreData.locationsLocked[1] = false;
				}
				if (currentLevelLocation == "desert") 
				{
					newLevelLocation = "sea";
					ScoreData.locationsLocked[2] = false;
				}
				if (currentLevelLocation == "sea")
				{
					newLevelLocation = "sea";
					gameCompleted = true;
					//SimpleTracerPanel.traceString("GAME COMPLETED!");
				}
				newLevelIndex = 0;
			}
			else
			{
				// just next level
				newLevelLocation = currentLevelLocation;
				newLevelIndex = levelIndex + 1;
			}
			// end new level and location indices
			//SimpleTracerPanel.traceString("new location and level : " + newLevelLocation + " " + newLevelIndex);
			
			// unlock next level!
			ScoreData.isLevelLocked(newLevelLocation, newLevelIndex, true);
			
			// determine levels array
			switch(newLevelLocation)
			{
			case "winter":
			newLocationLevels = LevelList.levelsWinter;
			break;
			
			case "desert":
			newLocationLevels = LevelList.levelsDesert;
			break;
			
			case "sea":
			newLocationLevels = LevelList.levelsOcean;
			break;
			
			default:
			}
			// end // determine levels array
			
			// set level objects
			levelIndex = newLevelIndex;
			currentLevelObjectsArray = newLocationLevels[levelIndex].levelObjects;
			currentLevelLocation = newLocationLevels[levelIndex].levelLocation;
			currentLevelObjectsStringArray = newLocationLevels[levelIndex].levelObjectsStringArray;
			leftSeconds = newLocationLevels[levelIndex].time;
			leftSecondsInitial = newLocationLevels[levelIndex].time;
			levelEnd = newLocationLevels[levelIndex].levelEnd;
			initLevel();
			restartLevel();
			unpauseGame();
			
			if (gameCompleted)
			{
				escWindowMainMenuButtonClick(null);
			}//
			
			Main.showAndHideBlackFg();
			
		}//escWindowNextButtonClick
		
		public function showHelpWindow():void
		{
			helpWindow.visible = true;
			HelpTextControl.setActiveHelpText(helpWindowText);
			HelpTextControl.goSpecialPage(0);
		}//showHelpWindow
		
		// update GUI called on enter frame
		private function updateGUI():void
		{
			// update health bar
			hpMc.line.width = _playerShip.health * 2;
			
			// update timer
			var minuts:int = 0;
			var sec:int = 0;
			
			sec = leftSeconds % 60;
			minuts = leftSeconds / 60;
			
			var minStr:String = "";
			var secStr:String = "";
			if (minuts < 10) minStr = "0";
			if (sec < 10) secStr = "0";
			minStr += "" + minuts;
			secStr += "" + sec;
			
			timeMc.txt.text = minStr + ":" + secStr;
			scoresMc.txt.text = "" + Gameplay.gameStars;
			
			// if level completed - show next level button
			if (levelCompleted)
			{
				escWindowButtonNext.visible = true;
			}
			else
			{
				escWindowButtonNext.visible = false;
			}
			// end next level button show
			
			informer.update();
			
		}//updateGUI
		
		
	}//class
}//pack