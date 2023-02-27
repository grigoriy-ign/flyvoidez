package objects 
{
	import flash.display.Sprite;
	import geom.P2d;
	/**
	 * ...
	 * @author 
	 */
	public class IngameObject
	{
		
		public var points:Vector.<P2d>;
		public var triangles:Array;
		public var selected:Boolean=false;
		
		public var visible:Boolean=true;
		public var position:P2d;
		public var rotation:Number=0;
		
		public var positionSecond:P2d;
		public var movingSpeed:Number;
		public var rotatingSpeed:Number;
		
		public var mobility:Boolean=false;
		public var bitmapindex:int = 0;
		
		public var isBonus:Boolean = false;
		
		public var bonusType:int = 1;
		
		//
		
		private var curPoint:P2d;
		
		public function IngameObject() 
		{
			position=new P2d(0,0);
			positionSecond=new P2d(0,0);
			points=new Vector.<P2d>();
			triangles=new Array();
		}
		
		public function setRotation(angle:Number):void
		{
			var rx:Number=0; var sx:Number=0;
			var ry:Number=0; var sy:Number=0;
			
			var a:Number=(angle-rotation)*(Math.PI/180);
			var sina:Number = Math.sin(a);
			var cosa:Number = Math.cos(a);
			
			for(var i:int=0;i< points.length;i++)
			{
				curPoint=points[i];
				sx=curPoint.x;
				sy=curPoint.y;
				rx = cosa * sx + -sina * sy;
				ry = sina * sx + cosa * sy;
				curPoint.x=rx;
				curPoint.y=ry;
			}
			rotation=angle;
		}
		
		public function scale(sx:Number,sy:Number):void
		{
			for(var i:int=0;i< points.length;i++)
			{
				curPoint=points[i];
				curPoint.x*=sx;
				curPoint.y*=sy;
			}
		}
		
		
		// _________________________________________________________ PRIVATE
		
		
		
	}
}