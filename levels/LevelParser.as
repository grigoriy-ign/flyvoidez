package levels 
{
	import criadone.utils.SimpleTracerPanel;
	import geom.Triangle;
	import objects.library.StaticGround;
	import objects.ObjectLib;
	import objects.Texture;
	/**
	 * ...
	 * @author 
	 */
	public class LevelParser
	{
		
		private static var curentObjString:String;
		private static var objTypeStr:String;
		
		public static function parsePattern(src:Array, out:Array, scroll:int):void
		{
			for (var i:int = 0; i < src.length; i++)
			{
				curentObjString = src[i];
				//obj type
				objTypeStr="";
				objTypeStr+=curentObjString.charAt(0);
				objTypeStr+=curentObjString.charAt(1);
				objTypeStr+=curentObjString.charAt(2);
				// switch
			
				if (objTypeStr == "stg")
				{
					var typeChar:String = curentObjString.charAt(4);
					if ((typeChar == "s") || (typeChar == "d"))
					{
						out[out.length] = parsePatternStaticGround(curentObjString,scroll);
						//SimpleTracerPanel.traceString("parse static ground");
					}
					else if(typeChar=="b")
					{
						out[out.length] = parsePatternBonus(curentObjString,scroll);
						//SimpleTracerPanel.traceString("parse bonus");
					}
					else
					{
						SimpleTracerPanel.traceString("LevelParser -> ParsePattern : Unknown object type o_O");
					}
			}//stg
				
			}//end for i
		}//parse Pattern
		
		public static function parseLevel(src:Array,out:Array,scroll:Number=-1):void
		{
			for(var i:int=0;i<src.length;i++)
			{
			curentObjString=src[i];
			//SimpleTracerPanel.traceString(curentObjString);
			//obj type
			objTypeStr="";
			objTypeStr+=curentObjString.charAt(0);
			objTypeStr+=curentObjString.charAt(1);
			objTypeStr+=curentObjString.charAt(2);
			// switch
			
			if (objTypeStr == "stg")
			{
				var typeChar:String = curentObjString.charAt(4);
				if ((typeChar == "s") || (typeChar == "d"))
				{
					out[out.length] = parseStaticGround(curentObjString,scroll);
					//SimpleTracerPanel.traceString("parse static ground");
				}
				else if(typeChar=="b")
				{
					out[out.length] = parseBonus(curentObjString,scroll);
					//SimpleTracerPanel.traceString("parse bonus");
				}
				else
				{
					SimpleTracerPanel.traceString("LevelParser -> ParseLevel : Unknown object type o_O");
				}
			}//stg
			
			}//end for i
		}//end parseLevel
		
		
		
		public static function parseStaticGround(objSrc:String,scroll:Number=-1):StaticGround
		{
			var stg:StaticGround=new StaticGround();
			
			/*stg_(20,30)(50,60)(20,100)_012023*/ //example
			
			/*stg_s_01_(20,30)(30,50)(20,100)_0123023_(20,30)*/ // new
			
			var curchar:String;			
			
			var coordy:Boolean=false;	
			var curpointx:String="";	
			var curpointy:String="";	
			
			var ismobile:Boolean=false;	
			var parsingStage:int=0;		
			var bitmapindex:String="";	
			var fromLib:Boolean=false;	
			//triangles
			var pointind:int=1;			//
			var trgind1:String="";
			var trgind2:String="";
			var trgind3:String="";
			
			for(var j:int=4;j<objSrc.length;j++)
			{
				curchar=objSrc.charAt(j);
				
				//SimpleTracerPanel.traceString("c: "+curchar);
				//SimpleTracerPanel.traceString("parsing stage: "+parsingStage);
				
				switch(parsingStage)
				{
					
					case 0:	
						if(curchar=="d")
						{
							ismobile=true;
							//SimpleTracerPanel.traceString("object dynamic");
						}
						if(curchar=="_")
						{
							//SimpleTracerPanel.traceString("next stage");
							parsingStage++;
						}
						
					break;
					
					case 1:	
						if(isNumeric(curchar))
						{
							//SimpleTracerPanel.traceString("is numeric: "+curchar);
							bitmapindex+=curchar;
						}
						if(curchar=="_")
						{
							//SimpleTracerPanel.traceString("next stage");
							stg.bitmapindex = int(bitmapindex);
							stg.bitmapindex = int(Math.random()*Texture.GROUND_TEXTURES_COUNT); //upd random bitmap index
							parsingStage++;
						}
						
					break;
					
					case 2: 
						if(curchar=="(")
						{
							//SimpleTracerPanel.traceString("obj uniq");
							fromLib=false;
						}
						else
						{
							//SimpleTracerPanel.traceString("obj from lib");
							fromLib=true;
						}
						parsingStage++;
						
					break;
					
					case 3: 
					
					if(!fromLib)
					{
						if(isNumeric(curchar))
						{
							if(!coordy)
							{
								curpointx+=curchar
								//SimpleTracerPanel.traceString("plus coordx");
							}else
							{
								curpointy+=curchar;
								//SimpleTracerPanel.traceString("plus coordy");
							}
						}
						if(curchar==",")
						{
							coordy=true;
						}
						if(curchar==")")
						{
							coordy=false;
							stg.addPoint(int(curpointx),int(curpointy));
							//SimpleTracerPanel.traceString("add point "+curpointx+" "+curpointy);
							curpointx="";
							curpointy="";
						}
						if(curchar=="_")
						{
							//SimpleTracerPanel.traceString("next stage");
							parsingStage++;
						}
					}
					else // from lib
					{
						
					}
						
					break;
					
					case 4: // triangles
					
					if(isNumeric(curchar))
					{
						if(pointind==1)
						{
							trgind1+=curchar;
							//SimpleTracerPanel.traceString("plus index 1");
						}
						if(pointind==2)
						{
							trgind2+=curchar;
							//SimpleTracerPanel.traceString("plus index 2");
						}
						if(pointind==3)
						{
							trgind3+=curchar;
							//SimpleTracerPanel.traceString("plus index 3");
						}
					}
					if(curchar==",")
					{
						pointind++;
						//SimpleTracerPanel.traceString("point index ++");
					}
					if(curchar==")")
					{
						pointind=1;
						stg.addTriangle(int(trgind1),int(trgind2),int(trgind3));
						//SimpleTracerPanel.traceString("add triangle "+trgind1+" "+trgind2+" "+trgind3);
						trgind1="";
						trgind2="";
						trgind3="";
					}
					if(curchar=="_")
					{
						parsingStage++;
						curpointx="";
						curpointy="";
						coordy=false;
						//SimpleTracerPanel.traceString("next stage");
					}
					
					break;
					
					case 5: // position	(340,227)
					
					if(isNumeric(curchar))
					{
						if(!coordy)
						{
							curpointx+=curchar;
						}
						else
						{
							curpointy+=curchar;
						}
					}
					if(curchar==",")
					{
						coordy=true;
					}
					if(curchar==")")
					{
						coordy=false;
						stg.position.x = int(curpointx);
						if (scroll > -1) stg.position.x = int(curpointx) + scroll;
						stg.position.y=int(curpointy);
						curpointx="";
						curpointy="";
					}
					if(curchar=="_")
					{
						parsingStage++;
					}
					
					//parsing position here
					
					break;
					
					default:
				}// end switch
				
				
			}//end for j
			
			return stg;
		}
		
		public static function parseBonus(objSrc:String,scroll:Number=-1):StaticGround
		{
			var stg:StaticGround = new StaticGround();
			
			var curchar:String;			
			
			var coordy:Boolean=false;	
			var curpointx:String="";	
			var curpointy:String="";	
			
			var ismobile:Boolean=false;	
			var parsingStage:int=0;		
			var bitmapindex:String="";	
			var fromLib:Boolean=false;	
			//triangles
			var pointind:int=1;			//
			var trgind1:String = "";
			var trgind2:String = "";
			var trgind3:String = "";
			
			var bonusTypeStr:String = "";
			var bonusType:int = 1;
			
			stg.isBonus = true;
			
			for(var j:int=4;j<objSrc.length;j++)
			{
				curchar = objSrc.charAt(j);
				
				switch(parsingStage)
				{
				case 0:	// 
						if(curchar=="b")
						{
							
						}
						if (curchar == "_")
						{
							parsingStage++;
						}
				break;
					
				case 1:	
						if(isNumeric(curchar))
						{
							//SimpleTracerPanel.traceString("is numeric: "+curchar);
							bitmapindex+=curchar;
						}
						if(curchar=="_")
						{
							//SimpleTracerPanel.traceString("next stage");
							stg.bitmapindex=int(bitmapindex);
							
							stg.addPoint(int( 0), int( 0));
							stg.addPoint(int(20), int( 0));
							stg.addPoint(int(20), int(20));
							stg.addPoint(int( 0), int(20));
							
							stg.addTriangle(int(0), int(1), int(2));
							stg.addTriangle(int(0), int(3), int(2));
							
							parsingStage++;
							
						}//char == _
						
				break;
					
				case 2: // bonus type
					
					if (isNumeric(curchar))
					{
						bonusTypeStr += curchar;
					}
					if (curchar == "_")
					{
						parsingStage++;
						stg.bonusType = int(bonusTypeStr);
					}
					
				break;
					
				case 3: // position	(340,227)
					if(isNumeric(curchar))
					{
						if(!coordy)
						{
							curpointx+=curchar;
						}
						else
						{
							curpointy+=curchar;
						}
					}
					if(curchar==",")
					{
						coordy=true;
					}
					if(curchar==")")
					{
						coordy=false;
						stg.position.x = int(curpointx);
						if (scroll > -1) stg.position.x = int(curpointx) + scroll;
						stg.position.y=int(curpointy);
						curpointx="";
						curpointy = "";
					}
					if(curchar=="_")
					{
						parsingStage++;
					}
					
				break;
					
				default:
				}//end switch
				
			}//end for j
			
			return stg;
		}//parseBonus
		
		
		// PATTERN PARSING
		
		public static function parsePatternStaticGround(objSrc:String,scroll:int):StaticGround
		{
			var stg:StaticGround=new StaticGround();
			
			/*stg_(20,30)(50,60)(20,100)_012023*/ //example
			
			/*stg_s_01_(20,30)(30,50)(20,100)_0123023_(20,30)*/ // new
			
			var curchar:String;			
			
			var coordy:Boolean=false;	
			var curpointx:String="";	
			var curpointy:String="";	
			
			var ismobile:Boolean=false;	
			var parsingStage:int=0;		
			var bitmapindex:String="";	
			var fromLib:Boolean=false;	
			//triangles
			var pointind:int=1;			//
			var trgind1:String="";
			var trgind2:String="";
			var trgind3:String = "";
			
			var objectType:String = "";
			
			for(var j:int=4;j<objSrc.length;j++)
			{
				curchar=objSrc.charAt(j);
				
				//SimpleTracerPanel.traceString("c: "+curchar);
				//SimpleTracerPanel.traceString("parsing stage: "+parsingStage);
				
				switch(parsingStage)
				{
					
					case 0:	
						if(curchar=="d")
						{
							ismobile=true;
							//SimpleTracerPanel.traceString("object dynamic");
						}
						if(curchar=="_")
						{
							//SimpleTracerPanel.traceString("next stage");
							parsingStage++;
						}
						
					break;
					
					case 1:	
						if(isNumeric(curchar))
						{
							//SimpleTracerPanel.traceString("is numeric: "+curchar);
							bitmapindex+=curchar;
						}
						if(curchar=="_")
						{
							//SimpleTracerPanel.traceString("next stage");
							stg.bitmapindex = int(bitmapindex);
							stg.bitmapindex = int (Math.random() * Texture.GROUND_TEXTURES_COUNT); //upd set random index
							parsingStage++;
						}
						
					break;
					
					case 2: 
						if(curchar=="(")
						{
							//SimpleTracerPanel.traceString("obj uniq");
							fromLib=false;
						}
						else
						{
							//SimpleTracerPanel.traceString("obj from lib");
							fromLib=true;
						}
						parsingStage++;
						
					break;
					
					case 3: 
					
					if(!fromLib)
					{
						if(isNumeric(curchar))
						{
							if(!coordy)
							{
								curpointx+=curchar
								//SimpleTracerPanel.traceString("plus coordx");
							}else
							{
								curpointy+=curchar;
								//SimpleTracerPanel.traceString("plus coordy");
							}
						}
						if(curchar==",")
						{
							coordy=true;
						}
						if(curchar==")")
						{
							coordy=false;
							//stg.addPoint(int(curpointx),int(curpointy));
							//SimpleTracerPanel.traceString("add point "+curpointx+" "+curpointy);
							curpointx="";
							curpointy="";
						}
						if(curchar=="_")
						{
							//SimpleTracerPanel.traceString("next stage");
							parsingStage++;
						}
					}
					else // from lib
					{
						
					}
						
					break;
					
					case 4: // triangles
					
					if(isNumeric(curchar))
					{
						if(pointind==1)
						{
							trgind1+=curchar;
							//SimpleTracerPanel.traceString("plus index 1");
						}
						if(pointind==2)
						{
							trgind2+=curchar;
							//SimpleTracerPanel.traceString("plus index 2");
						}
						if(pointind==3)
						{
							trgind3+=curchar;
							//SimpleTracerPanel.traceString("plus index 3");
						}
					}
					if(curchar==",")
					{
						pointind++;
						//SimpleTracerPanel.traceString("point index ++");
					}
					if(curchar==")")
					{
						pointind=1;
						//stg.addTriangle(int(trgind1),int(trgind2),int(trgind3));
						//SimpleTracerPanel.traceString("add triangle "+trgind1+" "+trgind2+" "+trgind3);
						trgind1="";
						trgind2="";
						trgind3="";
					}
					if(curchar=="_")
					{
						parsingStage++;
						curpointx="";
						curpointy="";
						coordy=false;
						//SimpleTracerPanel.traceString("next stage");
					}
					
					break;
					
					case 5: // position	(340,227)
					
					if(isNumeric(curchar))
					{
						if(!coordy)
						{
							curpointx+=curchar;
						}
						else
						{
							curpointy+=curchar;
						}
					}
					if(curchar==",")
					{
						coordy=true;
					}
					if(curchar==")")
					{
						coordy=false;
						stg.position.x=int(curpointx)+scroll+(-20+Math.random()*40);
						stg.position.y=int(curpointy)+(-20+Math.random()*40);
						curpointx="";
						curpointy="";
					}
					if(curchar=="_")
					{
						parsingStage++;
					}
					
					//parsing position here
					
					break;
					
				case 6:
					
					if(curchar=="_")
					{
						parsingStage++;
					}
					else
					{
						objectType += curchar;
					}
					
					break;
					
					default:
				}// end switch
				
				
			}//end for j
			
			//here
			// here we should get object type
			// and select random object from object lib
			
			var objectsArrRef:Array;
			if (objectType == "bou") objectsArrRef = ObjectLib.objectsBOU;
			if (objectType == "bod") objectsArrRef = ObjectLib.objectsBOD;
			if (objectType == "bot") objectsArrRef = ObjectLib.objectsBOT;
			if (objectType == "box") objectsArrRef = ObjectLib.objectsBOX;
			if (objectType == "tbx") objectsArrRef = ObjectLib.objectsTBX;
			if (objectType == "bbx") objectsArrRef = ObjectLib.objectsBBX;
			if (objectType == "wal") objectsArrRef = ObjectLib.objectsWAL;
			if (objectType == "wah") objectsArrRef = ObjectLib.objectsWAH;
			
			var i:int = 0;
			var objectArrayRef:Array;
			var pointsArrayRef:Array;
			var triangsArrayRef:Array;
			var objIndex:int = Math.random() * objectsArrRef.length;
			//SimpleTracerPanel.traceString("rand"+objIndex);
			objectArrayRef = objectsArrRef[objIndex];
			pointsArrayRef = objectArrayRef[0];
			triangsArrayRef = objectArrayRef[1];
			
			for (i = 0; i < pointsArrayRef.length; i++)
			{
				stg.addPoint(pointsArrayRef[i].x+(-5+Math.random()*10), pointsArrayRef[i].y+(-5+Math.random()*10));
			}//end for i - points
			
			for (i = 0; i < triangsArrayRef.length; i++)
			{
				stg.addTriangle(triangsArrayRef[i].p1, triangsArrayRef[i].p2, triangsArrayRef[i].p3);
			}//end for i - points
			
			stg.bitmapindex = int(Math.random() * 10);
			
			//SimpleTracerPanel.traceString("" + objectType);
			//SimpleTracerPanel.traceString("" + stg.position.x);
			//SimpleTracerPanel.traceString("" + stg.position.y);
			
			return stg;
		}//end parse pattern static ground
		
		
		public static function parsePatternBonus(objSrc:String,scroll:int):StaticGround
		{
			var stg:StaticGround = new StaticGround();
			
			var curchar:String;			
			
			var coordy:Boolean=false;	
			var curpointx:String="";	
			var curpointy:String="";	
			
			var ismobile:Boolean=false;	
			var parsingStage:int=0;		
			var bitmapindex:String="";	
			var fromLib:Boolean=false;	
			//triangles
			var pointind:int=1;			//
			var trgind1:String = "";
			var trgind2:String = "";
			var trgind3:String = "";
			
			var bonusTypeStr:String = "";
			var bonusType:int = 1;
			
			stg.isBonus = true;
			
			for(var j:int=4;j<objSrc.length;j++)
			{
				curchar = objSrc.charAt(j);
				
				switch(parsingStage)
				{
				case 0:	// 
						if(curchar=="b")
						{
							
						}
						if (curchar == "_")
						{
							parsingStage++;
						}
				break;
					
				case 1:	
						if(isNumeric(curchar))
						{
							//SimpleTracerPanel.traceString("is numeric: "+curchar);
							bitmapindex+=curchar;
						}
						if(curchar=="_")
						{
							//SimpleTracerPanel.traceString("next stage");
							stg.bitmapindex=int(bitmapindex);
							
							stg.addPoint(int( 0), int( 0));
							stg.addPoint(int(20), int( 0));
							stg.addPoint(int(20), int(20));
							stg.addPoint(int( 0), int(20));
							
							stg.addTriangle(int(0), int(1), int(2));
							stg.addTriangle(int(0), int(3), int(2));
							
							parsingStage++;
							
						}//char == _
						
				break;
					
				case 2: // bonus type
					
					if (isNumeric(curchar))
					{
						bonusTypeStr += curchar;
					}
					if (curchar == "_")
					{
						parsingStage++;
						stg.bonusType = int(bonusTypeStr);
					}
					
				break;
					
				case 3: // position	(340,227)
					if(isNumeric(curchar))
					{
						if(!coordy)
						{
							curpointx+=curchar;
						}
						else
						{
							curpointy+=curchar;
						}
					}
					if(curchar==",")
					{
						coordy=true;
					}
					if(curchar==")")
					{
						coordy=false;
						stg.position.x=int(curpointx)+scroll+(-20+Math.random()*40);
						stg.position.y=int(curpointy)+(-20+Math.random()*40);
						curpointx="";
						curpointy = "";
					}
					if(curchar=="_")
					{
						parsingStage++;
					}
					
				break;
					
				default:
				}//end switch
				
			}//end for j
			
			stg.bitmapindex = 10 + stg.bonusType;
			
			if (stg.bonusType == 9)
			{
				var rnd:int = 1 + Math.random() * 6;
				var newBitmapInd:int = 10 + rnd;
				stg.bonusType = rnd;
				stg.bitmapindex = newBitmapInd;
			}// end if stg.bonusType == 9
			
			return stg;
		}//parseBonus
		
		
		public static function isNumeric(n:String):Boolean
		{
			if((n>="0")&&(n<="9"))
			{
				return true;
			}
			else 
			{
				if(n==".")return true;
				if(n=="e")return true;
				if(n=="-")return true;
				return false;
			}
		}//end isNumeric
		
		//class
	}
}