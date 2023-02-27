package game.editor 
{
	import flash.events.MouseEvent;
	import game.LevelEditor;
	import gui.Button;
	import flash.display.Sprite;
	import gui.EditorButton;
	import gui.MouseEventManager;
	import gui.MouseEventObject;
	/**
	 * ...
	 * @author 
	 */
	public class TransformationTools extends ManipulationsWindow
	{
		public static const TOOL_SELECT:int=0;
		public static const TOOL_MOVE:int=1;
		public static const TOOL_ROTATE:int=2;
		public static const TOOL_SCALE:int=3;
		public static const TOOL_DUPLICATE:int=4;
		public static const TOOL_REMOVE:int=5;
		
		public var currentTool:int=0;
		
		public var editroRef:LevelEditor;
		
		public function TransformationTools() 
		{
			init();
		}
		
		// ____________________________________________________________ EVENTS
		
		public function onSelect_Click(me:MouseEvent):void
		{
			currentTool=TOOL_SELECT;
			selectedInd.x=btnSelect.x;
		}
		
		public function onMove_Click(me:MouseEvent):void
		{
			currentTool=TOOL_MOVE;
			selectedInd.x=btnMove.x;
		}
		
		public function onRotate_Click(me:MouseEvent):void
		{
			currentTool=TOOL_ROTATE;
			selectedInd.x=btnRotate.x;
		}
		
		public function onScale_Click(me:MouseEvent):void
		{
			currentTool=TOOL_SCALE;
			selectedInd.x=btnScale.x;
		}
		
		public function onDuplicate_Click(me:MouseEvent):void
		{
			currentTool=TOOL_SELECT;
			editroRef.duplicateSelected();
			selectedInd.x=btnSelect.x;
		}
		
		public function onRemove_Click(me:MouseEvent):void
		{
			currentTool=TOOL_SELECT;
			editroRef.removeSelected();
			selectedInd.x=btnSelect.x;
		}
		
		// ____________________________________________________________ PRIVATE
		
		private function init():void
		{
			// select
			btnSelect.caption.text="select [space]";
			btnSelect.addEventListener(MouseEvent.CLICK, onSelect_Click);
			
			btnMove.caption.text="move [z]";
			btnMove.addEventListener(MouseEvent.CLICK, onMove_Click);
			
			btnRotate.caption.text="rotate [x]";
			btnRotate.addEventListener(MouseEvent.CLICK, onRotate_Click);
			
			btnScale.caption.text="scale [c]";
			btnScale.addEventListener(MouseEvent.CLICK, onScale_Click);
			
			btnDuplicate.caption.text="duplicate [q]";
			btnDuplicate.addEventListener(MouseEvent.CLICK, onDuplicate_Click);
			
			btnRemove.caption.text="remove [del]";
			btnRemove.addEventListener(MouseEvent.CLICK, onRemove_Click);
			
			
			MouseEventManager.addElement(new MouseEventObject(btnSelect, MouseEvent.CLICK, onSelect_Click));
			MouseEventManager.addElement(new MouseEventObject(btnMove, MouseEvent.CLICK, onMove_Click));
			MouseEventManager.addElement(new MouseEventObject(btnRotate, MouseEvent.CLICK, onRotate_Click));
			MouseEventManager.addElement(new MouseEventObject(btnScale, MouseEvent.CLICK, onScale_Click));
			MouseEventManager.addElement(new MouseEventObject(btnDuplicate, MouseEvent.CLICK, onDuplicate_Click));
			MouseEventManager.addElement(new MouseEventObject(btnRemove, MouseEvent.CLICK, onRemove_Click));
			
		}
		
		//
	}

}