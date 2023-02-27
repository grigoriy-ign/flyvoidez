package math 
{
	import criadone.utils.SimpleTracerPanel;
	import geom.P2d;
	/**
	 * ...
	 * @author 
	 */
	public class MinMax
	{
		
		public static function maxX_VectorP2d(vec:Vector.<P2d>):Number
		{
			var i:int=0;
			var max:Number=vec[0].x;
			for(i=0;i< vec.length;i++)
			{
				SimpleTracerPanel.traceString(" "+vec[i].x);
				if(max<vec[i].x)max=vec[i].x;
			}
			SimpleTracerPanel.traceString("max "+max);
			return max;
		}
		
		public static function maxY_VectorP2d(vec:Vector.<P2d>):Number
		{
			var i:int=0;
			var max:Number=vec[0].y;
			for(i=0;i< vec.length;i++)
			{
				SimpleTracerPanel.traceString(" "+vec[i].y);
				if(max<vec[i].y)max=vec[i].y;
			}
			SimpleTracerPanel.traceString("max "+max);
			return max;
		}
		
		public static function minX_VectorP2d(vec:Vector.<P2d>):Number
		{
			var i:int=0;
			var min:Number=vec[0].x;
			for(i=0;i< vec.length;i++)
			{
				SimpleTracerPanel.traceString(" "+vec[i].x);
				if(min>vec[i].x)min=vec[i].x;
			}
			SimpleTracerPanel.traceString("min "+min);
			return min;
		}
		
		public static function minY_VectorP2d(vec:Vector.<P2d>):Number
		{
			var i:int=0;
			var min:Number=vec[0].y;
			for(i=0;i< vec.length;i++)
			{
				SimpleTracerPanel.traceString(" "+vec[i].y);
				if(min>vec[i].y)min=vec[i].y;
			}
			SimpleTracerPanel.traceString("min "+min);
			return min;
		}
		
		//
	}
}