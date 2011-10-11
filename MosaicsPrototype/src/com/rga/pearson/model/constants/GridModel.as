package com.rga.pearson.model.constants
{
	import com.rga.pearson.utils.ArrayUtils;
	import com.rga.pearson.utils.NumberUtils;
	import com.rga.pearson.view.grid.GridCellSeqment;

	import de.polygonal.ds.Array2;

	import flash.geom.Point;

	import mx.collections.ArrayCollection;

	import org.robotlegs.mvcs.Actor;

	public class GridModel extends Actor
	{
		public var rowSegments : int = ( GridConstants.NUM_COLS * 2 );

		public var columnSegments : int = ( GridConstants.NUM_ROWS * 2 );

		public var numSegments : int = ( columnSegments * rowSegments );

		public var usableSegments : int = 45;

		private var segments : Array2;


		/**
		 * Returns the colours for each segment
		 *
		 * ( Extrapolate out to include biased distribution colouring )
		 */
		public function getDistribution( current:int, total:int ):Array2
		{
			var i:int, hPos:int, vPos:int;

			return getBottomBiasedDistribution();
		}


		private function getRandomSegement():Point
		{
			var segmentRow:int, segmentCol:int, segment:Point, colour:uint;

			segmentCol = NumberUtils.weightRandom( 0, GridConstants.NUM_COLS*2 );
			segmentRow = NumberUtils.weightRandom( 0, GridConstants.NUM_ROWS*2 );

			segment = new Point( segmentCol, segmentRow );
			colour = segments.get( segment.x, segment.y );

			if( colour != ColourConstants.INACTIVE_CELL )
				getRandomSegement();

			return segment;
		}


		private function getArray2():Array2
		{
			var array2:Array2;

			array2 = new Array2( GridConstants.NUM_COLS*2, GridConstants.NUM_ROWS*2 );
			array2.fill( ColourConstants.INACTIVE_CELL );

			return array2;
		}


		/**
		 * Returns a biased random distribution of segments from bottom to top
		 */
		private function getBottomBiasedDistribution():Array2
		{
			var i:int, j:int, segment:Point;
			segments = getArray2();

			for( i = 0 ; i < numSegments ; i ++ )
			{
				segment = getRandomSegement();
				segments.set( segment.x, segment.y, 0xFFFFFF );
			}

			return segments;
		}


		/**
		 * Returns a random distribution of segments ( temprorary )
		 */
		private function getRandomDistribution():Array
		{
			var i:int, tmp:Array = new Array( numSegments );

			for( i ; i < numSegments/2 ; i ++ )
				tmp[i] = 0xFFFFFF;

			return ArrayUtils.shuffle( tmp );
		}
	}
}
