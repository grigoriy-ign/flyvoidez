package objects 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author criadone
	 */
	public class Texture 
	{
		
		
		public static const GROUND_TEXTURES_COUNT:int = 10;
		
		public var btmd:BitmapData;
		
		public function Texture(btm:Bitmap) 
		{
			btmd=btm.bitmapData;
		}
		
	}//class
}