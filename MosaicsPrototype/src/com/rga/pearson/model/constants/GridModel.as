package com.rga.pearson.model.constants
{
	import com.rga.pearson.utils.ArrayUtils;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;
	
	public class GridModel extends Actor
	{
		public var numCells : int = ( GridConstants.NUM_ROWS * GridConstants.NUM_COLS );
		public var numSegments : int = ( numCells * 2 );
			
		/**
		 * Returns the colours for each segment
		 * 
		 * ( Extrapolate out to include biased distribution colouring )
		 */
		public function getDistribution ( current:int, total:int ) : ArrayCollection
		{
			return new ArrayCollection( getSegmentColours() );
		}
		
		
		private function getSegmentColours () : Array
		{
			var i:int, subCategoriesPerColour:int, colour:uint, tmp:Array = new Array( numSegments );
			
			subCategoriesPerColour = (( numSegments / 2 ) / 5 );
			
			for( i; i < ( numSegments / 2 ); i ++ )
			{
				switch( i % subCategoriesPerColour )
				{
					case 0 : 
						colour = GridConstants.GREEN;
						break;
					case 1 : 
						colour = GridConstants.YELLOW;
						break;
					case 2 : 
						colour = GridConstants.PINK;
						break;
					case 3 : 
						colour = GridConstants.BLUE;
						break;
					case 4 : 
						colour = GridConstants.ORANGE;
						break;
				}
				tmp[i] = colour;
			}
			return ArrayUtils.shuffle( tmp );
		}
	}
}