package game.editor 
{
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import game.LevelEditor;
	import gui.ExtSelector;
	import resources.Resources;
	
	public class TextureSelector extends ExtSelector
	{
		
		public var texturesSelWindowRef:TextureSelectorWindow;
		public var levelEditorRef:LevelEditor;
		
		public var currentTexturesArray:Array;
		public var currentTextureIndex:int=0;
		
		private var drwMatrix:Matrix;
		
		public function setCurrentTextureIndex(ind:int):void
		{

			currentTextureIndex=ind;
			levelEditorRef.selectedObject.bitmapindex=ind;
			drawCurrentTexture();
			
		}
	
		public function TextureSelector()
		{
			drwMatrix=new Matrix();
			currentTexturesArray=Resources.texturesWinter;
			currentTextureIndex=0;
			drawCurrentTexture();
		}
		
		public function drawCurrentTexture():void
		{
			graphics.beginBitmapFill(currentTexturesArray[currentTextureIndex].btmd,drwMatrix,true,false);
			graphics.drawRoundRect(-25,-25,50,50,5,5);
			graphics.endFill();
		}
		
	}//		class
}//		pack