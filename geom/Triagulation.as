package geom 
{
	import criadone.utils.SimpleTracerPanel;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author 
	 */
	public class Triagulation
	{
		
		private static var direction:int;
		
		private static var points:Vector.<P2d>;
		private static var deletedPoints:Vector.<Boolean>=new Vector.<Boolean>();
		
		private static var p1:P2d=new P2d(0,0);
		private static var p2:P2d=new P2d(0,0);
		private static var p3:P2d=new P2d(0,0);
		private static var tp1:P2d=new P2d(0,0);
		private static var tp2:P2d=new P2d(0,0);
		private static var tp3:P2d=new P2d(0,0);
		
		private static var lastTriangleIndices:Vector.<int>=new Vector.<int>();
		
		private static var checkingPoint:P2d;
		private static var tp1ind:int=0;
		private static var tp2ind:int=1;
		private static var tp3ind:int=2;
		
		private static var pointsCount:int=0;
		private static var pointsCountConst:int=0;
		private static var newTriangle:Boolean=false;
		
		private static var debug:Boolean=false;
		
		
		public static function isInTriangle(point:P2d,t1:P2d,t2:P2d,t3:P2d):Boolean
		{
			var a:int, b:int, c:int;
			a = vp( point, t1, t2 );
			b = vp( point, t2, t3 );
			c = vp( point, t3, t1 );
			
			return ( (a < 0 && b < 0 && c < 0) || (a > 0 && b > 0 && c > 0) );	
		}
		
		public static function triangulate(polyPoints:Vector.<P2d>,triangles:Array):void
		{
			var trgstart:int=getTimer();
			if(debug)SimpleTracerPanel.traceString("Triangulation Started");
			points=polyPoints;
			if(polyPoints.length>3)
			{
				
				deletedPoints.length=0;
				for(var i:int=0;i< polyPoints.length;i++)
				{
					deletedPoints[i]=true;
					if(debug)SimpleTracerPanel.traceString("points are not deleted? "+deletedPoints[i]);
				}
				lastTriangleIndices.length=0;
				
				pointsCount=polyPoints.length;
				pointsCountConst=pointsCount;
				tp1ind=0;
				tp2ind=1;
				tp3ind=2;
				
				tp1=polyPoints[0];
				tp2=polyPoints[1];
				tp3=polyPoints[2];
				
				if(debug)SimpleTracerPanel.traceString("Points Count = "+pointsCount);
				
				
				determineDirection();
				if(debug)SimpleTracerPanel.traceString("dir "+direction);
				if(debug)SimpleTracerPanel.setSymbolLimit(10000000);
				
				var sttime:int=getTimer();
				var endtime:int=getTimer();
				
				while(pointsCount!=3)
				{
					endtime=getTimer();
					if(endtime-sttime>1000)
					{
						SimpleTracerPanel.traceString("ERROR! Infinite Loop. Triangulation Failed!");
						return;
					}
					if(debug)SimpleTracerPanel.traceString("start while "+tp1ind+" "+tp2ind+" "+tp3ind);
					
					//
					tp1=polyPoints[tp1ind];
					tp2=polyPoints[tp2ind];
					tp3=polyPoints[tp3ind];
					if(debug)SimpleTracerPanel.traceString("start while "+tp1ind+" "+tp2ind+" "+tp3ind+" is == to up?");
					//
					if(debug)SimpleTracerPanel.traceString("direction result "+(vp(tp2,tp1,tp3)*direction));
					if(vp(tp2,tp1,tp3)*direction<0)
					//if(true)
					{
						if(debug)SimpleTracerPanel.traceString("Good Angle!");
						//SimpleTracerPanel.traceString("right angle < 180 "+tp1ind+" "+tp2ind+" "+tp3ind);
						newTriangle=true;
						
						if(debug)SimpleTracerPanel.traceString("Start check if some vertice in triangle");
						for(var j:int=0;j< pointsCountConst;j++)
						{
							checkingPoint=polyPoints[j];
							if(debug)SimpleTracerPanel.traceString("check point "+j);
							if(isInTriangle(checkingPoint,tp1,tp2,tp3))
							{
								if(debug)SimpleTracerPanel.traceString("point "+j+" is in current triangle");
								newTriangle=false;
								if(debug)SimpleTracerPanel.traceString("Move vertice 1 before: "+tp1ind);
								tp1ind=nextIndex(tp1ind);tp1=polyPoints[tp1ind];
								if(debug)SimpleTracerPanel.traceString("Move vertice 1  after: "+tp1ind);
								break;
							}
						}//end for j
						if(newTriangle)
						//if(true)
						{
						if(debug)SimpleTracerPanel.traceString("Adding a new Triangle!");
						
						deletedPoints[tp2ind]=false;
						pointsCount--;
						if(debug)SimpleTracerPanel.traceString("Point "+tp2ind+" deleted");
						if(debug)SimpleTracerPanel.traceString("Points Left: "+pointsCount);
						triangles.push(new Triangle(tp1ind,tp2ind,tp3ind));
						if(debug)SimpleTracerPanel.traceString("Push new Triangle "+tp1ind+" "+tp2ind+" "+tp3ind);
						}
						//move 2,3
						if(debug)SimpleTracerPanel.traceString("before 2 vertices moved "+tp1ind+" "+tp2ind+" "+tp3ind);
						tp2ind=nextIndex(tp2ind);tp2=polyPoints[tp2ind];
						tp3ind=nextIndex(tp3ind);tp3=polyPoints[tp3ind];
						if(debug)SimpleTracerPanel.traceString("after 2 vertices moved "+tp1ind+" "+tp2ind+" "+tp3ind);
						//
					}
					else 
					{
						if(debug)SimpleTracerPanel.traceString("Bad Angle!");
						
						if(debug)SimpleTracerPanel.traceString("before moving 3 points "+tp1ind+" "+tp2ind+" "+tp3ind);
						tp1ind=nextIndex(tp1ind);tp1=polyPoints[tp1ind];
						tp2ind=nextIndex(tp2ind);tp2=polyPoints[tp2ind];
						tp3ind=nextIndex(tp3ind);tp3=polyPoints[tp3ind];
						if(debug)SimpleTracerPanel.traceString(" after moving 3 points "+tp1ind+" "+tp2ind+" "+tp3ind);
					}
				}
				
				// last triangle
				for(i=0;i< polyPoints.length;i++)
				{
					if(deletedPoints[i])
					{
						lastTriangleIndices.push(i);
					}
				}
				if(debug)if(lastTriangleIndices.length>3)SimpleTracerPanel.traceString("ERROR! Last Trg indices > 3");
				triangles.push(new Triangle(lastTriangleIndices[0],lastTriangleIndices[1],lastTriangleIndices[2]));
				if(debug)SimpleTracerPanel.traceString("Adding last Triangle "+lastTriangleIndices[0]+" "+lastTriangleIndices[1]+" "+lastTriangleIndices[2]);
				
				SimpleTracerPanel.traceString("Triangulation Completed! "+(getTimer()-trgstart));
				
			}//if > 3 -> start
		}//end triangulation
		
		// __________________________________________________________________________ PRIVATE
		
		private static function nextIndex(ind:int):int
		{
			//SimpleTracerPanel.traceString("next index start: "+ind);
			var pointFound:Boolean=false;
			while(!pointFound)
			{
				ind++;
				if(ind> pointsCountConst-1)ind=0;
				if(deletedPoints[ind])pointFound=true;
			}
			return ind;
			//SimpleTracerPanel.traceString("next index end: "+ind);
		}//nextIndex
		
		
		private static function vp(a:P2d,b:P2d,c:P2d):Number
		{ 
			return (a.x*b.y - a.x*c.y - b.x*a.y + b.x*c.y + c.x*a.y - c.x*b.y);
		}
		
		
		private static function scp(a:P2d,b:P2d,c:P2d):Number
		{
			return( (c.x - b.x)*(a.x - b.x) + (c.y - b.y)*(a.y - b.y) );
		}
		
		 
		private static function determineDirection():void
		{
			var maxx:int = points[0].x;
			var maxind:int = 0;
 
		
			for(var i:int=0;i< points.length;i++)
			{
				if(maxx< points[i].x)
				{
					maxx=points[i].x;
					maxind=i;
				}
			}
			if(debug)SimpleTracerPanel.traceString("direction-maxx-point = "+maxind);
			
			var pind:int=maxind;
			p2 = points[pind];
			pind--;if(pind< 0)pind=pointsCountConst-1;
			p1 = points[pind];
			pind+=2;if(pind> pointsCountConst-1)pind=0;
			p3 = points[pind];
			
			
			if( vp( p1, p2, p3 ) > 0 )	direction = 1 else direction = -1;
			
		}//end determine direction
		
		// ________________________________________________________________________________________
		
	}//class
}