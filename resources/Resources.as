package resources 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import objects.Texture;
	/**
	 * ...
	 * @author 
	 */
	public class Resources
	{
		
		[Embed(source="../../res/enviroment/winter_background.jpg")]
		public static var winter_background:Class;
		
		[Embed(source="../../res/enviroment/desert_background.jpg")]
		public static var desert_background:Class;
		
		[Embed(source="../../res/enviroment/ocean_background.jpg")]
		public static var ocean_background:Class;
		
		[Embed(source="../../res/gui/button_bg.png")]
		public static var button_bg:Class;
		
		[Embed(source="../../res/gui/gradient_background.jpg")]
		public static var gradient_background:Class;
		
		[Embed(source="../../res/gui/desert_button.jpg")]
		public static var desert_button:Class;
		
		[Embed(source="../../res/gui/winter_button.jpg")]
		public static var winter_button:Class;
		
		[Embed(source="../../res/gui/sea_button.jpg")]
		public static var sea_button:Class;
		
		[Embed(source="../../res/gui/back_button.png")]
		public static var back_button:Class;
		
		[Embed(source="../../res/gui/locked.png")]
		public static var icon_locked:Class;
		
		[Embed(source="../../res/gui/sound_on.png")]
		public static var icon_sound_on:Class;
		
		[Embed(source="../../res/gui/sound_off.png")]
		public static var icon_sound_off:Class;
		
		/*
		 * 			TEXTURES
		 */
		
		// ____________________________________________________
		// WINTER TEXTURES
		// ____________________________________________________
		
		[Embed(source="../../res/textures/winter1.jpg")]
		public static var winterBtm1:Class;
		
		[Embed(source="../../res/textures/winter2.jpg")]
		public static var winterBtm2:Class;
		
		[Embed(source="../../res/textures/winter3.jpg")]
		public static var winterBtm3:Class;
		
		[Embed(source="../../res/textures/winter4.jpg")]
		public static var winterBtm4:Class;
		
		[Embed(source="../../res/textures/winter5.jpg")]
		public static var winterBtm5:Class;
		
		[Embed(source="../../res/textures/winter6.jpg")]
		public static var winterBtm6:Class;
		
		[Embed(source="../../res/textures/winter7.jpg")]
		public static var winterBtm7:Class;
		
		[Embed(source="../../res/textures/winter8.jpg")]
		public static var winterBtm8:Class;
		
		[Embed(source="../../res/textures/winter9.jpg")]
		public static var winterBtm9:Class;
		
		[Embed(source="../../res/textures/winter10.jpg")]
		public static var winterBtm10:Class;
		
		// ____________________________________________________
		
		[Embed(source="../../res/textures/o1.jpg")]
		public static var sea_1:Class;
		
		[Embed(source="../../res/textures/o2.jpg")]
		public static var sea_2:Class;
		
		[Embed(source="../../res/textures/o3.jpg")]
		public static var sea_3:Class;
		
		[Embed(source="../../res/textures/o4.jpg")]
		public static var sea_4:Class;
		
		[Embed(source="../../res/textures/o5.jpg")]
		public static var sea_5:Class;
		
		[Embed(source="../../res/textures/o6.jpg")]
		public static var sea_6:Class;
		
		[Embed(source="../../res/textures/o7.jpg")]
		public static var sea_7:Class;
		
		[Embed(source="../../res/textures/o8.jpg")]
		public static var sea_8:Class;
		
		[Embed(source="../../res/textures/o9.jpg")]
		public static var sea_9:Class;
		
		// ______________________________________________________
		
		[Embed(source="../../res/textures/desert1.jpg")]
		public static var desert_1:Class;
		
		[Embed(source="../../res/textures/desert2.jpg")]
		public static var desert_2:Class;
		
		[Embed(source="../../res/textures/desert3.jpg")]
		public static var desert_3:Class;
		
		[Embed(source="../../res/textures/desert4.jpg")]
		public static var desert_4:Class;
		
		[Embed(source="../../res/textures/desert5.jpg")]
		public static var desert_5:Class;
		
		[Embed(source="../../res/textures/desert6.jpg")]
		public static var desert_6:Class;
		
		[Embed(source="../../res/textures/desert7.jpg")]
		public static var desert_7:Class;
		
		[Embed(source="../../res/textures/desert8.jpg")]
		public static var desert_8:Class;
		
		// ____________________________________________________
		// OBJECTS
		// ____________________________________________________
		
		[Embed(source="../../res/units/player.png")]
		public static var player_image:Class;
		
		// ____________________________________________________
		// BONUS
		// ____________________________________________________
		
		[Embed(source="../../res/items/item_star.png")]
		public static var item_star:Class;
		
		[Embed(source="../../res/items/item_health.png")]
		public static var item_health:Class;
		
		[Embed(source="../../res/items/item_time.png")]
		public static var item_time:Class;
		
		[Embed(source="../../res/items/item_danger.png")]
		public static var item_boost:Class;
		
		[Embed(source="../../res/items/item_reverse.png")]
		public static var item_reverse:Class;
		
		[Embed(source="../../res/items/item_random.png")]
		public static var item_random:Class;
		
		// ____________________________________________________
		// EFFECTS
		// ____________________________________________________
		
		[Embed(source="../../res/effects/damage_layer.png")]
		public static var damage_layer_effect:Class;
		
		[Embed(source="../../res/effects/fire_turbo.png")]
		public static var fire_turbo:Class;
		
		[Embed(source="../../res/effects/hit_spark.png")]
		public static var hit_spark:Class;
		
		[Embed(source="../../res/effects/boom_particle.png")]
		public static var boom_particle:Class;
		
		[Embed(source="../../res/effects/explosion.png")]
		public static var explosion_image:Class;
		
		[Embed(source="../../res/effects/gravity_effect.png")]
		public static var gravity_effect:Class;
		
		// ______________________________________________________________________
		
		//			SOUNDS
		
		[Embed(source = "../../res/sound/click.mp3")]
		public static var click_sound:Class;
		
		//			-SOUNDS
		
		public static var button_bg_Bitmap:Bitmap=new button_bg();
		public static var gradient_background_Bitmap:Bitmap=new gradient_background();
		
		public static var texturesCurrentLocation:Array;		// reference to another array ( winter, desert, sea )
		
		public static var texturesWinter:Array=new Array
		(
		new Texture(new winterBtm1()),
		new Texture(new winterBtm2()),
		new Texture(new winterBtm3()),
		new Texture(new winterBtm4()),
		new Texture(new winterBtm5()),
		new Texture(new winterBtm6()),
		new Texture(new winterBtm7()),
		new Texture(new winterBtm8()),
		new Texture(new winterBtm9()),
		new Texture(new winterBtm10()),
		new Texture(new player_image()), 	// 10
		new Texture(new item_star()),		// 11
		new Texture(new item_health()),		// 12
		new Texture(new item_time()),		// 13
		new Texture(new item_boost()),		// 14
		new Texture(new item_reverse()),	// 15
		new Texture(new item_random())		// 16
		);
		
		public static var texturesDesert:Array=new Array
		(
		new Texture(new desert_1()),
		new Texture(new desert_2()),
		new Texture(new desert_3()),
		new Texture(new desert_4()),
		new Texture(new desert_5()),
		new Texture(new desert_6()),
		new Texture(new desert_7()),
		new Texture(new desert_8()),
		new Texture(new desert_8()),
		new Texture(new desert_8()),
		new Texture(new player_image()), 	// 10
		new Texture(new item_star()),		// 11
		new Texture(new item_health()),		// 12
		new Texture(new item_time()),		// 13
		new Texture(new item_boost()),		// 14
		new Texture(new item_reverse()),	// 15
		new Texture(new item_random())		// 16
		);
		
		public static var texturesSea:Array=new Array
		(
		new Texture(new sea_1()),
		new Texture(new sea_2()),
		new Texture(new sea_3()),
		new Texture(new sea_4()),
		new Texture(new sea_5()),
		new Texture(new sea_6()),
		new Texture(new sea_7()),
		new Texture(new sea_8()),
		new Texture(new sea_9()),
		new Texture(new sea_9()),
		new Texture(new player_image()), 	// 10
		new Texture(new item_star()),		// 11
		new Texture(new item_health()),		// 12
		new Texture(new item_time()),		// 13
		new Texture(new item_boost()),		// 14
		new Texture(new item_reverse()),	// 15
		new Texture(new item_random())		// 16
		);
		
		
		
		public static function init():void
		{
			texturesCurrentLocation=texturesWinter;
		}
		
		
	}
}