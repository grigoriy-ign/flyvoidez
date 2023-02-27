package game 
{
	import criadone.utils.SimpleTracerPanel;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import geom.P2d;
	import geom.Triagulation;
	import geom.Triangle;
	import objects.library.StaticGround;
	/**
	 * ...
	 * @author 
	 */
	public class GamePhysics
	{
		
		public static var COLLISION_NONE:int = 0;
		public static var COLLISION_GROUND:int = 1;
		public static var COLLISION_BONUS:int = 2;
		
		private static var minDistance:Number=500;
		
		private static var curPntCp:P2d=new P2d(0,0);
		private static var pnt1cp:P2d=new P2d(0,0);
		private static var pnt2cp:P2d=new P2d(0,0);
		private static var pnt3cp:P2d=new P2d(0,0);
		
		/**
		 * 
		 * @param	checkingObject			object that will be checked
		 * @param	objectsArray			array of objects that will be checked
		 * @param	resultArray				result of intersections
		 */
		public static function checkIntersectionObject(checkingObject:StaticGround,objectsArray:Array,resultArray:Array):int
		{

			var i:int=0;
			var objectsCount:int=objectsArray.length;
			for(i=0;i< objectsCount;i++)
			{
				var curObj:StaticGround = objectsArray[i];
				if (curObj.visible)
				{
				// determine distance
				var distx:Number=curObj.position.x-checkingObject.position.x;
				var disty:Number=curObj.position.y-checkingObject.position.y;
				if(distx<0)distx*=-1;
				if(disty<0)disty*=-1;
				
				var continueCheck:Boolean=false;
				if((distx< minDistance)&&(disty< minDistance))continueCheck=true;
				if(continueCheck)
				{
					// check if one of the object's points located in the one of the other object's triangles
					var checkObjectsLength:int=checkingObject.points.length;
					for(var j:int=0; j< checkObjectsLength; j++)
					{
						var curPoint:P2d=checkingObject.points[j];
						var trianglesLength:int=curObj.triangles.length;
						for(var k:int=0; k< trianglesLength; k++)
						{
							var curTrg:Triangle=curObj.triangles[k];
							var p1Index:int=curTrg.p1;	var p2Index:int=curTrg.p2;	var p3Index:int=curTrg.p3;
							var pnt1:P2d=curObj.points[p1Index];
							var pnt2:P2d=curObj.points[p2Index];
							var pnt3:P2d=curObj.points[p3Index];
							
							curPntCp.x=curPoint.x;
							curPntCp.y=curPoint.y;
							
							pnt1cp.x=pnt1.x;	pnt1cp.y=pnt1.y;
							pnt2cp.x=pnt2.x;	pnt2cp.y=pnt2.y;
							pnt3cp.x=pnt3.x;	pnt3cp.y=pnt3.y;
							
							// add position
							curPntCp.x+=checkingObject.position.x;
							curPntCp.y+=checkingObject.position.y;
							
							pnt1cp.x+=curObj.position.x;	pnt1cp.y+=curObj.position.y;
							pnt2cp.x+=curObj.position.x;	pnt2cp.y+=curObj.position.y;
							pnt3cp.x+=curObj.position.x;	pnt3cp.y+=curObj.position.y;
							//
							var res:Boolean=Triagulation.isInTriangle(curPntCp,pnt1cp,pnt2cp,pnt3cp);
							//
							//SimpleTracerPanel.traceString("point in triangles "+res);
							//SimpleTracerPanel.traceString(""+res);
							if (res == true)
							{
								if (curObj.isBonus==true)
								{
									Gameplay.lastCollisionBonusType = curObj.bonusType;
									Gameplay.lastCollisionObjIndex = i;
									return GamePhysics.COLLISION_BONUS;
								}
								else
								{
									return GamePhysics.COLLISION_GROUND;
								}
							}
						}//end for k
					}// end for j
					//
					
					checkObjectsLength = curObj.points.length;
					for (j = 0; j < checkObjectsLength; j++)
					{
						curPoint = curObj.points[j];	// current object's point
						trianglesLength = checkingObject.triangles.length; // number of triangles in player ship
						for (k = 0; k < trianglesLength; k++)
						{
							curTrg = checkingObject.triangles[k];
							p1Index=curTrg.p1;	p2Index=curTrg.p2;	p3Index=curTrg.p3;
							pnt1 = checkingObject.points[p1Index];
							pnt2 = checkingObject.points[p2Index];
							pnt3 = checkingObject.points[p3Index];
							
							curPntCp.x=curPoint.x;
							curPntCp.y=curPoint.y;
							
							pnt1cp.x = pnt1.x;	pnt1cp.y = pnt1.y;
							pnt2cp.x = pnt2.x;	pnt2cp.y = pnt2.y;
							pnt3cp.x = pnt3.x;	pnt3cp.y = pnt3.y;
							
							// add position
							curPntCp.x+=curObj.position.x;
							curPntCp.y+=curObj.position.y;
							
							pnt1cp.x+=checkingObject.position.x;	pnt1cp.y+=checkingObject.position.y;
							pnt2cp.x+=checkingObject.position.x;	pnt2cp.y+=checkingObject.position.y;
							pnt3cp.x+=checkingObject.position.x;	pnt3cp.y+=checkingObject.position.y;
							
							res=Triagulation.isInTriangle(curPntCp,pnt1cp,pnt2cp,pnt3cp);
							//
							if (res == true) 
							{
								if (curObj.isBonus==true)
								{
									Gameplay.lastCollisionBonusType = curObj.bonusType;
									Gameplay.lastCollisionObjIndex = i;
									return GamePhysics.COLLISION_BONUS;
								}
								else
								{
									return GamePhysics.COLLISION_GROUND;
								}
							}
							
						}//end k
					}//end j
					
				}//end if continue check
				}// end if curObj visible
				//
			}//end for i
			return 0;
		}
		// end check intersection object
		
	//class	
	}
}