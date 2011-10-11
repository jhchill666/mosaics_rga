package com.rga.pearson.utils
{

	public class NumberUtils
	{

		/**
		 * Returns a weighted random number.
		 */
		public static function weightRandom( min:int, max:int ):Number
		{
			var i:int, j:int, tmp:Array = new Array();

			for( i = min ; i < max ; i ++ )
			{
				for( j = 0 ; j < ( i - min ) ; j ++ )
					tmp.push( i );
			}

			return ArrayUtils.shuffle( tmp )[0];
		}


		/**
		 * Selects a random number from the range specified by min and max values
		 */
		public static function randomRange( min:Number, max:Number ):Number
		{
			return min + Math.floor( Math.random() * ( max + 1 - min ));
		}


		/**
		 * Selects a random number from the range specified by min and max values
		 */
		public static function monteCarlo( min:Number, max:Number ):Number
		{
			var hack:int, numOne:Number, numTwo:Number, y:Number, found:Boolean = false;

			while( !found && hack < 10000 )
			{
				numOne = Math.random();
				numTwo = Math.random();

				y = ( numOne * numOne );

				if( numTwo < y )
				{
					found = true;
					return numOne;
				}
				hack ++;
			}
			return 0;
		}


		/**
		 * Selects a random number from the range specified by min and max values
		 */
		public static function monteCarlo2( min:Number, max:Number, weight:Number ):Number
		{
			/*
			   Not positive, but after a few seconds of thought it seems
			   like doing a random between 0 and 1.3 and the subtracting
			   0.3 from the result and dropping negative values should
			   work - max(0, random(0, 1.3) - 0.3)
			 */

			var random:Number;
			random = NumberUtils.randomRange( min, max + weight );

			return Math.max( 0, random - weight );
		}

	}
}
