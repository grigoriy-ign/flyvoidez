package objects.library 
{
	import geom.P2d;
	import geom.Triangle;
	import objects.IngameObject;
	
	/**
	 * ...
	 * @author 
	 */
	public class StaticGround extends IngameObject
	{
		
		//public var points:Vector.<P2d>;
		//public var triangles:Array;
		//public var selected:Boolean=false;
		
		public function StaticGround() 
		{
			//points=new Vector.<P2d>();
			//triangles=new Array();
		}
	
		public function addPoint(px:Number,py:Number):void
		{
			points[points.length]=new P2d(px,py);
		}
		
		public function addTriangle(ind1:int,ind2:int,ind3:int):void
		{
			triangles[triangles.length]=new Triangle(ind1,ind2,ind3);
		}
		
		
		
		// ____________________________________________________________________________
	}
}