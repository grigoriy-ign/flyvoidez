package display 
{
	import display.effects.Effect;
	import flash.display.Sprite;
	/**
	 * ...
	 * 
	 */
	public class RenderEffects 
	{
		
		public static function render(effectsArray:Array,spr:Sprite):void
		{
			for (var i:int = 0; i < effectsArray.length; i++)
			{
				var curEffect:Effect = effectsArray[i];
				if (curEffect.visible)
				{
					curEffect.drawEffect(spr);
				}
			}//end for i
			
		}//render
		
		
		
	}//class

}//pack