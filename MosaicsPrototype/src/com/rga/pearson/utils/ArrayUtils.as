package com.rga.pearson.utils
{
	public class ArrayUtils
	{
		/**
		 * Shuffle array elements.
		 *
		 * @param a The array to shuffle.
		 */
		public static function shuffle(a:Array):Array
		{
			if (a != null)
			{
				var l:int = a.length;
				var i:int = 0;
				var rand:int;
				for (; i < l; i++) {
					var tmp:* = a[int(i)];
					rand = int(Math.random() * l);
					a[int(i)] = a[rand];
					a[int(rand)] = tmp;
				}
			}
			return a;
		}
	}
}