package com.rga.pearson.model
{
	import com.rga.pearson.model.constants.ColourConstants;
	import com.rga.pearson.model.constants.GridConstants;
	import com.rga.pearson.model.vo.AssetConfigVO;
	import com.rga.pearson.model.vo.Segment;
	import com.rga.pearson.utils.NumberUtils;
	import com.tiltdigital.data.HashMap;
	
	import de.polygonal.ds.Array2;
	
	import org.robotlegs.mvcs.Actor;

	public class GridModel extends Actor
	{
		private var segments : Array2;

		private var assetsVo:AssetConfigVO;

		private var cache:HashMap;


		/**
		 * Constructor.
		 */
		public function GridModel()
		{
			super();
		}


		//-------------------------------------------
		//
		// Public API
		//
		//-------------------------------------------

		/**
		 * Updates the model with the new configuration of assets
		 */
		public function setAssets( vo:AssetConfigVO ):void
		{
			assetsVo = vo;
		}


		/**
		 * Returns the currently configuired assets
		 */
		public function getAssets():AssetConfigVO
		{
			return assetsVo;
		}


		/**
		 * Returns the colours for each segment
		 *
		 * ( Extrapolate out to include biased distribution colouring )
		 */
		public function getDistribution( current:int, total:int ):Array2
		{
			segments = getArray2();
			
			return getBottomBiasedDistribution();
//			return getRandomDistribution();
		}


		/**
		 * Updates the current distribution to reflect the new total of segments
		 *
		 * @param total Total number of segments the grid should now display
		 */
		public function updateDistribution( current:int, total:int ):Array2
		{
			var i:int, offset:int, func:Function;

			offset = ( assetsVo.active > cache.size())
				? ( assetsVo.active - cache.size() )
				: ( cache.size() - assetsVo.active );
			
			func = ( assetsVo.active > cache.size())
				? addNewSegment
				: removeRandomSegment;

			for( i = 0 ; i < offset ; i ++ )
				func();

			dumpSegments();
			return segments;
		}


		/**
		 * Dumps the active segments to the output for debugging
		 */
		public function dumpSegments():void
		{
			var i:int, segment:Segment, segmentArray:Array, segCount:int = 0;

			trace( "\n\nDumpSegments ::::::::::::::::::::::::::::: " );
			trace( "Total :: "+segments.size );
			trace( "Cache :: "+cache.size() );

			segmentArray = segments.toArray();
			segCount = 0;

			for( i = 0 ; i < segmentArray.length ; i ++ )
			{
				segment = ( segmentArray[i] as Segment );

				if( segment.rawColour == 0xFFFFFF )
				{
					segCount ++;
				}
			}
			trace( "Active :: "+segCount+"\n\n" );
		}


		//-------------------------------------------
		//
		// Private
		//
		//-------------------------------------------

		/**
		 * Adds a new Segment to the previously generated grid
		 *
		 * @throws Error if the grid hasn't yet been initialised
		 */
		private function addNewSegment():Array2
		{
			var segment:Segment;

			if( segments == null )
				segments = getArray2();

			segment = cacheSegment( getRandomSegement() );
			segment.rawColour = 0xFFFFFF;
			segments.set( segment.col, segment.row, segment );

			return segments;
		}


		/**
		 * Removes a randomw Segment from teh cache and turns it off
		 */
		private function removeRandomSegment():Segment
		{
			var index:int, segment:Segment;

			index = Math.random() * cache.size();
			
			segment = cache.getKeys()[ index ];
			segment.rawColour = ColourConstants.INACTIVE_CELL;

			segments.set( segment.col, segment.row, segment );
			cache.remove( segment.id );

			return segment;
		}


		/**
		 * Returns a biased random distribution of segments from bottom to top
		 */
		private function getBottomBiasedDistribution():Array2
		{
			for( var i:int = 0 ; i < assetsVo.active ; i ++ )
				addNewSegment()

			return segments;
		}


		/**
		 * Returns a random distribution of segments ( temprorary )
		 */
		private function getRandomDistribution():Array2
		{
			var i:int, xIndex:int, yIndex:int, index:int, segment:Segment;

			for( i = 0 ; i < assetsVo.active ; i ++ )
			{
				index = Math.random() * ( segments.size - 1 );

				xIndex = ( index % ( GridConstants.NUM_COLS * 2 ));
				yIndex = Math.floor( index / ( GridConstants.NUM_ROWS * 2 ));
				
				segment = cacheSegment( segments.get( xIndex, yIndex ));
				segment.rawColour = 0xFFFFFF;
				
				segments.set( xIndex, yIndex, segment );
			}

			return segments;
		}


		/**
		 * Returns a randomly chosen segment.  The randomisation is vertically 'weighted' to the
		 * bottom of the grid, and horizontally weighted to the middle of the grid.
		 */
		private function getRandomSegement():Segment
		{
			var row:Number, column:Number, segment:Segment, colour:uint;

			column = NumberUtils.middle( 0, GridConstants.NUM_COLS * 2 );
//			column = NumberUtils.randomRange( GridConstants.NUM_COLS - 4, GridConstants.NUM_COLS + 4 );
			row = NumberUtils.monteCarlo() * GridConstants.NUM_ROWS;

			segment = segments.get( column, row );

			if( segment.rawColour != ColourConstants.INACTIVE_CELL )
				segment = findNearestNeighbour( segment );

			return segment;
		}


		/**
		 * Finds the closest neighbour to the randomly chosen segment, that is
		 * not already selected ( it's colour is not ColourConstants.INACTIVE_CELL )
		 *
		 * @param segment 	The randomly chosen segment
		 */
		private function findNearestNeighbour( segment:Segment ):Segment
		{
			var segment:Segment, band:int, neighbour:Segment, neighbours:Vector.<Segment>;

			while( neighbour == null )
			{
				if( NumberUtils.weight( 0.6 ))
					band = NumberUtils.randomRange( 2, 6 );

				neighbour = getAnEmptyNeighbour( segment, band );
				band ++;
			}

			return neighbour;
		}


		/**
		 * Returns the nearest EMPTY neighbours to the randomly chosen segment
		 *
		 * @param segment 	The randomly chosen segment
		 * @param band		The tier of segment neighbours.  If not empty segments are found in the
		 * neighbours immediately surrounding the segment, band is incremented, to assess the neighbours
		 * on the next tier out from the random segement.
		 */
		private function getAnEmptyNeighbour( segment:Segment, band:int = 1 ):Segment
		{
			var i:int, xIndex:int, yIndex:int, neighbours:Vector.<Segment>, segColour:uint, neighbour:Segment;

			neighbours = new Vector.<Segment>();

			for( i = 0 ; i < segments.size ; i ++ )
			{
				xIndex = ( i % ( GridConstants.NUM_COLS * 2 ));
				yIndex = Math.floor( i / ( GridConstants.NUM_ROWS * 2 ));
				
				if( xIndex < segment.col - band || segment.col > xIndex + band )
					continue;

				if( yIndex < segment.row - band || yIndex > segment.row + band )
					continue;

				neighbour = segments.get( xIndex, yIndex ) as Segment

				if( neighbour.rawColour != ColourConstants.INACTIVE_CELL )
					continue;

				return neighbour;
			}

			return null;
		}


		/**
		 * Assesses which of the neighbours is the closest to the segment.  It is likely a number of neighbours will
		 * be equi-distant:  An equally distanced neighbour will assume the title of 'nearest'.
		 *
		 * @param origin		The randomly chosen Segement to find the empty neighbour for
		 * @param neighbours	Vector of empty neighbours to assess distance of
		 */
		private function getClosestEmptyNeighbour( origin:Segment, neighbours:Vector.<Segment> ):Segment
		{
			var i:int, neighbour:Segment, dx:Number, dy:Number, distance:Number, minDistance:Number, nearest:Segment;

			minDistance = 999999;
			nearest = neighbours[0] as Segment;

			for( i = 0 ; i < neighbours.length ; ++i )
			{
				neighbour = ( neighbours[i] as Segment );

				dx = origin.col - neighbour.col;
				dy = origin.row - neighbour.row;
				distance = Math.sqrt(( dx * dx ) + ( dy * dy ));

				if( distance < minDistance )
				{
					nearest = neighbour;
					minDistance = distance;
				}
			}
			return neighbour;
		}


		/**
		 * Constructs a new Two dimensional array, pre-populated with INACTIVE segment colours.
		 *
		 * Because each index horizontally contains two segments - the top left triangle,
		 * and the bottom right triangle, we need to make sure the two dimensional array's width
		 * is multiplied by two.  The Array2 is flatten before being passed back to the grid,
		 * so this does matter, and will still be constructed as an N by N grid on the view.
		 */
		private function getArray2():Array2
		{
			var i:int, xIndex:int, yIndex:int, segment:Segment, array2:Array2;

			array2 = new Array2( GridConstants.NUM_COLS*2, GridConstants.NUM_ROWS );
			
			for( i = 0 ; i < array2.size ; i ++ )
			{
				xIndex = ( i % ( GridConstants.NUM_COLS * 2 ));
				yIndex = Math.floor( i / ( GridConstants.NUM_ROWS * 2 ));
				
				segment = new Segment( xIndex, yIndex );
				array2.set( xIndex, yIndex, segment );
			}

			return array2;
		}


		/**
		 * Store the selected segment for easy lookup later
		 */
		private function cacheSegment( segment:Segment ):Segment
		{
			if( cache == null )
				cache = new HashMap();

			cache.put( segment.id, segment );
			return segment;
		}
	}
}