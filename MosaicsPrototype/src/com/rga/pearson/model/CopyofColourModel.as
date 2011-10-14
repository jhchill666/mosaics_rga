package com.rga.pearson.model
{
	import com.rga.pearson.event.ColourModelEvent;
	import com.rga.pearson.model.colour.ColourRange;
	import com.rga.pearson.model.constants.AssetConstants;
	import com.rga.pearson.model.constants.ColourConstants;
	import com.rga.pearson.model.constants.GridConstants;
	import com.rga.pearson.model.vo.AssetConfigVO;

	import de.polygonal.ds.Array2;

	import mx.collections.ArrayCollection;

	import org.robotlegs.mvcs.Actor;

	public class ColourModel extends Actor
	{
		private var assetsVo:AssetConfigVO;

		private var mergePoints:Vector.<int>;

		private var totalAssets : int;

		public var swatches : Vector.<uint>;


		/**
		 * Returns the colours for each segment
		 *
		 * ( Extrapolate out to include biased distribution colouring )
		 */
		public function colourDistribution( array:Array2, assetsVo:AssetConfigVO ):ArrayCollection
		{
			var spectrum:Vector.<ColourRange>;

			this.assetsVo = assetsVo;

			spectrum = getSpectrum();
			spectrum[0].extrapolate();

			swatches = spectrum[0].getSwatches();
//			swatches = transposeColours2( swatches );

			dispatch( new ColourModelEvent( ColourModelEvent.SWATCHES_UPDATED ));

			return getColouredDistribution2( array, swatches );
		}


		/**
		 * Generates a ColourRange for each assets type.  The ColourRange is responsibile
		 * for blending colours between it and the next ColourRange, taking the merge
		 * percentage into account.
		 */
		private function getSpectrum():Vector.<ColourRange>
		{
			var i:int, range:ColourRange, colours:Vector.<uint>, types:Vector.<String>, spectrum:Vector.<ColourRange> = new Vector.<ColourRange>();

			colours = ColourConstants.getColours();
			types = AssetConstants.getTypes();
			totalAssets = 0;

			for( i = 0 ; i < colours.length ; ++ i )
			{
				range = new ColourRange( colours[i], i );
				range.quantity = assetsVo.getAsset( types[i] );
				totalAssets += range.quantity;

				if( i > 0 )
					spectrum[ i - 1 ].next = range;

				spectrum.push( range );
			}

			return spectrum;
		}


		/*

		   array2 = new Array2( GridConstants.NUM_COLS*2, GridConstants.NUM_ROWS );

		 */

		private function transposeColours( swatches:Vector.<uint> ):Vector.<uint>
		{
			var assets:Vector.<String>, a:int, asset:int, r:int, c:int, transposed:Vector.<uint>, index:int, transIndex:int;

			assets = AssetConstants.getTypes();
			transposed = new Vector.<uint>( swatches.length );
			index = 0;

			try
			{
				for( a = 0 ; a < AssetConstants.size() ; a ++ )
				{
					asset = assetsVo.getAsset( assets[a] );
					for( r = AssetConstants.size() ; r != 0 ; --r )
					{
						for( c = 0 ; c < asset ; c ++ )
						{
							transIndex = r * GridConstants.NUM_COLS + c;
							transposed[ transIndex ] = swatches[ index ];

							index ++
						}
					}
				}
			}
			catch( er:* )
			{
			}

			return transposed;
		}


		/**
		 * Assigns the extrapolated colour swatches to each of the segments
		 */
		private function getColouredDistribution( array:Array2, colours:Vector.<uint> ):ArrayCollection
		{
			var i:int, segCount:int, arr:Array = array.toArray();

			segCount = 0;

			for( i = 0 ; i < arr.length ; i ++ )
			{
				if( arr[ i ] == ColourConstants.INACTIVE_CELL )
					continue;

				if( arr[ i ] == 0xFFFFFF )
				{
					arr[ i ] = colours[segCount];
					segCount ++;
				}
			}
			return new ArrayCollection( arr );
		}


		private function getColouredDistribution2( array:Array2, colours:Vector.<uint> ):ArrayCollection
		{
			var i:int, row:int, col:int, tmp:Array, arr:Array = array.toArray();

			tmp = new Array();
			row = GridConstants.NUM_ROWS;
			col = 0;

			try
			{
				for( i = 0 ; i < arr.length ; i ++ )
				{
					if( row == 0 )
					{
						row = GridConstants.NUM_ROWS;
						col ++;
					}
					else
						row --;

					if( arr[ i ] == 0xFFFFFF )
						arr[ row * GridConstants.NUM_COLS + col ] = swatches[ i ];
					else
						tmp[ i ] = arr[ i ];
				}
			}
			catch( er:* )
			{
			}
			return new ArrayCollection( arr );
		}
	}
}
