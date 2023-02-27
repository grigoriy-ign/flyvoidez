package display 
{
	import criadone.utils.SimpleTracerPanel;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import geom.P2d;
	import geom.Triangle;
	import objects.IngameObject;
	import objects.library.StaticGround;
	import objects.Texture;
	import resources.Resources;
	
	import geom.Triagulation;
	
	/**
	 * ...
	 * @author 
	 */
	public class Render
	{
		
		public static var viewport:Sprite;
		public static var drw:Graphics;
		
		public static var checkPoint:P2d=new P2d(0,0);
		
		public static var intersectionObjectIndex:int=0;
		
		public static var currentLevelTexturesArrayRef:Array=Resources.texturesWinter;
		
		//
		
		private static var scrollBgWinter:Bitmap = new Resources.winter_background();
		private static var scrollBgDesert:Bitmap = new Resources.desert_background();
		private static var scrollBgOcean:Bitmap = new Resources.ocean_background();
		
		private static var currentObject:IngameObject;
		private static var currentObjectStg:StaticGround;
		
		private static var curTriangle:Triangle;
		
		private static var p1:P2d;
		private static var p2:P2d;
		private static var p3:P2d;
		
		private static var p1v:P2d=new P2d(0,0);
		private static var p2v:P2d=new P2d(0,0);
		private static var p3v:P2d = new P2d(0, 0);
		
		private static var drwMatrix:Matrix = new Matrix();
		
		public static function renderSingleObject(spr:Sprite,obj:IngameObject):void
		{
			spr.graphics.lineStyle(0.1,0xff0000,1);
			spr.graphics.beginFill(0x000000);
			for(var i:int=0;i< obj.points.length;i++)
			{
				p1=obj.points[i];
				if(i==0)
				{
					spr.graphics.moveTo(p1.x,p1.y);
				}
				else
				{
					spr.graphics.lineTo(p1.x,p1.y);
				}
			}
			spr.graphics.endFill();
		}
		//end render single object
		
		private static var objVisible:Boolean = true;
		public static function renderObjects(levelObjects:Array,debug:Boolean=false,scrollX:Number=0,bgInd:int=1):void
		{
			if(!debug)
			{
			drw=viewport.graphics;
			
			//draw scrolling background
			drawScrollBg(scrollX,bgInd);
			
			var onePointVisible:Boolean = false;
			
			//drw.lineStyle(0.1,0xff0000,1);
			for(var i:int=0;i< levelObjects.length;i++)
			{
				currentObjectStg=levelObjects[i];
				//drw.beginFill(0x000000,1);
				
				objVisible = true;
				var objPos:Number = currentObjectStg.position.x - scrollX;
				if (objPos < -500) objVisible = false;
				if (objPos > Main.appWidth+500) objVisible = false;
				
				if ((objVisible)&&(currentObjectStg.visible))
				{
					// matrix for scrollable objects
					onePointVisible = false;
					var currentBitmap:Texture = currentLevelTexturesArrayRef[currentObjectStg.bitmapindex];
					//var parts:int = Math.floor(scrollX / currentBitmap.btmd.width);
					//var scrollVal:int = currentBitmap.btmd.width * parts;
					//var scrollFin:int = (scrollVal - scrollX)+currentObjectStg.position.x-scrollX+100;
					drwMatrix.tx = currentObjectStg.position.x-scrollX+100;
					drwMatrix.ty = currentObjectStg.position.y;
					
					//SimpleTracerPanel.traceString("" + drwMatrix.tx);
					
					// matrix for player object
					if (currentObjectStg.bitmapindex == 10)
					{
						drwMatrix.tx = 37;
						drwMatrix.ty = currentObjectStg.position.y+18.7;
					}//end player ship matrix
				
					drw.beginBitmapFill(currentBitmap.btmd, drwMatrix, true, true);
				
					for(var j:int=0;j< currentObjectStg.points.length;j++)
					{
						var curx:Number = currentObjectStg.points[j].x + currentObjectStg.position.x-scrollX+100;
						var cury:Number = 0;
						if ((curx > 0)&&(curx<Main.appWidth))
						{
							onePointVisible = true;
							break;
						}// (curx >= 0)
					}//
					
					if (onePointVisible)
					{
					
					for(j=0;j< currentObjectStg.points.length;j++)
					{
						curx = currentObjectStg.points[j].x + currentObjectStg.position.x-scrollX+100;
						cury = currentObjectStg.points[j].y + currentObjectStg.position.y;
						
						if(j==0)
						{
							drw.moveTo(curx,cury);
						}
						else
						{
							drw.lineTo(curx,cury);
						}
					}//end for j
					}//end if onePointVisible
					
				drw.endFill();
				
				}//objVisible
				
			}//end for i
			}//if debug
			else
			{
				renderDebug(levelObjects,scrollX);
			}
			
		}//end render objects	
		
		public static function renderObject(object:StaticGround,scrollX:int):void
		{
			currentObjectStg = object;
			if (currentObjectStg.visible)
			{
				var currentBitmap:Texture = currentLevelTexturesArrayRef[currentObjectStg.bitmapindex];
				drwMatrix.tx = 37;
				drwMatrix.ty = currentObjectStg.position.y+18.7;
				
				drw.beginBitmapFill(currentBitmap.btmd, drwMatrix, true, true);
				
				var curx:Number = 0;
				var cury:Number = 0;
				
				for(var j:int=0;j< currentObjectStg.points.length;j++)
				{
						curx = currentObjectStg.points[j].x + currentObjectStg.position.x-scrollX+100;
						cury = currentObjectStg.points[j].y + currentObjectStg.position.y;
						
						if(j==0)
						{
							drw.moveTo(curx,cury);
						}
						else
						{
							drw.lineTo(curx,cury);
						}
				}//end for j
				
				drw.endFill();
				
			}// end if visible
		}// renderObject
		
		private static var drwMtr:Matrix = new Matrix();
		private static function renderDebug(levelObjects:Array,scrollX:Number):void
		{
			drw=viewport.graphics;
			
			drw.lineStyle(0.1,0xff0000,1);
			for(var i:int=0;i< levelObjects.length;i++)
			{
				
				currentObjectStg = levelObjects[i];
				var isCurBonus:Boolean = currentObjectStg.isBonus;
				
				var curObjPosX:Number=currentObjectStg.position.x-scrollX;
				var curObjPosY:Number=currentObjectStg.position.y;
				
				for(var j:int=0;j< currentObjectStg.triangles.length;j++)
				{
					curTriangle=currentObjectStg.triangles[j];
					p1=currentObjectStg.points[curTriangle.p1];
					p2=currentObjectStg.points[curTriangle.p2];
					p3=currentObjectStg.points[curTriangle.p3];
					
					p1v.x = p1.x + curObjPosX - scrollX;	p1v.y = p1.y + curObjPosY;
					p2v.x = p2.x + curObjPosX - scrollX;	p2v.y = p2.y + curObjPosY;
					p3v.x = p3.x + curObjPosX - scrollX;	p3v.y = p3.y + curObjPosY;
					
					drwMtr.tx = p1v.x;
					drwMtr.ty = p1v.y;
					
					//check intersection with check point
					if(Triagulation.isInTriangle(checkPoint,p1v,p2v,p3v))
					{
						drw.beginFill(0xff0000,1);
						intersectionObjectIndex=i;
					}
					else
					{
						drw.beginBitmapFill(Resources.texturesCurrentLocation[currentObjectStg.bitmapindex].btmd, drwMtr, true, false);
					}//triang
					//
					
					drw.moveTo(p1v.x,p1v.y);
					drw.lineTo(p2v.x,p2v.y);
					drw.lineTo(p3v.x,p3v.y);
					
					if(currentObjectStg.selected)
					{
						drw.beginFill(0x00ff00,0.5);
						drw.moveTo(p1v.x,p1v.y);
						drw.lineTo(p2v.x,p2v.y);
						drw.lineTo(p3v.x,p3v.y);
						drw.endFill();
					}
					
				}//for j
				drw.endFill();
				
			}//end for i
		}//renderDebug
		
		// draws level background
		private static function drawScrollBg(scrx:Number,ind:int):void
		{
			scrx /= 5;
			var parts:int = Math.floor(scrx / scrollBgWinter.bitmapData.width);
			var scrollVal:int = scrollBgWinter.bitmapData.width * parts;
			var scrollFin:int = (scrx - scrollVal)*-1;
			drwMatrix.tx = scrollFin;
			drwMatrix.ty = 0;
			
			if (ind == 1)
			{
				drw.beginBitmapFill(scrollBgWinter.bitmapData, drwMatrix, true, true);
			}
			else if (ind == 2)
			{
				drw.beginBitmapFill(scrollBgDesert.bitmapData, drwMatrix, true, true);
			}
			else if (ind == 3)
			{
				drw.beginBitmapFill(scrollBgOcean.bitmapData, drwMatrix, true, true);
			}
			else 
			{
				drw.beginFill(0x000000, 1);
			}
			
			
			drw.drawRect(0, 0, Main.appWidth, Main.appHeight);
		}//drawScrollBg
		
		
		//class
	}
}