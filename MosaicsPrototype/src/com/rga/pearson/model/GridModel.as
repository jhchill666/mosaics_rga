package com.rga.pearson.model
{
	import com.rga.pearson.model.constants.ColourConstants;
	import com.rga.pearson.model.constants.GridConstants;
	import com.rga.pearson.model.vo.AssetSliderVO;
	import com.rga.pearson.utils.ArrayUtils;
	import com.rga.pearson.utils.NumberUtils;

	import de.polygonal.ds.Array2;
	import de.polygonal.ds.HashMap;

	import org.robotlegs.mvcs.Actor;

	public class GridModel extends Actor
	{
		public var numSegments : int;

		public var activeSegments : int;

		public var usableSegments : int = 45;

		private var segments : Array2;

		private var assetsVo:AssetSliderVO;

		private var cache:HashMap;


		/**
		 * Constructor.
		 */
		public function GridModel()
		{
			numSegments = ( GridConstants.NUM_COLS * 2 ) * GridConstants.NUM_ROWS;
			activeSegments = (( numSegments / 4 ) * 1 );

			assetsVo = new AssetSliderVO();
			assetsVo.total = activeSegments;
			assetsVo.maximum = numSegments;
		}


		//-------------------------------------------
		//
		// Public API
		//
		//-------------------------------------------

		/**
		 * Updates the model with the new configuration of assets
		 */
		public function setAssets( vo:AssetSliderVO ):void
		{
			assetsVo = vo;
		}


		/**
		 * Returns the currently configuired assets
		 */
		public function getAssets():AssetSliderVO
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
			return getBottomBiasedDistribution();
		}


		/**
		 * Updates the current distribution to reflect the new total of segments
		 *
		 * @param total Total number of segments the grid should now display
		 */
		public function updateDistribution( current:int, total:int ):Array2
		{
			if( assetsVo.total > cache.size )
			{
				trace( "Adding "+( assetsVo.total - cache.size )+" to Cache" );

				for( var i:int = 0 ; i < ( assetsVo.total - cache.size ) ; i ++ )
					addNewSegment();
			}
			else
			{
				trace( "Removing "+( cache.size - assetsVo.total )+" from Cache" );

				for( i = 0 ; i < ( cache.size - assetsVo.total ) ; i ++ )
					removeRandomSegment();
			}

			return segments;
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
			var segment:Segment, oldColour:uint, up:Error = new Error( "The Grid has not yet been initialised!!!" );

			if( segments == null )
				throw up; // ha ha!!

			segment = cacheSegment( getRandomSegement() );
			oldColour = segments.get( segment.col, segment.row );
			segments.set( segment.col, segment.row, 0xFFFFFF );

			return segments;
		}


		/**
		 * Removes a randomw Segment from teh cache and turns it off
		 */
		private function removeRandomSegment():Segment
		{
			var index:int, segment:Segment;

			index = Math.random() * cache.size;
			segment = cache.toArray()[index];

			segments.set( segment.col, segment.row, ColourConstants.INACTIVE_CELL );
			cache.remove( segment.id );

			return segment;
		}


		/**
		 * Returns a biased random distribution of segments from bottom to top
		 */
		private function getBottomBiasedDistribution():Array2
		{
			var segment:Segment;
			segments = getArray2();

			for( var i:int = 0 ; i < activeSegments ; i ++ )
				addNewSegment()

			return segments;
		}


		/**
		 * Returns a random distribution of segments ( temprorary )
		 */
		private function getRandomDistribution():Array
		{
			var i:int, tmp:Array = new Array( numSegments );

			for( i ; i < activeSegments ; i ++ )
				tmp[i] = 0xFFFFFF;

			return ArrayUtils.shuffle( tmp );
		}


		/**
		 * Returns a randomly chosen segment.  The randomisation is vertically 'weighted' to the
		 * bottom of the grid, and horizontally weighted to the middle of the grid.
		 */
		private function getRandomSegement():Segment
		{
			var segmentRow:Number, segmentCol:Number, segment:Segment, colour:uint;

			segmentCol = NumberUtils.middle( 0, GridConstants.NUM_COLS * 2 );
			segmentRow = NumberUtils.monteCarlo() * GridConstants.NUM_ROWS;

			segment = new Segment( segmentCol, segmentRow );
			colour = segments.get( segment.col, segment.row );

			if( colour != ColourConstants.INACTIVE_CELL )
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
			var segment:Segment, band:int, neighbours:Vector.<Segment> = new Vector.<Segment>();

			while( neighbours.length == 0 )
			{
//				if( NumberUtils.weight( 1 ))
				band = NumberUtils.randomRange( 4, 6 );

				neighbours = getNearestNeighbours( segment, band );
				band ++;
			}

			return getClosestEmptyNeighbour( segment, neighbours );
		}


		/**
		 * Returns the nearest EMPTY neighbours to the randomly chosen segment
		 *
		 * @param segment 	The randomly chosen segment
		 * @param band		The tier of segment neighbours.  If not empty segments are found in the
		 * neighbours immediately surrounding the segment, band is incremented, to assess the neighbours
		 * on the next tier out from the random segement.
		 */
		private function getNearestNeighbours( segment:Segment, band:int = 1 ):Vector.<Segment>
		{
			var i:int, xIndex:Number, yIndex:Number, neighbours:Vector.<Segment>, segColour:uint;

			neighbours = new Vector.<Segment>();

			for( i = 0 ; i < segments.size ; i ++ )
			{
				xIndex = ( i % ( GridConstants.NUM_COLS * 2 ));
				yIndex = Math.floor( i / ( GridConstants.NUM_ROWS * 2 ));

				if( xIndex < segment.col - band || xIndex > segment.col + band )
					continue;

				if( yIndex < segment.row - band || yIndex > segment.row + band )
					continue;

				segColour = segments.get( xIndex, yIndex ) as uint;

				if( segColour.toString(16) != ColourConstants.INACTIVE_CELL.toString(16))
					continue;

				neighbours.push( new Segment( xIndex, yIndex ));
			}

			return neighbours;
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
			var array:Array, array2:Array2;

			array2 = new Array2( GridConstants.NUM_COLS*2, GridConstants.NUM_ROWS );
			array2.fill( ColourConstants.INACTIVE_CELL );

			return array2;
		}


		/**
		 * Store the selected segment for easy lookup later
		 */
		private function cacheSegment( segment:Segment ):Segment
		{
			if( cache == null )
				cache = new HashMap();

			cache.insert( segment.id, segment )
			return segment;
		}
	}
}

class Segment
{
	public var col : int;

	public var row : int;

	public var id : String;


	public function Segment( col:Number = -1, row:Number = -1 )
	{
		this.col = Math.ceil(col);
		this.row = Math.ceil(row);
		this.id = String( col+":"+row );
	}
}
