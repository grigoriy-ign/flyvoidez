package appsound 
{
	import criadone.utils.SimpleTracerPanel;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	import resources.Resources;
	
	/**
	 * ...
	 * 
	 */
	public class SoundManager 
	{
		
		public static var SND_CLICK:int = 1;
		public static var SND_BONUS:int = 2;
		public static var SND_EXPLOSION:int = 3;
		
		private static var sndClick:Sound = new Resources.click_sound();
		private static var sndBonus:Sound = new snd_bonus();
		private static var sndExplosion:Sound = new snd_explosion();
		
		private static var musMain:Sound = new mainmenu();
		private static var gameSound:Sound = new energy();
		
		private static var collisionSound:Sound = new snd_collision();
		
		private static var musMainST:SoundTransform = new SoundTransform(1, 0);
		private static var musGameST:SoundTransform = new SoundTransform(1, 0);
		
		private static var collisionST:SoundTransform = new SoundTransform(1, 0);
		
		//
		
		private static var channels:Array = new Array();
		private static var isInit:Boolean = false;
		
		private static var mainMenuMusicCh:SoundChannel;
		private static var gameMusicCh:SoundChannel;
		
		private static var collisionCh:SoundChannel;
		
		public static var mainMenuMusicPlaying:Boolean = false;
		public static var gameMusicPlaying:Boolean = false;
		public static var collisionPlaying:Boolean = false;
		
		private static var chanIndex:int = 0;
		
		private static var soundMuted:Boolean = false;
		
		// METHODS
		
		public static function init():void
		{
			collisionCh = collisionSound.play(0, int.MAX_VALUE, collisionST);
		}// init
		
		public static function soundOff():void
		{
			soundMuted = true;
			setGameMusVolume(0);
			setMenuMusVolume(0);
		}// soundOff
		
		public static function soundOn():void
		{
			soundMuted = false;
		}// soundOn
		
		public static function setCollisionVolume(vol:Number):void
		{
			if (soundMuted) vol = 0;
			collisionST.volume = vol;
			collisionCh.soundTransform = collisionST;
		}// setCollisionVolume
		
		public static function playSound(snd:int):void
		{
			if (soundMuted == false)
			{
			var i:int = 0;
			if (isInit == false)
			{
				for (i = 0; i < 10; i++)
				{
					var ch:SoundChannel=new SoundChannel();
					channels.push(ch);
				}// end for i
				isInit = true;
			}// end if (isInit == false)
			
			var plSnd:Sound;
			if (snd == SND_CLICK) plSnd = sndClick;
			if (snd == SND_BONUS) plSnd = sndBonus;
			if (snd == SND_EXPLOSION) plSnd = sndExplosion;
			
			var cch:SoundChannel = channels[chanIndex];
			cch = plSnd.play(0, 1, null);
			
			chanIndex++;
			if (chanIndex > channels.length - 1) chanIndex = 0;
			}// end if soundMuted
		}// playSound
		
		public static function setMenuMusVolume(n:Number):void
		{
			if (soundMuted) n = 0;
			n = 0;
			musMainST.volume = n;
			mainMenuMusicCh.soundTransform = musMainST;
		}// setMenuMusVolume
		
		public static function getMenuMusVolume():Number
		{
			return musMainST.volume;
		}// getMenuMusVolume
		
		public static function setGameMusVolume(n:Number):void
		{
			if (soundMuted) n = 0;
			n = 0;
			musGameST.volume = n;
			gameMusicCh.soundTransform = musGameST;
		}// setGameMusVolume
		
		public static function getGameMusVolume():Number
		{
			return musGameST.volume;
		}// getGameMusVolume
		
		public static function playMainMenuMusic():void
		{
			mainMenuMusicCh = musMain.play(0, int.MAX_VALUE, musMainST);
		}// playMainMenuMusic
		
		public static function playGameSound():void
		{
			gameMusicCh = gameSound.play(0, int.MAX_VALUE, musGameST);
		}// playGameSound
		
		// PRIVATE
		
	}//SoundManager
}//pack