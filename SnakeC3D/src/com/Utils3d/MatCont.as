package com.Utils3d
{
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	
	// params.wmode="direct" //bala
	//-locale en_US -use-network=false -swf-version=13
	
	//i think you need to clean all your stagged files using  or git rm --cached config/database.yml
	//git rm -r --cached .
	//git add .
	//but make sure you commit your changes before doing this .
	
	
	public class MatCont extends MovieClip
	{
		[Embed(source="/images/bark_diffuse.jpg")] private static const EmbedBarkDiffuse:Class;
		public static var bark_diffuse:BitmapTextureResource = new BitmapTextureResource(new MatCont.EmbedBarkDiffuse().bitmapData);
		[Embed(source="/images/bark_normal.jpg")] private static const EmbedBarkNormal:Class;
		public static var bark_normal:BitmapTextureResource = new BitmapTextureResource(new BitmapData(1,1,false,0xff0000));//new EmbedBarkNormal().bitmapData);
		
		[Embed(source="/images/wood.jpg")] private static const EmbedGrassDiffuse:Class;
		public static var grass_diffuse:BitmapTextureResource = new BitmapTextureResource(new EmbedGrassDiffuse().bitmapData);
		public static var grass_normal:BitmapTextureResource = new BitmapTextureResource(new BitmapData(1, 1, false, 0x7F7FFF));
		
		
		[Embed(source = "/images/skybox/left.jpg")] public static const left_t_c:Class;
		public static var left_t:BitmapTextureResource = new BitmapTextureResource(new left_t_c().bitmapData);
		[Embed(source = "/images/skybox/right.jpg")] public static const right_t_c:Class;
		public static var right_t:BitmapTextureResource = new BitmapTextureResource(new right_t_c().bitmapData);
		[Embed(source = "/images/skybox/top.jpg")] public static const top_t_c:Class;
		public static var top_t:BitmapTextureResource = new BitmapTextureResource(new top_t_c().bitmapData);
		[Embed(source = "/images/skybox/bottom.jpg")] public static const bottom_t_c:Class;
		public static var bottom_t:BitmapTextureResource = new BitmapTextureResource(new bottom_t_c().bitmapData);
		[Embed(source = "/images/skybox/front.jpg")] public static const front_t_c:Class;
		public static var front_t:BitmapTextureResource = new BitmapTextureResource(new front_t_c().bitmapData);
		[Embed(source = "/images/skybox/back.jpg")] public static const back_t_c:Class;
		public static var back_t:BitmapTextureResource = new BitmapTextureResource(new back_t_c().bitmapData);
		
		[Embed(source="/model/balamodel3ds.a3d", mimeType="application/octet-stream")]
		private const Model:Class;
		
		//BAla collada..
		[Embed(source="/images/Bala1.dae", mimeType="application/octet-stream")]
		public static var bmodel:Class;
		
		public function MatCont()
		{
			super();
		}
	}
}