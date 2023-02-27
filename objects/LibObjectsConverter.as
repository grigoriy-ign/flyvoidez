package objects 
{
	import levels.LevelParser;
	/**
	 * ...
	 * 
	 */
	
/*
	FROM THIS
new LibObjectInfo(0, "stg_s_0_(-211.00,-34.50)(211.00,-33.50)(207.00,5.50)_(1,2,3)(1,3,4)_(0,0)", "Side UP 1"),

	TO THIS
new Array(new Array(new P2d(-74.50,-75.00), new P2d(-74.50,80.00)), new Array(new Triangle(0,1,2), new Triangle(0,2,3)))
*/
	 
	public class LibObjectsConverter 
	{
		
		public static function convert(src:String):String
		{
			var res:String = "new Array(new Array(";
			
			var parsingStage:int = 0;
			var curchar:String = "";
			var nextchar:String = "";
			var isPy:Boolean = false;
			
			var pointx:String = "";
			var pointy:String = "";
			
			var pind:int = 1;
			var p1:String = "";
			var p2:String = "";
			var p3:String = "";
			
			for (var i:int = 0; i < src.length;i++)
			{
				curchar = src.charAt(i);
				
				if (parsingStage == 0)
				{
					if (curchar == "_") parsingStage++; // 1 - s (type)
				}// end stage == 0
				
				else if (parsingStage == 1)
				{
					if (curchar == "_") parsingStage++; // 2 - 0 (index)
				}// end stage == 1
				
				else if (parsingStage == 2)
				{
					if (curchar == "_") parsingStage++; // 3 - points
				}// end stage == 2
				
				else if (parsingStage == 3)
				{
					
					if (LevelParser.isNumeric(curchar))
					{
						if (isPy)
						{
							pointy += curchar;
						}
						else
						{
							pointx += curchar;
						}
					}
					
					if (curchar == ",")
					{
						isPy = true;
					}
					
					if (curchar == "(")
					{
						
					}
					
					if (curchar == ")")
					{
						nextchar = src.charAt(i + 1);
						if (nextchar == "_")
						{
							res += "new P2d("+Number(pointx)+","+Number(pointy)+")";
						}
						else
						{
							res += "new P2d("+Number(pointx)+","+Number(pointy)+"),";
						}
						isPy = false;
						pointx = "";
						pointy = "";
					}
					
					if (curchar == "_") 
					{
						res += "),";
						parsingStage++;
					}
				}// end stage == 3
				
				else if (parsingStage == 4)
				{
					
					if (LevelParser.isNumeric(curchar))
					{
						if (pind==1)
						{
							p1 += curchar;
						}
						if (pind==2)
						{
							p2 += curchar;
						}
						if (pind==3)
						{
							p3 += curchar;
						}
					}
					
					if (curchar == ",")
					{
						pind++;
					}
					
					if (curchar == "(")
					{
						
					}
					
					if (curchar == ")")
					{
						nextchar = src.charAt(i + 1);
						if (nextchar == "_")
						{
							res += "new Triangle("+int(p1)+","+int(p2)+","+int(p3)+")";
						}
						else
						{
							res += "new Triangle("+int(p1)+","+int(p2)+","+int(p3)+"),";
						}
						p1 = "";
						p2 = "";
						p3 = "";
						pind = 1;
					}
					
					if (curchar == "_") 
					{
						res += "))";
						break;
					}
					
				}// end stage == 4
				
			}//end for i
			
			return res;
		}//convert
	}//LibObjectsConverter

}//pack


