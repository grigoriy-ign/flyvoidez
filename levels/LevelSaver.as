package levels 
{
	import criadone.utils.SimpleTracerPanel;
	import geom.P2d;
	import geom.Triangle;
	import objects.IngameObject;
	import objects.library.StaticGround;
	/**
	 * ...
	 * @author 
	 */
	public class LevelSaver
	{
		
		private static var _currentObject:IngameObject;
		private static var _resStr:String;
		private static var _currentPoint:P2d;
		private static var _currentTriangle:Triangle;
		
		// ___________________________________________________________ PUBLIC
		
		/*
		 
		"(-18.50,-123.00)(-84.50,54.00)(50.50,123.00)(84.50,-53.00)_012023"
		 
		 */
		
		public static function saveLevel(objs:Array,result:String):String
		{
			result="";
			for (var i:int = 0; i < objs.length; i++) 
			{
				_currentObject = objs[i];
				var currentObjectReslult:String = "";
				
				result+='"';
					
				if (_currentObject.isBonus)
				{
					currentObjectReslult = saveBonus(_currentObject);
				}
				else
				{
					currentObjectReslult = saveStaticGround(_currentObject);
				}
					
				result += currentObjectReslult;
				result+='",\n';
				
			}//end for i
			
			return result;
		}//end save level
		
		// ___________________________________________________________ PRIVATE
		
		private static function saveStaticGround(stg:IngameObject):String
		{
			if(stg.points.length>0)	
			{
			_resStr="stg_";
			
			if(stg.mobility)_resStr+="d_" else _resStr+="s_";	
			_resStr+=stg.bitmapindex+"_";
			
			
			for (var i:int = 0; i < stg.points.length; i++) 		
			{
				_currentPoint=stg.points[i];
				_resStr+="("+_currentPoint.x.toFixed(2)+","+_currentPoint.y.toFixed(2)+")";
			}
			
			_resStr+="_";
			
			// triangles
			for(i=0;i<stg.triangles.length;i++)		
			{
				_resStr+="(";
				_currentTriangle=stg.triangles[i];
				_resStr+=_currentTriangle.p1;
				_resStr+=",";
				_resStr+=_currentTriangle.p2;
				_resStr+=",";
				_resStr+=_currentTriangle.p3;
				_resStr+=")";
			}
			
			_resStr+="_(";
			_resStr+=String(stg.position.x)+",";	
			_resStr+=String(stg.position.y)+")";
			return _resStr;
			}
			else
			{
				return "";
			}
			
		}//saveStaticGround
		
		private static function saveBonus(stg:IngameObject):String
		{
			
			if(stg.points.length>0)	
			{
			_resStr="stg_";
			
			_resStr += "b_";					
			_resStr+=stg.bitmapindex+"_";
			
			_resStr += ""+stg.bonusType;
			
			_resStr+="_(";
			_resStr+=String(stg.position.x)+",";	
			_resStr+=String(stg.position.y)+")";
			return _resStr;
			}
			else
			{
				return "";
			}
			
		}//saveBonus
		
		
		
		
		public static function savePattern(objs:Array,result:String):String
		{
			result="";
			for (var i:int = 0; i < objs.length; i++) 
			{
				_currentObject = objs[i];
				var currentObjectReslult:String = "";
				
				result+='"';
					
				if (_currentObject.isBonus)
				{
					currentObjectReslult = savePatternBonus(_currentObject);
				}
				else
				{
					currentObjectReslult = savePatternStaticGround(_currentObject);
				}
					
				result += currentObjectReslult;
				result+='",';
				
			}//end for i
			
			return result;
		}//end save level
		
		
		private static function savePatternStaticGround(stg:IngameObject):String
		{
			if(stg.points.length>0)	
			{
			_resStr="stg_";
			
			if(stg.mobility)_resStr+="d_" else _resStr+="s_";	
			_resStr+=stg.bitmapindex+"_";
			
			
			//for (var i:int = 0; i < stg.points.length; i++) 		
			//{
				//_currentPoint=stg.points[i];
				_resStr+="("+0+","+0+")";
			//}
			
			_resStr+="_";
			
			// triangles
			//for(i=0;i<stg.triangles.length;i++)		
			//{
				_resStr+="(";
				//_currentTriangle=stg.triangles[i];
				_resStr+=0;
				_resStr+=",";
				_resStr+=1;
				_resStr+=",";
				_resStr+=2;
				_resStr+=")";
			//}
			
			_resStr+="_(";
			_resStr+=String(stg.position.x)+",";	
			_resStr += String(stg.position.y) + ")";
			_resStr+="_OOO"
			return _resStr;
			}
			else
			{
				return "";
			}
			
		}//saveStaticGround
		
		
		private static function savePatternBonus(stg:IngameObject):String
		{
			
			if(stg.points.length>0)	
			{
			_resStr="stg_";
			
			_resStr += "b_";					
			_resStr+=stg.bitmapindex+"_";
			
			_resStr += ""+stg.bonusType;
			
			_resStr+="_(";
			_resStr+=String(stg.position.x)+",";	
			_resStr+=String(stg.position.y)+")";
			return _resStr;
			}
			else
			{
				return "";
			}
			
		}//saveBonus
		
		
	}//end class
}