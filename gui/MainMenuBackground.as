package gui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import resources.Resources;
	
	/**
	 * ...
	 * @author 
	 */
	public class MainMenuBackground extends Sprite
	{
		
		private var _imageWinter:Bitmap;
		private var _imageDesert:Bitmap;
		private var _imageOcean:Bitmap;
		
		private var _backgrounds:Array;
		private var _randomIndex:int=0;
		
		private var drwMatrix:Matrix;
		
		public function MainMenuBackground() 
		{
			_backgrounds=new Array();
			init();
			
			_randomIndex = int(Math.random()*_backgrounds.length);
		}
		
		public function update():void
		{
			//
			drwMatrix.tx--;
			if(drwMatrix.tx<=-_backgrounds[_randomIndex].bitmapData.width)drwMatrix.tx=0;
			//
			graphics.clear();
			graphics.beginBitmapFill(_backgrounds[_randomIndex].bitmapData,drwMatrix,true,false);
			graphics.drawRect(0,0,800,500);
			graphics.endFill();
		}
		
		// _________________________________________________________________
		
		private function init():void
		{
			_imageWinter = new Resources.winter_background();
			_imageDesert = new Resources.desert_background();
			_imageOcean = new Resources.ocean_background();
			_backgrounds.push(_imageWinter);
			_backgrounds.push(_imageDesert);
			_backgrounds.push(_imageOcean);
			drwMatrix=new Matrix();
			//select random image to show
			_randomIndex=Math.random()*_backgrounds.length;
			//
		}
		
	}
}