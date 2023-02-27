package game 
{
	/**
	 * ...
	 * @author 
	 */
	
	import geom.P2d;
	import geom.Triangle;
	 
	public class PlayerShip
	{
		
		public var pointsData:Vector.<P2d>;
		public var trianglesData:Array;
		
		public var health:Number = 100;
		
		// MOVING
		public var speedX:Number=0;
		public var speedY:Number=0;
		
		public function PlayerShip() 
		{
			pointsData=new Vector.<P2d>();
			trianglesData=new Array();
			initMesh();
		}
		
		
		
		// PRIVATE
		
		private function initMesh():void
		{
			pointsData[pointsData.length]=new P2d(-55.47,8.30);
			pointsData[pointsData.length]=new P2d(-38.92,10.15);
			pointsData[pointsData.length]=new P2d(-26.42,11.70); //2
			pointsData[pointsData.length]=new P2d(-18.62,14.50);
			pointsData[pointsData.length]=new P2d(-9.82,14.50);
			pointsData[pointsData.length]=new P2d(6.73,15.80);
			pointsData[pointsData.length]=new P2d(21.73,16.40);
			pointsData[pointsData.length]=new P2d(34.23,16.40);
			pointsData[pointsData.length]=new P2d(47.02,15.80);
			pointsData[pointsData.length]=new P2d(55.77,13.60);
			pointsData[pointsData.length]=new P2d(59.52,11.10);
			pointsData[pointsData.length]=new P2d(50.18,6.40);
			pointsData[pointsData.length]=new P2d(37.02,2.65);
			pointsData[pointsData.length]=new P2d(29.52,1.10);
			pointsData[pointsData.length]=new P2d(18.88,-4.20);
			pointsData[pointsData.length]=new P2d(13.88,-5.50);
			pointsData[pointsData.length]=new P2d(-0.17,-5.80);
			pointsData[pointsData.length]=new P2d(-8.92,-8.60);
			pointsData[pointsData.length]=new P2d(-17.32,-11.40);
			pointsData[pointsData.length]=new P2d(-30.77,-14.55);
			pointsData[pointsData.length]=new P2d(-41.42,-16.40); //21
			pointsData[pointsData.length]=new P2d(-51.13,-16.40);
			pointsData[pointsData.length]=new P2d(-59.22,-15.80);
			pointsData[pointsData.length]=new P2d(-59.52,-12.65);
			pointsData[pointsData.length]=new P2d(-54.82,-11.10);
			pointsData[pointsData.length]=new P2d(-50.77,-9.20);
			pointsData[pointsData.length]=new P2d(-47.32,-6.40); //27
			pointsData[pointsData.length]=new P2d(-46.13,-3.00);
			pointsData[pointsData.length]=new P2d(-55.47,-3.00);
			
			trianglesData[trianglesData.length]=new Triangle(2,3,4);
			trianglesData[trianglesData.length]=new Triangle(2,4,5);
			trianglesData[trianglesData.length]=new Triangle(2,5,6);
			trianglesData[trianglesData.length]=new Triangle(2,6,7);
			trianglesData[trianglesData.length]=new Triangle(2,7,8);
			trianglesData[trianglesData.length]=new Triangle(2,8,9);
			trianglesData[trianglesData.length]=new Triangle(2,9,10);
			trianglesData[trianglesData.length]=new Triangle(2,10,11);
			trianglesData[trianglesData.length]=new Triangle(2,11,12);
			trianglesData[trianglesData.length]=new Triangle(2,12,13);
			trianglesData[trianglesData.length]=new Triangle(2,13,14);
			trianglesData[trianglesData.length]=new Triangle(2,14,15);
			trianglesData[trianglesData.length]=new Triangle(2,15,16);
			trianglesData[trianglesData.length]=new Triangle(2,16,17);
			trianglesData[trianglesData.length]=new Triangle(2,17,18);
			trianglesData[trianglesData.length]=new Triangle(2,18,19);
			trianglesData[trianglesData.length]=new Triangle(2,19,20);
			trianglesData[trianglesData.length]=new Triangle(2,20,21);
			trianglesData[trianglesData.length]=new Triangle(21,22,23);
			trianglesData[trianglesData.length]=new Triangle(21,23,24);
			trianglesData[trianglesData.length]=new Triangle(21,24,25);
			trianglesData[trianglesData.length]=new Triangle(21,25,26);
			trianglesData[trianglesData.length]=new Triangle(27,28,0);
			trianglesData[trianglesData.length]=new Triangle(27,0,1);
			trianglesData[trianglesData.length]=new Triangle(27,1,2);
			//trianglesData[trianglesData.length]=new Triangle(27,2,21); // MAGIC TRIANGLE o_O
			trianglesData[trianglesData.length]=new Triangle(21,26,27);
		}//initMesh
		
	
		//CLASS
	}//class
}//pack