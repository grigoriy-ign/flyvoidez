package gui 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author 
	 */
	public class ExtText extends Sprite
	{
		
		private var _tf:TextField;
		private var _tfm:TextFormat;
		
		public function ExtText(color:int,font:String,size:int) 
		{
			_tf=new TextField();
			_tfm=new TextFormat();
			//
			_tf.text = "Default ExtText";
			_tf.embedFonts = true;
			_tf.selectable=false;
			_tfm.align=TextFormatAlign.LEFT;
			_tfm.color=color;
			_tfm.font=font;
			_tfm.size=size;
			
			_tf.setTextFormat(_tfm);
			_tf.defaultTextFormat = _tfm;
			addChild(_tf);
			//
		}
		
		public function setAlign(align:String):void
		{
			_tfm.align = align;
			_tf.setTextFormat(_tfm);
			_tf.defaultTextFormat = _tfm;
		}
		
		public function setParams(posx:Number,posy:Number,w:Number,h:Number):void
		{
			_tf.x=posx;
			_tf.y=posy;
			_tf.width=w;
			_tf.height=h;
		}
		
		public function setText(str:String):void
		{
			_tf.text=str;
		}
		
	}
}