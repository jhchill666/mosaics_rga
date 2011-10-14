package com.rga.pearson.model.constants
{
	import flash.utils.Dictionary;

	public class AssetConstants
	{
		public static const BOOKS : String = "Books";

		public static const DOCUMENTS : String = "Documents";

		public static const IMAGES : String = "Images";

		public static const INTERACTIVE : String = "Interactive";

		public static const VIDEOS : String = "Videos";


		/**
		 * Returns vector of asset type colours
		 */
		public static function getTypes():Vector.<String>
		{
			var vec:Vector.<String> = new Vector.<String>();
			vec.push( BOOKS );
			vec.push( IMAGES );
			vec.push( VIDEOS );
			vec.push( DOCUMENTS );
			vec.push( INTERACTIVE );
			return vec;
		}


		/**the number of asset typesvector of asset type colours
		 */
		public static function size():int
		{
			return getTypes().length;
		}
	}
}
