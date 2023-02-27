package display.effects 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import game.LevelEditor;
	import resources.Resources;
	/**
	 * ...
	 * 
	 */
	public class BuffEffect extends Effect
	{
		
		private var particles:Array;
		
		public var power:int = 10;
		public var active:Boolean = true;
		public var drawnCnt:int = 0;

		private var mtr:Matrix = new Matrix();
		
		public var boomed:Boolean = false;
		
		public function BuffEffect()
		{
			particles = new Array();
			for (var i:int = 0; i < 10; i++)
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
					spr.graphics.beginFill(color, 0.5);
					spr.graphics.drawEllipse((curPart.x + posX) - curPart.size / 2, (curPart.y + posY) - curPart.size / 2, curPart.size, curPart.size);
					spr.graphics.endFill();
				}//
				
			}//i
			
		}//drawEffect
		
		private var color:int = 0;
		public function boom(bonusIndex:int):void
		{
			color=setColor(bonusIndex);
			if (boomed == false)
			{
			var curPart:ParticleObject;
			for (var i:int = 0; i < particles.length; i++)
			{
				curPart = particles[i];
				
					curPart.x = -1 + Math.random() * 2;
					curPart.y = -1 + Math.random() * 2;
					curPart.speedX = -4 + Math.random() * 8;
					curPart.speedY = -4 + Math.random() * 8;
					curPart.size = 10+Math.random()*10;
			}//i
			boomed = true;
			}
		}//boom
		
		private function setColor(bonusIndex:int):int
		{
			if (bonusIndex == LevelEditor.BONUS_STAR)
			{
				return 0xffaa00;
			}
			if (bonusIndex == LevelEditor.BONUS_HEALTH)
			{
				return 0x00ff00;
			}
			if (bonusIndex == LevelEditor.BONUS_TIME)
			{
				return 0xffff00;
			}
			if (bonusIndex == LevelEditor.BONUS_BOOST)
			{
				return 0xff0000;
			}
			if (bonusIndex == LevelEditor.BONUS_REVERSE)
			{
				return 0xffffff;
			}
			if (bonusIndex == LevelEditor.BONUS_RANDOM)
			{
				return 0x0000ff;
			}
			return 0xffffff;
		}//setColor
		
	}//class

}//pack