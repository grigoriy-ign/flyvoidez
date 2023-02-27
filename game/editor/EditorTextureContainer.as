package game.editor 
{
	import criadone.utils.SimpleTracerPanel;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import gui.MouseEventManager;
	import gui.MouseEventObject;
	
	/**
	 * ...
	 * @author criadone
	 */
	
	public class EditorTextureContainer extends Sprite
	{
		public var texturesSelectorRef:TextureSelector;
		public var textureIndex:int=0;
		public var hasTexture:Boolean=false;		// tells if this cell have a texture or not
		
		public function EditorTextureContainer() 
		{
			addEventListener(MouseEvent.CLICK, onClick);
			
			MouseEventManager.addElement(new MouseEventObject(this, MouseEvent.CLICK, onClick));
		}
		
		private function onClick(me:MouseEvent):void
		{
			if(Main.debug)SimpleTracerPanel.traceString("class EditorTextureContainer CLICK");
			if(hasTexture)
			{
				texturesSelectorRef.setCurrentTextureIndex(textureIndex);
				texturesSelectorRef.texturesSelWindowRef.visible=false;
			}
		}
		
	}//class

}//pack