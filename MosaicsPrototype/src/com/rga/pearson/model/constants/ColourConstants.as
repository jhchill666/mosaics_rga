package com.rga.pearson.model.constants
{

	public class ColourConstants
	{
		// books
		public static const GREEN : uint = 0x94C845;

		// images
		public static const YELLOW : uint = 0xF6DD10;

		// videos
		public static const PINK : uint = 0xED4E9B;

		// documents
		public static const BLUE : uint = 0x47BFB9;

		// interactive
		public static const ORANGE : uint = 0xEA6629;

		// inactive
		public static const INACTIVE_CELL : uint = 0x323232;


		/**
		 * Returns vector of asset type colours
		 */
		public static function getColours():Vector.<uint>
		{
			var vec:Vector.<uint> = new Vector.<uint>();
			vec.push( GREEN );
			vec.push( YELLOW );
			vec.push( PINK );
			vec.push( BLUE );
			vec.push( ORANGE );
			return vec;
		}
	}
}
