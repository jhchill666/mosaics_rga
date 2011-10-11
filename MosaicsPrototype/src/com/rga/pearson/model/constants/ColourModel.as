package com.rga.pearson.model.constants
{
	import de.polygonal.ds.Array2;

	import mx.collections.ArrayCollection;

	import org.robotlegs.mvcs.Actor;

	public class ColourModel extends Actor
	{
		/**
		 * Returns the colours for each segment
		 *
		 * ( Extrapolate out to include biased distribution colouring )
		 */
		public function colourDistribution( array:Array2 ):ArrayCollection
		{
			var i:int, hPos:int, vPos:int;

			return getColouredDistribution( array );
		}


		private function getColouredDistribution( array:Array2 ):ArrayCollection
		{
			var split:int, i:int, index:int, arr:Array, colour:uint, colourIndex:int;

			arr = array.toArray();
			split = array.size / 5;

			for( i = 0 ; i < array.size ; i ++ )
			{
				index ++;
				if( index > split )
				{
					index = 0;
					colourIndex ++;
				}

				if( arr[ i ] == ColourConstants.INACTIVE_CELL )
					continue;

				switch( colourIndex )
				{
					case 0:
						colour = ColourConstants.GREEN;
						break;
					case 1:
						colour = ColourConstants.YELLOW;
						break;
					case 2:
						colour = ColourConstants.PINK;
						break;
					case 3:
						colour = ColourConstants.BLUE;
						break;
					case 4:
						colour = ColourConstants.ORANGE;
						break;
				}

//				arr[int( y * _w + x)];

				trace( "Index :: "+i+", Colour :: "+colour+", Count :: "+colourIndex );

				arr[ i ] = colour;
			}
			return new ArrayCollection( arr );
		}
	}
}
