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
		 * Calculates the percentage of the total
		 *
		 * @param num				The number to calculate as a percentage of the total
		 * @param total				Total amount to calculate percentgae from
		 * @param places			Number of decimal places to include. -1 equals no rounding of decimal places
		 */
		public static function percent( num:Number, total:Number, places:int = -1 ):Number
		{
			return ( num / total );
		}


		/**
		 * Selects a random number from the range specified by min and max values
		 */
		public static function monteCarlo():Number
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
					return numTwo;
				}
				hack ++;
			}
			return 0;
		}


		public static function randomMiddle( strength:int = 2 ):Number
		{
			var r:Number = Math.random();

			if( r < 0.5 )
				return 1 - Math.pow(1 - r, strength) / 2;

			return 0.5 + Math.pow((r - 0.5) * 2, strength) / 2;
		}


		public static function middle(min : Number, max : Number):Number
		{
			var result : Number;
			var c : Number = max - ((max-min)/2);
			var u:Number = Math.random() * 2

			if( u <= 1 )
			{
				result = min + Math.sqrt(u * (max-min) * (c-min));
			}
			else
			{
				result = max - Math.sqrt((u-1) * (max-min) * (max-c));
			}

			return result;
		}


		/**
		 * Utility method to return a random weighting.  The ratio specified determins the weighting
		 * of the randomisation.  Ratio should be a percentage between 0 and 1.  If you specify 70, there
		 * will be a 70% chance that this method returns true.  20 will give a 20% chance.
		 *
		 * @param ratio 		The percentage in favour of the weigth succeding.
		 */
		public static function weight( ratio:Number ):Boolean
		{
			return ( NumberUtils.randomRange( 0, 1 ) < ratio );
		}


		/**
		 * Selects a random number from the range specified by min and max values
		 */
		public static function monteCarlo2( pow:Number = 2, min:Number = 0, max:Number = 1 ):Number
		{
			var random:Number, power:Number;

			random = NumberUtils.randomRange( min, max );
			power = Math.pow( random, pow ) * 100;

			return Math.floor( power );
		}

	}
}
