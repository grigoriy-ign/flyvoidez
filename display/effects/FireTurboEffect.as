package display.effects 
{
	import criadone.utils.SimpleTracerPanel;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import resources.Resources;
	/**
	 * ...
	 * 
	 */
	public class FireTurboEffect extends Effect
	{
		
		private var btm:Bitmap;
		private var btmDraw:BitmapData;
		private var mtr:Matrix = new Matrix();
		
		public function FireTurboEffect() 
		{
			btm = new Resources.fire_turbo();
		}//FireTurboEffect
		
		private var scrMtr:Matrix = new Matrix();
		override public function drawEffect(spr:Sprite):void
		{
			
			var rndX:Number= Math.random() * 5;
			var rndY:Number= Math.random() * 1;
			var newSizeX:Number = sizeX +rndX;
			var newSizeY:Number = sizeY +rndY;
			
			mtr.tx = posX;
			mtr.ty = posY;

			mtr.a = (newSizeX / (sizeXOrig / 1000)) / 1000;
			mtr.d = (newSizeY / (sizeYOrig / 1000)) / 1000;
			
			spr.graphics.beginBitmapFill(btm.bitmapData, mtr, false, true);
			spr.graphics.drawRect(posX, posY, sizeX, sizeY);
			spr.graphics.endFill();
			
		}//drawEffect
		
	}//class

}//pack