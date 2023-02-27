package game.editor 
{
	import criadone.utils.SimpleTracerPanel;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import gui.MouseEventManager;
	import gui.MouseEventObject;
	import resources.Resources;
	
	/**
	 * ...
	 * @author criadone
	 */
	public class TextureSelectorWindow extends Sprite 
	{
		
		public var texturesSelectorRef:TextureSelector;
		
		public var btnWinter:EditorButton;
		public var btnDesert:EditorButton;
		public var btnSea:EditorButton;
		
		public var TextureContainersArray:Array=new Array();
		
		public function TextureSelectorWindow(texturesSelectorReference:TextureSelector) 
		{
			texturesSelectorRef=texturesSelectorReference;
			init();
		}
		
		private function init():void
		{
			graphics.beginFill(0x808080,1);
			graphics.drawRoundRect(-200,-200,400,400,10,10);
			graphics.endFill();
			//
			btnWinter=new EditorButton();
			btnDesert=new EditorButton();
			btnSea=new EditorButton();
			//
			btnWinter.x=-130;
			btnWinter.y=-170;
			btnWinter.caption.text="winter";
			btnWinter.addEventListener(MouseEvent.CLICK, onWinterClick);
			
			MouseEventManager.addElement(new MouseEventObject(btnWinter.caption, MouseEvent.CLICK, onWinterClick));
			
			btnDesert.x=0;
			btnDesert.y=-170;
			btnDesert.caption.text="desert";
			btnDesert.addEventListener(MouseEvent.CLICK, onDesertClick);
			
			MouseEventManager.addElement(new MouseEventObject(btnDesert.caption, MouseEvent.CLICK, onDesertClick));
			
			btnSea.x=130;
			btnSea.y=-170;
			btnSea.caption.text="sea";
			btnSea.addEventListener(MouseEvent.CLICK, onSeaClick);
			
			MouseEventManager.addElement(new MouseEventObject(btnSea.caption, MouseEvent.CLICK, onSeaClick));
			
			//
			addChild(btnWinter);
			addChild(btnDesert);
			addChild(btnSea);
			//
			
			var startx:int=-120;
			var starty:int=-100;
			for(var i:int=0;i<5;i++)
			{
				for(var j:int=0;j<5;j++)
				{
					var cntr:EditorTextureContainer=new EditorTextureContainer();
					cntr.graphics.beginFill(0xffffff,1);
					cntr.graphics.drawRoundRect(-25,-25,50,50,20,20);
					cntr.graphics.endFill();
					TextureContainersArray.push(cntr);
					cntr.x=startx+i*60;
					cntr.y=starty+j*60;
					cntr.texturesSelectorRef=texturesSelectorRef;
					cntr.hasTexture=false;
					addChild(cntr);
				}
			}
			
		}//		end init
		
		public function drawTexturesListpub():void
		{
			drawTexturesList();
		}
		
		private function drawTexturesList():void
		{
			/*graphics.clear();
			graphics.beginFill(0x808080,1);
			graphics.drawRoundRect(-200,-200,400,400,10,10);
			graphics.endFill();*/
			
			//
			
			var cnt:int=0;
			for(var q:int=0;q<5;q++)
			{
				for(var w:int;w<5;w++)
				{
					var curSpr:EditorTextureContainer;
					curSpr=TextureContainersArray[cnt];
					curSpr.graphics.clear();
					curSpr.graphics.beginFill(0xffffff,1);
					curSpr.graphics.drawRoundRect(-25,-25,50,50,20,20);
					curSpr.graphics.endFill();
					curSpr.textureIndex=cnt;
					curSpr.hasTexture=false;
					cnt++;
				}
			}
			
			//
			var thisLineTexCount:int=0;
			var line:int=1;
			for(var i:int=0;i< texturesSelectorRef.currentTexturesArray.length;i++)
			{
				curSpr=TextureContainersArray[i];
				curSpr.graphics.clear();
				curSpr.graphics.beginBitmapFill(texturesSelectorRef.currentTexturesArray[i].btmd,null,true,false);
				curSpr.graphics.drawRoundRect(-25,-25,50,50,20,20);
				curSpr.graphics.endFill();
				thisLineTexCount++;
				curSpr.hasTexture=true;
				if(thisLineTexCount>4)
				{
					thisLineTexCount=0;
					line++;
				}
			}
		}
		
		private function onWinterClick(me:MouseEvent):void
		{
			texturesSelectorRef.currentTexturesArray=Resources.texturesWinter;
			Resources.texturesCurrentLocation=Resources.texturesWinter;
			drawTexturesList();
		}
		
		private function onDesertClick(me:MouseEvent):void
		{
			texturesSelectorRef.currentTexturesArray=Resources.texturesDesert;
			Resources.texturesCurrentLocation=Resources.texturesDesert;
			drawTexturesList();
		}
		
		private function onSeaClick(me:MouseEvent):void
		{
			texturesSelectorRef.currentTexturesArray=Resources.texturesSea;
			Resources.texturesCurrentLocation=Resources.texturesSea;
			drawTexturesList();
		}
		
	}
}