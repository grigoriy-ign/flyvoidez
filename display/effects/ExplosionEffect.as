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
	public class ExplosionEffect extends Effect
	{
		
		private var particles:Array;
		
		public var power:int = 10;
		public var active:Boolean = true;
		public var drawnCnt:int = 0;
		
		public var btm:Bitmap;
		private var mtr:Matrix = new Matrix();
		
		public var boomed:Boolean = false;
		
		public function ExplosionEffect() 
		{
			
			btm = new Resources.boom_particle();
			particles = new Array();
			for (var i:int = 0; i < 50; i++)
			{
				var obj:ParticleObject = new ParticleObject();
				obj.x = -10 + Math.random() * 20;
				obj.y = -10 + Math.random() * 20;
				obj.speedX = -4 + Math.random() * 8;
				obj.speedY = -4 + Math.random() * 8;
				obj.size = 0.1;
				particles.push(obj);
			}//i
			
		}//constr
		
		override public function drawEffect(spr:Sprite):void
		{
			
			var curPart:ParticleObject;
			for (var i:int = 0; i < particles.length; i++)
			{
				curPart = particles[i];
				
				curPart.x += curPart.speedX;
				curPart.y += curPart.speedY;
				curPart.size -= 1;
				
				if (curPart.size < 0) // reset particle
				{
					if (active)
					{
						/*
						curPart.x = -10 + Math.random() * 20;
						curPart.y = -10 + Math.random() * 20;
						curPart.speedX = -6 + Math.random() * 12;
						curPart.speedY = -6 + Math.random() * 12;
						curPart.size = 30+Math.random()*30;
						*/
					}
					else
					{
						curPart.size = 0;
					}
				}//end if
				
				if (curPart.size > 0)
				{
					mtr.tx = (curPart.x + posX)-curPart.size/2;
					mtr.ty = (curPart.y + posY)-curPart.size/2;
					
					mtr.a = (curPart.size / (50 / 1000)) / 1000;
					mtr.d = (curPart.size / (50 / 1000)) / 1000;
					
					spr.graphics.beginBitmapFill(btm.bitmapData, mtr, false, false);
					spr.graphics.drawRect((curPart.x+posX)-curPart.size/2, (curPart.y+posY)-curPart.size/2, curPart.size, curPart.size);
					spr.graphics.endFill();
				}//
				
			}//i
			
		}//drawEffect
		
		public function hideEffect():void
		{
			var curPart:ParticleObject;
			for (var i:int = 0; i < particles.length; i++)
			{
				curPart = particles[i];
				curPart.size = -1;
			}
		}// hideEffect
		
		public function boom():void
		{
			if (boomed == false)
			{
			var curPart:ParticleObject;
			for (var i:int = 0; i < particles.length; i++)
			{
				curPart = particles[i];
				
					curPart.x = -10 + Math.random() * 20;
					curPart.y = -10 + Math.random() * 20;
					curPart.speedX = -4 + Math.random() * 8;
					curPart.speedY = -4 + Math.random() * 8;
					curPart.size = 30+Math.random()*30;
			}//i
			boomed = true;
			}
		}//boom
		
	}//class

}//pack