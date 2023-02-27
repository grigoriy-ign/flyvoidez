package game 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import resources.Resources;
	/**
	 * ...
	 * 
	 */
	public class GameEffects 
	{	
		
		// draws damage layer effects used when player ship contacts with ground objects
		public static function drawDamageLayerEffect(spr:Sprite):void
		{
			var dmgBitmap:Bitmap = new Resources.damage_layer_effect();
			spr.graphics.beginBitmapFill(dmgBitmap.bitmapData, null, false, false);
			spr.graphics.drawRect(0, 0, 300, 214);
			spr.graphics.endFill();
		}//drawDamageLayerEffect
		
		// draws damage layer effects used when player ship contacts with ground objects
		public static function drawExplosionLayerEffect(spr:Sprite):void
		{
			var dmgBitmap:Bitmap = new Resources.explosion_image();
			var mtr:Matrix = new Matrix();
			mtr.tx = -50;
			mtr.ty = -50;
			spr.graphics.beginBitmapFill(dmgBitmap.bitmapData, mtr, false, false);
			spr.graphics.drawRect(-50, -50, 100, 100);
			spr.graphics.endFill();
		}//drawDamageLayerEffect
		
		// shakes given sprite to simulate vibration in case of collision
		public static function shakeSprite(spr:DisplayObjectContainer,amount:Number):void
		{
			spr.x = Math.random() * amount;
			spr.y = Math.random() * amount;
		}//shakeSprite
		
	}//class

}//pack game