package display.effects 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import resources.Resources;
	/**
	 * ...
	 * 
	 */
	public class GravityEffect extends Effect
	{
		
		private var particles:Array;
		
		public var power:int = 10;
		public var active:Boolean = true;
		public var drawnCnt:int = 0;
		
		public var btm:Bitmap;
		private var mtr:Matrix = new Matrix();
		
		public function GravityEffect()
		{
			btm = new Resources.gravity_effect();
			particles = new Array();
			for (var i:int = 0; i < 25; i++)
			{
				var obj:ParticleObject = new ParticleObject();
				obj.x = -50 + Math.random() * 100;
				obj.y = -5 + Math.random() * 10;
				obj.speedX = -6 + Math.random() * 12;
				obj.speedY = -6 + Math.random() * 12;
				obj.size = 1+Math.random()*9;
				particles.push(obj);
			}
		}//CollisionEffect
		
		override public function drawEffect(spr:Sprite):void
		{
			drawnCnt = 0;
			var curPart:ParticleObject;
			for (var i:int = 0; i < particles.length; i++)
			{
				curPart = particles[i];
				
				curPart.x += curPart.speedX;
				curPart.y += curPart.speedY;
				curPart.size -= 5+Math.random()*3;
				
				if (curPart.size < 0) // reset particle
				{
					if (active)
					{
					curPart.x = -50 + Math.random() * 100;
					curPart.y = -5 + Math.random() * 10;
					curPart.speedX = -2 + Math.random() * 4;
					curPart.speedY = -2 + Math.random() * 4;
					curPart.size = 5+Math.random()*25;
					}
					else
					{
						curPart.size = 0;
					}
				}//end if
				
				if (curPart.size > 0)
				{
					if (drawnCnt < power)
					{
					mtr.tx = curPart.x+posX;
					mtr.ty = curPart.y+posY;
					mtr.a = 0.3;
					mtr.d = 0.3;
					spr.graphics.beginBitmapFill(btm.bitmapData, mtr, false, false);
					spr.graphics.drawRect(curPart.x+posX, curPart.y+posY, curPart.size, curPart.size);
					spr.graphics.endFill();
					drawnCnt++;
					}
					
				}
				
			}//i
			
		}//drawEffect
		
	}//class

}//pack